# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

# 1. See the _TODO.md that is generated top level and read through that
# 2. Follow the documentation below to learn how to create a package for the package type you are creating.
# 3. In Chocolatey scripts, ALWAYS use absolute paths - $toolsDir gets you to the package's tools directory.
#$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# refresh env vars after other packages have been installed
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")


### upgrade pip
### it should not be necesary, but the "please upgrade" message is interpreted as an error by choco
Write-Host 'Upgrading pip.'
python -m pip install --upgrade pip

### install tidalcycles Atom package
Write-Host 'Installing FoxDot with pip.'
pip install foxdot

### ensure Quarks path
Write-Host 'Ensuring SuperCollider Quarks path.'
$quarksPath = $env:LOCALAPPDATA + '\SuperCollider\downloaded-quarks'
if (!(Test-Path -Path $quarksPath)){
    Write-Host "Creating " $quarksPath
    New-Item -ItemType directory -Path $quarksPath
}else{
    Write-Host 'Quarks path already exists.'
}

### install FoxDotQuark
Write-Host 'Installing FoxDotQuark quark.'
$foxDotQuarkUrl = 'https://github.com/Qirky/FoxDotQuark.git'
$foxDotQuarkPath = $quarksPath + '\FoxDotQuark'
Write-Host 'Installing FoxDotQuark quark on.' + $foxDotQuarkPath

if (!(Test-Path -Path $foxDotQuarkPath)){
    Write-Host 'Cloning FoxDotQuark from .' + $foxDotQuarkUrl
    git clone --quiet $foxDotQuarkUrl $foxDotQuarkPath
} else {
    Write-Host 'FoxDotQuark quark already installed.'
}


### install batLib quark
Write-Host 'Installing BatLib quark.'
$batLibUrl = 'https://github.com/supercollider-quarks/BatLib.git'
$batLibPath = $quarksPath + '\BatLib'

if (!(Test-Path -Path $batLibPath)){
    git clone --quiet $batLibUrl $batLibPath
} else {
    Write-Host 'SuperDirt quark already installed.'
}


### adding FoxDot.start to the startup file
Write-Host 'Adding FoxDot.start to the startup file.'
$startupFilePath = $env:LOCALAPPDATA + '\SuperCollider\startup.scd'
$startupFileContent = "(`r`nFoxDot.start;`r`n)"
Set-Content -Path $startupFilePath -Value $startupFileContent


## Main helper functions - these have error handling tucked into them already
## see https://chocolatey.org/docs/helpers-reference


## Add specific files as shortcuts to the desktop
## - https://chocolatey.org/docs/helpers-install-chocolatey-shortcut
#Install-ChocolateyShortcut -ShortcutFilePath "C:\FoxDot.lnk" -TargetPath "python -m FoxDot" -Description "FoxDot" -PinToTaskbar

try {
  $desktop = $([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::DesktopDirectory))
  if(!(Test-Path($desktop))) {
    [System.IO.Directory]::CreateDirectory($desktop) | Out-Null
  }
  $link = Join-Path $desktop "FoxDot.lnk"
  $workingDirectory = $desktop

  $wshshell = New-Object -ComObject WScript.Shell
  $lnk = $wshshell.CreateShortcut($link)
  $lnk.TargetPath = "python"
  $lnk.Arguments = "-m FoxDot"
  $lnk.Description = "FoxDot"
  $lnk.HotKey = "ALT+CTRL+F"

  $lnk.Save()

  Write-Host "Desktop Shortcut created"
}
catch {
  Write-Warning "Unable to create desktop link. Error captured was $($_.Exception.Message)."
}
