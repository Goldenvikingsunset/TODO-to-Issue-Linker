# Test TypeScript Regex Fix
Write-Host "🔧 Testing TypeScript regex syntax fix..." -ForegroundColor Green

Write-Host ""
Write-Host "1. Testing TypeScript compilation..." -ForegroundColor Blue

# Clean previous build
if (Test-Path "out") {
    Remove-Item "out" -Recurse -Force
    Write-Host "🧹 Cleaned previous build output" -ForegroundColor Gray
}

# Compile TypeScript
npm run compile

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ TypeScript compilation successful!" -ForegroundColor Green
    
    # Check compiled output
    if (Test-Path "out\extension.js") {
        Write-Host "✅ Extension compiled: out\extension.js" -ForegroundColor Green
        
        # Check file size (should be reasonable)
        $fileSize = (Get-Item "out\extension.js").Length
        Write-Host "📊 Compiled size: $([math]::Round($fileSize/1024, 2)) KB" -ForegroundColor Gray
        
        # Quick syntax check of output
        $compiledContent = Get-Content "out\extension.js" -Raw
        if ($compiledContent.Contains("github.com") -and $compiledContent.Contains("parseGitHubUrl")) {
            Write-Host "✅ GitHub URL parsing functions present in compiled output" -ForegroundColor Green
        }
    } else {
        Write-Host "❌ Extension file not found in output" -ForegroundColor Red
    }
    
    if (Test-Path "out\extension.js.map") {
        Write-Host "✅ Source map generated: out\extension.js.map" -ForegroundColor Green
    }
    
} else {
    Write-Host "❌ TypeScript compilation still failing" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔍 Check for remaining syntax errors above" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "2. Validating regex patterns..." -ForegroundColor Blue

# Test the regex patterns work correctly
try {
    # Read the source file to check regex syntax
    $sourceContent = Get-Content "src\extension.ts" -Raw
    
    if ($sourceContent.Contains("/github\.com[:\/]") -and 
        $sourceContent.Contains("/github\.com\/")) {
        Write-Host "✅ Regex patterns look correct in source" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Regex patterns may need review" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "⚠️ Could not validate regex patterns: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
if ($LASTEXITCODE -eq 0) {
    Write-Host "🎉 All TypeScript errors fixed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Ready to test the extension:" -ForegroundColor Yellow
    Write-Host "1. Press F5 in VS Code to launch Extension Development Host" -ForegroundColor White
    Write-Host "2. Open a project with a GitHub repository" -ForegroundColor White
    Write-Host "3. Open sample files (sample-todos.md, sample-code-todos.ts)" -ForegroundColor White
    Write-Host "4. Look for '🔗 Create GitHub Issue' CodeLens links" -ForegroundColor White
    Write-Host "5. Test right-click context menu and Ctrl+Shift+I" -ForegroundColor White
    Write-Host ""
    Write-Host "📦 Ready to package:" -ForegroundColor Cyan
    Write-Host "   .\build.ps1" -ForegroundColor White
} else {
    Write-Host "❌ Still need to resolve compilation errors" -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")