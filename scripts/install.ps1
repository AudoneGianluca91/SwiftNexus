Write-Host "PyWrap installer — Windows"
$pyVersion = if ($args.Count -gt 0) { $args[0] } else { "3.12" }
Write-Host "➡ Installing Python $pyVersion via winget..."
winget install --silent Python.Python.$($pyVersion.Substring(0,1))
$python = (Get-Command python).Source
$pydir  = Split-Path (Split-Path $python)
$lib = Join-Path $pydir "python$($pyVersion.Replace('.','')) .dll"
Write-Output "set PYTHON_LIBRARY=$lib" | Out-File -Encoding ascii pywrap_env.cmd
Write-Host "Python installed. Edit pywrap_env.cmd to adjust if needed." 
