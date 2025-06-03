# Quick JSON Validation Test
Write-Host "🧪 Testing JSON syntax fixes..." -ForegroundColor Green

# Test package.json syntax
Write-Host "1. Validating package.json..." -ForegroundColor Blue
try {
    $packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json
    Write-Host "✅ package.json is now valid JSON!" -ForegroundColor Green
    
    # Check author fields
    if ($packageJson.author.name -and $packageJson.author.email) {
        Write-Host "✅ Author name: $($packageJson.author.name)" -ForegroundColor Green
        Write-Host "✅ Author email: $($packageJson.author.email)" -ForegroundColor Green
    }
    
    # Check if icon field is removed
    if (-not $packageJson.icon) {
        Write-Host "✅ SVG icon field removed (as expected)" -ForegroundColor Green
    }
    
    # Check TODO patterns
    $patterns = $packageJson.contributes.configuration.properties.'todoIssueLinker.todoPatterns'.default
    Write-Host "✅ TODO patterns count: $($patterns.Count)" -ForegroundColor Green
    
} catch {
    Write-Host "❌ package.json still has errors: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test TypeScript compilation
Write-Host ""
Write-Host "2. Testing TypeScript compilation..." -ForegroundColor Blue
npm run compile

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ TypeScript compilation successful!" -ForegroundColor Green
} else {
    Write-Host "❌ TypeScript compilation failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 JSON syntax errors should now be fixed!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Next steps:" -ForegroundColor Yellow
Write-Host "1. Create a PNG icon (run .\create-icon.ps1 for instructions)" -ForegroundColor White
Write-Host "2. Add icon back to package.json: \"icon\": \"images/icon.png\"" -ForegroundColor White
Write-Host "3. Test the extension with F5" -ForegroundColor White

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")