# Test TypeScript Configuration Fix
Write-Host "🔧 Testing TypeScript configuration fix..." -ForegroundColor Green

Write-Host ""
Write-Host "1. Checking tsconfig.json..." -ForegroundColor Blue
try {
    $tsconfig = Get-Content "tsconfig.json" -Raw | ConvertFrom-Json
    
    if ($tsconfig.include -contains "src/**/*") {
        Write-Host "✅ Include path is correctly set to 'src/**/*'" -ForegroundColor Green
    } else {
        Write-Host "❌ Include path not set correctly" -ForegroundColor Red
    }
    
    if ($tsconfig.exclude -contains "sample-*.ts") {
        Write-Host "✅ Sample TypeScript files excluded" -ForegroundColor Green
    } else {
        Write-Host "❌ Sample files not excluded" -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Error reading tsconfig.json: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "2. Testing TypeScript compilation..." -ForegroundColor Blue

# Clean previous build
if (Test-Path "out") {
    Remove-Item "out" -Recurse -Force
    Write-Host "🧹 Cleaned previous build output" -ForegroundColor Gray
}

# Compile TypeScript
npm run compile

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ TypeScript compilation successful!" -ForegroundColor Green
    
    # Check what was compiled
    if (Test-Path "out\extension.js") {
        Write-Host "✅ Main extension file compiled: out\extension.js" -ForegroundColor Green
    } else {
        Write-Host "❌ Main extension file not found" -ForegroundColor Red
    }
    
    # Check that sample files were NOT compiled
    $sampleFiles = Get-ChildItem -Path "out" -Recurse -Filter "*sample*" -ErrorAction SilentlyContinue
    if ($sampleFiles.Count -eq 0) {
        Write-Host "✅ Sample files correctly excluded from compilation" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Sample files found in output: $($sampleFiles.Count)" -ForegroundColor Yellow
    }
    
} else {
    Write-Host "❌ TypeScript compilation failed" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔍 Common solutions:" -ForegroundColor Yellow
    Write-Host "1. Make sure all TypeScript code is in the 'src' directory" -ForegroundColor White
    Write-Host "2. Check for syntax errors in src/extension.ts" -ForegroundColor White
    Write-Host "3. Verify all imports are correct" -ForegroundColor White
}

Write-Host ""
Write-Host "3. Checking file structure..." -ForegroundColor Blue
Write-Host "📁 Source files (should be compiled):" -ForegroundColor Cyan
Get-ChildItem -Path "src" -Filter "*.ts" | ForEach-Object {
    Write-Host "   ✅ $($_.Name)" -ForegroundColor Green
}

Write-Host ""
Write-Host "📁 Sample files (should be ignored):" -ForegroundColor Cyan
Get-ChildItem -Path "." -Filter "sample-*" | ForEach-Object {
    Write-Host "   📄 $($_.Name) (excluded from compilation)" -ForegroundColor Gray
}

Write-Host ""
if ($LASTEXITCODE -eq 0) {
    Write-Host "🎉 TypeScript configuration is now working correctly!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Ready to test the extension:" -ForegroundColor Yellow
    Write-Host "1. Press F5 in VS Code to launch Extension Development Host" -ForegroundColor White
    Write-Host "2. Open sample files in the new window to test TODO detection" -ForegroundColor White
    Write-Host "3. Look for CodeLens '🔗 Create GitHub Issue' links" -ForegroundColor White
} else {
    Write-Host "❌ TypeScript issues still need to be resolved" -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")