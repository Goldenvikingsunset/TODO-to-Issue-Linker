import * as vscode from 'vscode';
import * as path from 'path';
import { execSync } from 'child_process';

interface TodoItem {
  text: string;
  line: number;
  range: vscode.Range;
  pattern: string;
}

interface GitHubRepo {
  owner: string;
  repo: string;
}

class TodoCodeLensProvider implements vscode.CodeLensProvider {
  private _onDidChangeCodeLenses: vscode.EventEmitter<void> = new vscode.EventEmitter<void>();
  public readonly onDidChangeCodeLenses: vscode.Event<void> = this._onDidChangeCodeLenses.event;

  constructor(private gitHubService: GitHubService) {}

  public refresh(): void {
    this._onDidChangeCodeLenses.fire();
  }

  public provideCodeLenses(document: vscode.TextDocument): vscode.CodeLens[] | undefined {
    const config = vscode.workspace.getConfiguration('todoIssueLinker');
    if (!config.get<boolean>('enableCodeLens', true)) {
      return undefined;
    }

    const todos = this.findTodos(document);
    const codeLenses: vscode.CodeLens[] = [];

    for (const todo of todos) {
      const lens = new vscode.CodeLens(todo.range);
      lens.command = {
        title: '🔗 Create GitHub Issue',
        command: 'todoIssueLinker.createIssue',
        arguments: [todo, document.uri]
      };
      codeLenses.push(lens);
    }

    return codeLenses;
  }

  private findTodos(document: vscode.TextDocument): TodoItem[] {
    const config = vscode.workspace.getConfiguration('todoIssueLinker');
    const patterns = config.get<string[]>('todoPatterns', ['TODO:', 'FIXME:']);
    const todos: TodoItem[] = [];

    for (let i = 0; i < document.lineCount; i++) {
      const line = document.lineAt(i);
      const text = line.text;

      for (const pattern of patterns) {
        try {
          const regex = new RegExp(pattern, 'i');
          const match = text.match(regex);
          
          if (match) {
            const todoText = text.substring(match.index! + match[0].length).trim();
            if (todoText) {
              const range = new vscode.Range(i, 0, i, text.length);
              todos.push({
                text: todoText,
                line: i + 1,
                range: range,
                pattern: match[0]
              });
            }
          }
        } catch (error) {
          // Skip invalid regex patterns
          console.warn(`Invalid TODO pattern: ${pattern}`);
        }
      }
    }

    return todos;
  }
}

class GitHubService {
  private cachedRepo: GitHubRepo | null = null;

  public async getRepository(): Promise<GitHubRepo | null> {
    // Check for manual override first
    const config = vscode.workspace.getConfiguration('todoIssueLinker');
    const manualRepo = config.get<string>('githubRepository');
    
    if (manualRepo && manualRepo.includes('/')) {
      const [owner, repo] = manualRepo.split('/');
      return { owner: owner.trim(), repo: repo.trim() };
    }

    // Use cached result if available
    if (this.cachedRepo) {
      return this.cachedRepo;
    }

    // Try to detect from git remote
    try {
      const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
      if (!workspaceFolder) {
        return null;
      }

      const cwd = workspaceFolder.uri.fsPath;
      const remoteUrl = execSync('git remote get-url origin', { 
        cwd, 
        encoding: 'utf8',
        timeout: 5000 
      }).trim();

      const repo = this.parseGitHubUrl(remoteUrl);
      this.cachedRepo = repo;
      return repo;
    } catch (error) {
      console.warn('Could not detect GitHub repository:', error);
      return null;
    }
  }

  private parseGitHubUrl(url: string): GitHubRepo | null {
    // Handle various GitHub URL formats
    const patterns = [
      /github\.com[:\/]([^\/]+)\/([^\/]+?)(?:\.git)?$/,  // SSH and HTTPS
      /github\.com\/([^\/]+)\/([^\/]+)/                  // Browser URL
    ];

    for (const pattern of patterns) {
      const match = url.match(pattern);
      if (match) {
        return {
          owner: match[1],
          repo: match[2].replace(/\.git$/, '')
        };
      }
    }

    return null;
  }

  public async createIssueUrl(todo: TodoItem, filePath: string): Promise<string | null> {
    const repo = await this.getRepository();
    if (!repo) {
      return null;
    }

    const config = vscode.workspace.getConfiguration('todoIssueLinker');
    const includeFileInfo = config.get<boolean>('includeFileInfo', true);
    const labels = config.get<string[]>('issueLabels', ['todo']);

    // Construct issue title
    const title = encodeURIComponent(todo.text);
    
    // Construct issue body
    let body = '';
    if (includeFileInfo) {
      const fileName = path.basename(filePath);
      body = encodeURIComponent(`From: ${fileName} (line ${todo.line})\\n\\nTODO: ${todo.text}`);
    }

    // Construct labels
    const labelString = labels.map(label => encodeURIComponent(label)).join(',');

    // Build GitHub URL
    let url = `https://github.com/${repo.owner}/${repo.repo}/issues/new?title=${title}`;
    
    if (body) {
      url += `&body=${body}`;
    }
    
    if (labelString) {
      url += `&labels=${labelString}`;
    }

    return url;
  }

  public async getRepositoryUrl(): Promise<string | null> {
    const repo = await this.getRepository();
    return repo ? `https://github.com/${repo.owner}/${repo.repo}` : null;
  }

  public clearCache(): void {
    this.cachedRepo = null;
  }
}

