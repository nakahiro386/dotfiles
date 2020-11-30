# $PROFILE
# . "/RepositoryPath/dotfiles/profile.ps1"

function Test-Admin {
  # http://winscript.jp/powershell/302
  return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
function Get-UserName {
  $userinfo = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  return $userinfo.Name
}
function Get-HostName {
  return [Net.Dns]::GetHostName()
}

function prompt {
  if ( $Host.Name -eq "ConsoleHost" ) {
    $result = $?
    $exitcode = $LASTEXITCODE
    Write-Host $($(Get-UserName) + "@" + $(Get-HostName) + ' ') -NoNewline -ForegroundColor "DarkGreen"
    Write-Host $($(Get-Location).Path + " ") -NoNewline -ForegroundColor "Green"
    if ($result) {
      Write-Host $("$exitcode") -NoNewline -ForegroundColor "Green"
    } else {
      Write-Host $("$result $exitcode") -NoNewline -ForegroundColor "Red"
    }
    if ( Test-Admin ) {
      Write-Host -Object ' Administrator' -ForegroundColor "Red"
    } else {
      Write-Host -Object '' -ForegroundColor "Red"
    }
    return  "> "
  } else {
    return  "PS " + $(Get-Location) + ">"
  }
}
# vim:set filetype=ps1 expandtab shiftwidth=2 tabstop=2 softtabstop=2 :
