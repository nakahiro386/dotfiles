
Write-Host $PROFILE

$proDir = $(Split-Path -parent "$PROFILE")
if ( -Not (Test-Path $proDir ) ) {
  New-Item -ItemType directory -Path $proDir
}

if ( -Not (Test-Path "$PROFILE" ) ) {
  New-Item -ItemType file -Path "$PROFILE"
}
$profilePath = $(join-path $(Split-Path -parent $MyInvocation.MyCommand.Definition) "profile.ps1")
$content = $(". `"$profilePath`"")
if ( -Not (Get-Content "$PROFILE" | Select-String -SimpleMatch $content -quiet )) {
  echo $content | Out-File -FilePath "$PROFILE" -Encoding ascii -Append
}
start-sleep -s 30
# vim:set filetype=ps1 expandtab shiftwidth=2 tabstop=2 softtabstop=2 :
