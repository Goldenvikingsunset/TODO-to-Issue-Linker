# TODO to Issue Linker Build Script
Write-Host "🔗 Building TODO to Issue Linker Extension..." -ForegroundColor Green

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js required. Download: https://nodejs.org/" -ForegroundColor Red
    exit 1
}

# Install dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Blue
npm install --save-dev @types/vscode@^1.74.0 @types/node@^16.18.0 typescript@^4.9.4 vsce@^2.15.0

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

# Compile TypeScript
Write-Host "🔨 Compiling TypeScript..." -ForegroundColor Blue
npm run compile

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ TypeScript compilation failed" -ForegroundColor Red
    exit 1
}

# Install and package
Write-Host "📦 Packaging extension..." -ForegroundColor Blue
if (-not (Get-Command vsce -ErrorAction SilentlyContinue)) {
    Write-Host "📥 Installing VSCE..." -ForegroundColor Blue
    npm install -g vsce
}

vsce package

if ($LASTEXITCODE -eq 0) {
    Write-Host "🎉 Extension packaged successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📁 Generated .vsix file:" -ForegroundColor Cyan
    Get-ChildItem -Name "*.vsix" | ForEach-Object { Write-Host "  • $_" -ForegroundColor White }
    Write-Host ""
    Write-Host "🎯 To test the extension:" -ForegroundColor Yellow
    Write-Host "1. Press F5 to launch Extension Development Host" -ForegroundColor White
    Write-Host "2. Open a Markdown file with TODOs" -ForegroundColor White
    Write-Host "3. Look for CodeLens links above TODO items" -ForegroundColor White
    Write-Host ""
    Write-Host "📝 To install: Ctrl+Shift+P → 'Extensions: Install from VSIX'" -ForegroundColor Yellow
} else {
    Write-Host "❌ Packaging failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")