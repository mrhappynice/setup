## Get code from your projects


Get files in current directory
```bash
Get-ChildItem -File | ForEach-Object { "==> $($_.Name) <==" + "`r`n" + (Get-Content $_.FullName -Raw) + "`r`n" } | Set-Content merged_output.txt
```

Get files in subdirectories
```bash
Get-ChildItem -File -Recurse | ForEach-Object { "==> $($_.FullName) <==" + "`r`n" + (Get-Content $_.FullName -Raw) + "`r`n" } | Set-Content merged_output.txt
```

Get files with subdirectories and hide Windows Drive path
```bash
$BasePath = Get-Location
Get-ChildItem -File -Recurse | ForEach-Object { 
    "==> $(($_.FullName -replace [regex]::Escape($BasePath), '.')) <==" + "`r`n" + 
    (Get-Content $_.FullName -Raw) + "`r`n" 
} | Set-Content merged_output.txt
```
