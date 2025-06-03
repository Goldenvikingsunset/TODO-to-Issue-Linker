# Test TODO to Issue Linker Extension
Write-Host "🧪 Testing TODO to Issue Linker Extension..." -ForegroundColor Green

# Test TypeScript compilation
Write-Host "1. Testing TypeScript compilation..." -ForegroundColor Blue
npm run compile

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ TypeScript compilation successful!" -ForegroundColor Green
    
    # Check if main extension file exists
    if (Test-Path "out\extension.js") {
        Write-Host "✅ Extension output file found" -ForegroundColor Green
    } else {
        Write-Host "❌ Extension output file missing" -ForegroundColor Red
    }
} else {
    Write-Host "❌ TypeScript compilation failed" -ForegroundColor Red
}

# Test package.json syntax
Write-Host ""
Write-Host "2. Validating package.json..." -ForegroundColor Blue
try {
    $packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json
    Write-Host "✅ package.json is valid JSON" -ForegroundColor Green
    
    # Check required fields
    $requiredFields = @("name", "displayName", "description", "version", "engines", "main", "contributes")
    foreach ($field in $requiredFields) {
        if ($packageJson.$field) {
            Write-Host "✅ Field '$field' is present" -ForegroundColor Green
        } else {
            Write-Host "❌ Field '$field' is missing" -ForegroundColor Red
        }
    }
    
    # Check sponsor URL
    if ($packageJson.sponsor.url) {
        Write-Host "✅ Sponsor URL configured: $($packageJson.sponsor.url)" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Sponsor URL not configured" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ package.json has syntax errors: $($_.Exception.Message)" -ForegroundColor Red
}

# Test sample files
Write-Host ""
Write-Host "3. Checking sample files..." -ForegroundColor Blue

# Check Markdown sample
if (Test-Path "sample-todos.md") {
    $todoContent = Get-Content "sample-todos.md" -Raw
    $todoCount = ($todoContent | Select-String "TODO:" -AllMatches).Matches.Count
    $fixmeCount = ($todoContent | Select-String "FIXME:" -AllMatches).Matches.Count
    $bugCount = ($todoContent | Select-String "BUG:" -AllMatches).Matches.Count
    
    Write-Host "✅ Markdown sample contains:" -ForegroundColor Green
    Write-Host "   • $todoCount TODO items" -ForegroundColor White
    Write-Host "   • $fixmeCount FIXME items" -ForegroundColor White  
    Write-Host "   • $bugCount BUG items" -ForegroundColor White
} else {
    Write-Host "❌ Markdown sample file not found" -ForegroundColor Red
}

# Check TypeScript sample
if (Test-Path "sample-code-todos.ts") {
    $codeContent = Get-Content "sample-code-todos.ts" -Raw
    $codeTodoCount = ($codeContent | Select-String "TODO:" -AllMatches).Matches.Count
    $codeFixmeCount = ($codeContent | Select-String "FIXME:" -AllMatches).Matches.Count
    $codeBugCount = ($codeContent | Select-String "BUG:" -AllMatches).Matches.Count
    
    Write-Host "✅ TypeScript sample contains:" -ForegroundColor Green
    Write-Host "   • $codeTodoCount TODO items" -ForegroundColor White
    Write-Host "   • $codeFixmeCount FIXME items" -ForegroundColor White
    Write-Host "   • $codeBugCount BUG items" -ForegroundColor White
} else {
    Write-Host "❌ TypeScript sample file not found" -ForegroundColor Red
}

# Check Python sample
if (Test-Path "sample-code-todos.py") {
    $pythonContent = Get-Content "sample-code-todos.py" -Raw
    $pythonTodoCount = ($pythonContent | Select-String "TODO:" -AllMatches).Matches.Count
    $pythonFixmeCount = ($pythonContent | Select-String "FIXME:" -AllMatches).Matches.Count
    $pythonBugCount = ($pythonContent | Select-String "BUG:" -AllMatches).Matches.Count
    
    Write-Host "✅ Python sample contains:" -ForegroundColor Green
    Write-Host "   • $pythonTodoCount TODO items" -ForegroundColor White
    Write-Host "   • $pythonFixmeCount FIXME items" -ForegroundColor White
    Write-Host "   • $pythonBugCount BUG items" -ForegroundColor White
} else {
    Write-Host "❌ Python sample file not found" -ForegroundColor Red
}

# Test extension manifest
Write-Host ""
Write-Host "4. Validating extension features..." -ForegroundColor Blue
try {
    $packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json
    
    # Check commands
    $commands = $packageJson.contributes.commands
    if ($commands -and $commands.Count -gt 0) {
        Write-Host "✅ Extension defines $($commands.Count) commands" -ForegroundColor Green
    } else {
        Write-Host "❌ No commands defined" -ForegroundColor Red
    }
    
    # Check configuration
    $config = $packageJson.contributes.configuration
    if ($config -and $config.properties) {
        $propCount = ($config.properties | Get-Member -MemberType NoteProperty).Count
        Write-Host "✅ Extension has $propCount configuration options" -ForegroundColor Green
    } else {
        Write-Host "❌ No configuration options defined" -ForegroundColor Red
    }
    
    # Check activation events
    $activation = $packageJson.activationEvents
    if ($activation -and $activation.Count -gt 0) {
        Write-Host "✅ Extension has $($activation.Count) activation event(s)" -ForegroundColor Green
    } else {
        Write-Host "❌ No activation events defined" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error validating extension manifest" -ForegroundColor Red
}

Write-Host ""
if ($LASTEXITCODE -eq 0) {
    Write-Host "🎉 TODO to Issue Linker extension test completed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎯 Ready for testing:" -ForegroundColor Yellow
    Write-Host "1. Press F5 in VS Code to launch Extension Development Host" -ForegroundColor White
    Write-Host "2. Open sample-todos.md, sample-code-todos.ts, or sample-code-todos.py" -ForegroundColor White
    Write-Host "3. Look for CodeLens '🔗 Create GitHub Issue' links" -ForegroundColor White
    Write-Host "4. Right-click TODO text for context menu" -ForegroundColor White
    Write-Host "5. Test keyboard shortcut Ctrl+Shift+I" -ForegroundColor White
    Write-Host "6. Try different programming languages" -ForegroundColor White
    Write-Host ""
    Write-Host "🚀 Ready to build and publish!" -ForegroundColor Green
    Write-Host "   Run: .\build.ps1" -ForegroundColor Cyan
} else {
    Write-Host "❌ Issues found. Please fix before testing." -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")