# TODO to Issue Linker

🔗 **One-click conversion of TODO comments to GitHub issues!**

A lightweight VS Code extension that finds TODO comments in your **code files and Markdown** and creates GitHub issues instantly with pre-filled titles and descriptions.

## ✨ Features

### 🎯 **Universal TODO Detection**
- **Multiple Languages**: TypeScript, JavaScript, Python, Java, C#, C++, Go, Rust, PHP, Ruby, HTML, CSS, and more
- **Markdown Support**: Documentation TODOs in `.md` files
- **Various Formats**: `TODO:`, `FIXME:`, `BUG:`, `HACK:`, `NOTE:`, `XXX:`
- **Comment Styles**: `//`, `/* */`, `#`, `<!-- -->`, `'''`, `"""`

### 🔗 **One-Click GitHub Integration**
- **CodeLens Links**: Shows "🔗 Create GitHub Issue" above each TODO
- **Context Menu**: Right-click any TODO text for instant issue creation
- **Keyboard Shortcut**: `Ctrl+Shift+I` (or `Cmd+Shift+I` on Mac)

### 🤖 **Smart Repository Detection**
- Auto-detects GitHub repository from `git remote origin`
- Manual override in settings for custom repositories
- Supports various GitHub URL formats (SSH, HTTPS)

### ⚙️ **Rich Configuration**
- Custom TODO patterns with regex support
- Default issue labels (e.g., "todo", "enhancement")
- Include file name and line number in issue description
- Enable/disable CodeLens integration

## 🚀 Quick Start

### **Step 1: Install Extension**
Install from VS Code Marketplace or load the `.vsix` file.

### **Step 2: Open Any Code File**
Open any supported file type (TypeScript, JavaScript, Python, etc.) or Markdown file in a repository with GitHub remote.

### **Step 3: Add TODOs**
Write TODOs in your files:

**Markdown:**
```markdown
# My Project

## Tasks
- TODO: Add user authentication
- FIXME: Fix responsive design issues
- BUG: Navigation menu not working on mobile

<!-- TODO: Update documentation -->
```

**TypeScript/JavaScript:**
```typescript
export class UserService {
  constructor() {
    // TODO: Implement dependency injection
    // FIXME: Remove hardcoded values
    // BUG: Memory leak in event listeners
  }
  
  /* TODO: Add proper error handling */
  async getUser(id: string) {
    // TODO: Add input validation
    return { id, name: 'User' };
  }
}
```

**Python:**
```python
class UserManager:
    def __init__(self):
        # TODO: Add configuration management
        # FIXME: Remove hardcoded connection
        # BUG: Connection pooling missing
        pass
        
    def get_user(self, user_id):
        """
        TODO: Add proper docstring
        FIXME: Improve error handling
        """
        return {'id': user_id}
```

### **Step 4: Create Issues**
- **Option 1**: Click the "🔗 Create GitHub Issue" CodeLens link above any TODO
- **Option 2**: Right-click TODO text → "🔗 Create Issue from Selected TODO"
- **Option 3**: Select TODO text → Press `Ctrl+Shift+I`

## 🎯 How It Works

### **TODO Detection**
The extension scans your files for patterns like:

**JavaScript/TypeScript:**
```javascript
// TODO: Add new feature
// FIXME: Fix this bug
/* TODO: Refactor this code */
/* BUG: Memory leak here */
```

**Python:**
```python
# TODO: Implement caching
# FIXME: Optimize query
"""
TODO: Add comprehensive docstring
FIXME: Handle edge cases
"""
```

**Markdown:**
```markdown
<!-- TODO: Update docs -->
<!-- FIXME: Fix broken links -->
# TODO: Write tests
- TODO: Add examples
```

**And many more languages** with their respective comment styles!

### **GitHub Issue Creation**
When you click "Create Issue", the extension:
1. **Detects Repository**: Reads `git remote origin` URL
2. **Constructs URL**: Builds GitHub "new issue" URL
3. **Pre-fills Data**: Adds TODO text as title, file info as description
4. **Opens Browser**: GitHub's new issue page with everything ready

### **Example Generated Issue**
From this TODO:
```markdown
TODO: Add user registration flow
```

Creates GitHub issue with:
- **Title**: "Add user registration flow"
- **Body**: "From: README.md (line 15)\\n\\nTODO: Add user registration flow"
- **Labels**: "todo", "enhancement" (configurable)

## ⚙️ Configuration

Access settings via `File > Preferences > Settings` → Search "TODO Issue Linker":

### **Repository Settings**
```json
{
  "todoIssueLinker.githubRepository": "owner/repo"
}
```
*Override auto-detection with specific repository*

### **TODO Patterns**
```json
{
  "todoIssueLinker.todoPatterns": [
    "TODO:",
    "FIXME:",
    "BUG:",
    "HACK:",
    "NOTE:",
    "//\\\\s*TODO:",
    "<!--\\\\s*TODO:"
  ]
}
```
*Regular expressions to match TODO items*

