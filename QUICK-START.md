# ⚡ Quick Start Guide - TODO to Issue Linker

## 🏃‍♂️ 30-Second Setup

### **Step 1: Build the Extension**
```powershell
cd "C:\Users\Renni\Desktop\TODO to Issue Linker"
.\build.ps1
```

### **Step 2: Test It**
1. **Press F5** in VS Code (opens Extension Development Host)
2. **Open `sample-todos.md`** or **`sample-code-todos.ts`** in the new window
3. **Look for "🔗 Create GitHub Issue" links** above TODO items
4. **Click a link** to test (will try to open GitHub)

### **Step 3: Install for Daily Use**
```powershell
# Install the .vsix file created by build.ps1
# In VS Code: Ctrl+Shift+P → "Extensions: Install from VSIX"
```

## 🎯 **What You'll See**

### **In Your Files:**
**Markdown:**
```markdown
TODO: Add user authentication
🔗 Create GitHub Issue    <- Click this link

FIXME: Fix mobile navigation bug  
🔗 Create GitHub Issue    <- And this one

<!-- TODO: Update API documentation -->
🔗 Create GitHub Issue    <- Even HTML comments
```

**TypeScript/JavaScript:**
```typescript
export class UserService {
  // TODO: Implement dependency injection
  🔗 Create GitHub Issue    <- Click this link
  
  /* FIXME: Remove hardcoded values */
  🔗 Create GitHub Issue    <- And this one
}
```

**Python:**
```python
class UserManager:
    # TODO: Add configuration management
    🔗 Create GitHub Issue    <- Click this link
    
    def get_user(self, user_id):
        """
        TODO: Add proper docstring
        🔗 Create GitHub Issue    <- Works in docstrings too
        """
```

### **When You Click:**
- **Auto-detects** your GitHub repository from `git remote origin`
- **Opens browser** to GitHub's "new issue" page
- **Pre-fills** title with your TODO text
- **Includes** file name and line number in description
- **Adds** default labels like "todo" and "enhancement"

## 🔧 **Quick Configuration**

### **Manual Repository (if auto-detection fails):**
```json
// In VS Code Settings (Ctrl+,)
{
  "todoIssueLinker.githubRepository": "your-username/your-repo"
}
```

### **Custom TODO Patterns:**
```json
{
  "todoIssueLinker.todoPatterns": [
    "TODO:",
    "FIXME:", 
    "NOTE:",
    "IMPROVEMENT:"
  ]
}
```

## 🚀 **Ready to Publish?**

```powershell
# Publish to VS Code Marketplace
.\publish.ps1
```

## 🎉 **Success Indicators**

✅ **Build successful** - `.vsix` file created  
✅ **CodeLens showing** - "🔗 Create GitHub Issue" links visible  
✅ **Repository detected** - No error messages about missing repo  
✅ **GitHub opens** - Clicking links opens new issue page  
✅ **Pre-filled correctly** - Title and description populated  

## 🆘 **Quick Troubleshooting**

### **No CodeLens links showing?**
- Make sure you're in a **Markdown (.md) file**
- Check that TODOs match the patterns (default: `TODO:`, `FIXME:`, etc.)
- Try **"Refresh TODO CodeLens"** command

### **"No GitHub repository found"?**
- Run `git remote -v` to check if you have a GitHub remote
- Manually set `todoIssueLinker.githubRepository` in settings
- Use format: "owner/repo" (e.g., "microsoft/vscode")

### **Links not working?**
- Check your internet connection
- Verify GitHub repository exists and is accessible
- Try the "Open GitHub Repository" command

## 🎯 **Perfect For**

- **Code TODOs** in any programming language (TypeScript, Python, Java, etc.)
- **Project documentation** with TODO items in Markdown
- **Code review notes** that need tracking in issues
- **Sprint planning** with task lists
- **Team collaboration** on GitHub projects
- **Technical debt** tracking across codebases

**Your TODO to Issue Linker is ready to streamline your development workflow!** 🔗✨