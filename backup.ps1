#katalogi które sprawdimy:
$katalog1 = get-childItem -path "C:\work" -recurse
$katalog2 = get-childItem -path "C:\Backup\work-bkp" -recurse
#katalog w który skopiujemy zmiany:
$katalog3 = "C:\Backup\"+ (Get-Date -format MM-dd-yyyy)

$roznica = Compare-Object $katalog1 $katalog2 -Property Name,Length,LastWriteTime -passthru

#czy są zmiany? ile?
$pliki = $roznica.FullName | ?{$_ -notmatch $katalog2.Directory.Name}
$ile = ($pliki | Measure-Object).count

if ($ile -gt 0){
if (!(Test-Path -Path $Katalog3)){
   Write-Host "Twórzę katalog $Katalog3" -ForegroundColor yellow
   New-Item -Path $katalog3 -ItemType Directory; 
}
echo "Kopuję pliki: " $pliki | Write-host -ForegroundColor green
$pliki | Copy-Item -Destination $katalog3 -Force
}
