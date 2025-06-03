# Changelog

All notable changes to the "TODO to Issue Linker" extension will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-06-03

### Added
- Initial release of TODO to Issue Linker
- **Smart TODO Detection**: Finds various TODO formats in Markdown files
- **CodeLens Integration**: Shows "🔗 Create GitHub Issue" links above TODO items
- **Context Menu Support**: Right-click TODO text for issue creation
- **Keyboard Shortcut**: `Ctrl+Shift+I` (or `Cmd+Shift+I` on Mac) for selected TODOs
- **GitHub Repository Auto-Detection**: Reads git remote origin automatically
- **Manual Repository Override**: Configure custom GitHub repositories in settings
- **Configurable TODO Patterns**: Support for custom regex patterns
- **Issue Pre-filling**: Includes file name, line number, and TODO text
- **Default Labels**: Automatically adds configurable labels to issues
- **Welcome Message**: First-time user guidance
- **Sponsor Integration**: Buy Me a Coffee support

### Features
- **TODO Format Support**:
  - `TODO:` - Standard TODO format
  - `FIXME:` - Fix-me items
  - `BUG:` - Bug reports
  - `HACK:` - Temporary workarounds
  - `<!-- TODO: -->` - HTML comment style
  - `// TODO:` - Code comment style  
  - `# TODO:` - Markdown header style
  - Custom patterns via regex

- **GitHub Integration**:
  - Auto-detection from git remote URL
  - Support for SSH and HTTPS GitHub URLs
  - Manual repository configuration
  - Pre-filled issue titles and descriptions
  - Configurable issue labels
  - Direct browser opening to GitHub new issue page

- **VS Code Integration**:
  - CodeLens provider for Markdown files
  - Context menu commands
  - Command Palette integration
  - Keyboard shortcuts
  - Settings configuration
  - Welcome message for new users

### Configuration Options
- `todoIssueLinker.githubRepository`: Override repository detection
- `todoIssueLinker.todoPatterns`: Custom TODO regex patterns
- `todoIssueLinker.enableCodeLens`: Toggle CodeLens display
- `todoIssueLinker.issueLabels`: Default labels for created issues
- `todoIssueLinker.includeFileInfo`: Include file context in issues

### Commands
- `todoIssueLinker.createIssue`: Create issue from specific TODO
- `todoIssueLinker.createIssueFromSelection`: Create issue from selected text
- `todoIssueLinker.openRepository`: Open GitHub repository in browser
- `todoIssueLinker.refreshCodeLens`: Refresh TODO detection
- `todoIssueLinker.sponsor`: Support extension development

### Technical Details
- **Target Platform**: VS Code 1.74.0+
- **Language Support**: Markdown files (.md)
- **Dependencies**: Minimal (only VS Code API and Node.js built-ins)
- **Performance**: Lightweight, on-demand TODO scanning
- **Error Handling**: Graceful fallbacks for repository detection

## [Planned] - Future Versions

### 1.1.0 - Enhanced Language Support
- Support for additional file types (TypeScript, JavaScript, Python, etc.)
- Language-specific comment pattern detection
- Multi-language TODO detection in single files

### 1.2.0 - Advanced GitHub Features
- GitHub authentication integration
- Automatic issue assignment
- Custom issue templates
- Milestone and project integration

### 1.3.0 - Team Collaboration
- Bulk TODO to issue conversion
- TODO priority detection and labeling
- Integration with other issue trackers (GitLab, Jira)
- Team workflow templates

### 1.4.0 - Analytics and Reporting
- TODO completion tracking
- Team productivity metrics
- TODO aging reports
- Integration with time tracking tools