### **Issue Configuration**
```json
{
  "todoIssueLinker.issueLabels": ["todo", "enhancement", "documentation"],
  "todoIssueLinker.includeFileInfo": true,
  "todoIssueLinker.enableCodeLens": true
}
```

## 🎨 User Interface

### **CodeLens Integration**
```markdown
TODO: Implement user dashboard
🔗 Create GitHub Issue    <- Click to create issue
```

### **Context Menu**
Right-click any TODO text to see:
- 🔗 Create Issue from Selected TODO
- (other standard VS Code options)

### **Command Palette**
Press `Ctrl+Shift+P` and search:
- "TODO: Create GitHub Issue from TODO"
- "TODO: Open GitHub Repository"
- "TODO: Refresh TODO CodeLens"

## 🛠️ Use Cases

### **Project Planning**
```markdown
# Sprint Planning

## Backend Tasks
- TODO: Set up user authentication API
- TODO: Create database migrations
- FIXME: Optimize slow query in user service

## Frontend Tasks  
- TODO: Design user registration form
- BUG: Login button not working on Safari
- TODO: Add loading states to all forms
```

### **Documentation TODOs**
```markdown
# API Documentation

<!-- TODO: Add examples for all endpoints -->
<!-- FIXME: Update authentication section -->
<!-- TODO: Add error code reference -->
```

### **Code Review Notes**
```markdown
# Code Review Notes

## Issues Found
- TODO: Extract this logic into a separate function
- FIXME: This method is doing too many things
- BUG: Memory leak in event listeners
```

## 🚀 Workflow Integration

### **Development Process**
1. **Write TODOs** while coding or reviewing
2. **Convert to Issues** during planning sessions
3. **Track Progress** in GitHub Issues
4. **Close Issues** when TODO is completed

### **Team Collaboration**
- **Document TODOs** in Markdown files
- **Create Issues** for team members
- **Assign Labels** for categorization
- **Link to Files** for context

## 🎯 Supported TODO Formats

| Format | Example | Detected |
|--------|---------|----------|
| Standard | `TODO: Fix this` | ✅ |
| Comment | `<!-- TODO: Update -->` | ✅ |
| Code Style | `// TODO: Refactor` | ✅ |
| Markdown | `# TODO: Write docs` | ✅ |
| FIXME | `FIXME: Bug here` | ✅ |
| BUG | `BUG: Not working` | ✅ |
| HACK | `HACK: Temporary fix` | ✅ |
| Custom | *Configure your own* | ⚙️ |

## 🔧 Troubleshooting

### **No Repository Found**
- **Check Git Remote**: Run `git remote -v` in terminal
- **Manual Configuration**: Set `todoIssueLinker.githubRepository` in settings
- **Repository Format**: Use "owner/repo" format (e.g., "microsoft/vscode")

### **TODOs Not Detected**
- **File Type**: Works with multiple languages (TypeScript, JavaScript, Python, etc.) and Markdown
- **Pattern Matching**: Check `todoIssueLinker.todoPatterns` in settings
- **Comment Style**: Ensure TODOs match language-specific comment patterns
- **Refresh CodeLens**: Use "Refresh TODO CodeLens" command

### **CodeLens Not Showing**
- **Enable Setting**: Check `todoIssueLinker.enableCodeLens` is true
- **Restart VS Code**: Reload window after configuration changes
- **File Language**: Ensure file is detected as a supported language
- **Supported Languages**: TypeScript, JavaScript, Python, Java, C#, C++, Go, Rust, PHP, Ruby, HTML, CSS, Markdown

## 🤝 Contributing

Found a bug or want a feature? 

1. **Issues**: Report at [GitHub Issues](https://github.com/gingerturtle-dev/todo-to-issue-linker/issues)
2. **Features**: Suggest improvements via issues
3. **Pull Requests**: Contributions welcome!

## 📄 License

MIT License - see LICENSE file for details.

---

## ☕ Like This Extension?

**Support its development** and keep it free for everyone:

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-☕-orange?style=flat&logo=buy-me-a-coffee)](https://buymeacoffee.com/gingerturtle)

---

## 🎉 Changelog

### Version 1.0.0
- Initial release
- **Multi-language TODO detection**: TypeScript, JavaScript, Python, Java, C#, C++, Go, Rust, PHP, Ruby, HTML, CSS, Markdown
- **Smart comment pattern recognition**: `//`, `/* */`, `#`, `<!-- -->`, `"""`, `'''`
- GitHub repository auto-detection
- CodeLens integration
- Context menu support
- Configurable TODO patterns with regex support
- Issue pre-filling with file context
- Keyboard shortcut support (`Ctrl+Shift+I`)
- Universal TODO formats: `TODO:`, `FIXME:`, `BUG:`, `HACK:`, `NOTE:`, `XXX:`

---

**Made with ❤️ for developers who turn TODOs into action!**