export function activate(context: vscode.ExtensionContext) {
  console.log('TODO to Issue Linker extension is now active!');

  const gitHubService = new GitHubService();
  const codeLensProvider = new TodoCodeLensProvider(gitHubService);

  // Register CodeLens provider for multiple languages
  const supportedLanguages = [
    'markdown', 'typescript', 'javascript', 'python', 'java', 'csharp', 
    'cpp', 'c', 'go', 'rust', 'php', 'ruby', 'html', 'css', 'scss', 'vue', 'react'
  ];
  
  const codeLensDisposables = supportedLanguages.map(language => 
    vscode.languages.registerCodeLensProvider(
      { scheme: 'file', language },
      codeLensProvider
    )
  );

  // Register commands
  const commands = [
    vscode.commands.registerCommand('todoIssueLinker.createIssue', async (todo: TodoItem, uri: vscode.Uri) => {
      await createIssueFromTodo(gitHubService, todo, uri.fsPath);
    }),

    vscode.commands.registerCommand('todoIssueLinker.createIssueFromSelection', async () => {
      await createIssueFromSelection(gitHubService);
    }),

    vscode.commands.registerCommand('todoIssueLinker.openRepository', async () => {
      const repoUrl = await gitHubService.getRepositoryUrl();
      if (repoUrl) {
        vscode.env.openExternal(vscode.Uri.parse(repoUrl));
      } else {
        vscode.window.showErrorMessage('No GitHub repository found. Check your git remote or configure manually in settings.');
      }
    }),

    vscode.commands.registerCommand('todoIssueLinker.refreshCodeLens', () => {
      gitHubService.clearCache();
      codeLensProvider.refresh();
      vscode.window.showInformationMessage('TODO CodeLens refreshed!');
    }),

    vscode.commands.registerCommand('todoIssueLinker.sponsor', async () => {
      const sponsorUrl = 'https://buymeacoffee.com/gingerturtle';
      const choice = await vscode.window.showInformationMessage(
        '☕ Enjoying the TODO to Issue Linker?',
        {
          modal: false,
          detail: 'Your support helps keep this extension free and actively maintained!'
        },
        'Buy Me a Coffee ☕',
        'Maybe Later'
      );
      
      if (choice === 'Buy Me a Coffee ☕') {
        vscode.env.openExternal(vscode.Uri.parse(sponsorUrl));
      }
    })
  ];

  // Watch for configuration changes
  const configWatcher = vscode.workspace.onDidChangeConfiguration(e => {
    if (e.affectsConfiguration('todoIssueLinker')) {
      gitHubService.clearCache();
      codeLensProvider.refresh();
    }
  });

  context.subscriptions.push(...codeLensDisposables, configWatcher, ...commands);

  // Show welcome message on first activation
  showWelcomeMessage(context);
}

async function createIssueFromTodo(gitHubService: GitHubService, todo: TodoItem, filePath: string) {
  try {
    const issueUrl = await gitHubService.createIssueUrl(todo, filePath);
    
    if (!issueUrl) {
      const choice = await vscode.window.showErrorMessage(
        'No GitHub repository found. Would you like to configure one?',
        'Open Settings',
        'Cancel'
      );
      
      if (choice === 'Open Settings') {
        vscode.commands.executeCommand('workbench.action.openSettings', 'todoIssueLinker.githubRepository');
      }
      return;
    }

    // Confirm before opening browser
    const choice = await vscode.window.showInformationMessage(
      `Create GitHub issue: "${todo.text}"?`,
      { modal: false },
      'Create Issue',
      'Copy URL',
      'Cancel'
    );

    if (choice === 'Create Issue') {
      vscode.env.openExternal(vscode.Uri.parse(issueUrl));
      vscode.window.showInformationMessage('GitHub issue page opened in browser');
    } else if (choice === 'Copy URL') {
      vscode.env.clipboard.writeText(issueUrl);
      vscode.window.showInformationMessage('Issue URL copied to clipboard');
    }
  } catch (error) {
    vscode.window.showErrorMessage(`Error creating issue: ${error}`);
  }
}

async function createIssueFromSelection(gitHubService: GitHubService) {
  const editor = vscode.window.activeTextEditor;
  if (!editor) {
    vscode.window.showWarningMessage('Please open a file and select a TODO item');
    return;
  }

  const selection = editor.selection;
  const selectedText = editor.document.getText(selection).trim();
  
  if (!selectedText) {
    vscode.window.showWarningMessage('Please select a TODO item to convert to an issue');
    return;
  }

  // Create a TodoItem from selection
  const todo: TodoItem = {
    text: selectedText.replace(/^(TODO:|FIXME:|BUG:|HACK:|NOTE:|XXX:)\s*/i, ''),
    line: selection.start.line + 1,
    range: selection,
    pattern: 'Selected'
  };

  await createIssueFromTodo(gitHubService, todo, editor.document.uri.fsPath);
}

async function showWelcomeMessage(context: vscode.ExtensionContext) {
  const hasShownWelcome = context.globalState.get<boolean>('hasShownWelcome', false);
  
  if (!hasShownWelcome) {
    const choice = await vscode.window.showInformationMessage(
      '🎉 TODO to Issue Linker is ready! Find TODOs in any code file or Markdown and create GitHub issues with one click.',
      'Learn More',
      'Open Settings',
      'Got It'
    );

    if (choice === 'Learn More') {
      vscode.env.openExternal(vscode.Uri.parse('https://github.com/gingerturtle-dev/todo-to-issue-linker#readme'));
    } else if (choice === 'Open Settings') {
      vscode.commands.executeCommand('workbench.action.openSettings', 'todoIssueLinker');
    }

    context.globalState.update('hasShownWelcome', true);
  }
}

export function deactivate() {}