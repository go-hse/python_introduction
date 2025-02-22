###############################################################################
# Powershell-Script to Download and Install Python 
# Copyright 2025: Andreas Roessler, Hochschule Esslingen
# 08.01.2025: Port from Batch

$TgtPath=$Args[0]

# if there is an argument/path that exists, take it as install-dir
if ((Test-Path -Path $TgtPath)) {
    $TgtPath=$Args[0]
} else {
    $TgtPath=$PSScriptRoot
}

write-host "Install to $TgtPath"

$GIT_VERSION="2.47.1"
$PY_VERSION="3.13.1"
$PY_SHORT="313"

$PY_VERSION="3.11.9"
$PY_SHORT="311"


$DENO_VERSION="v2.1.4"
$CODE_VERSION="1.96"
$REPO="python_introduction"

$DENO_ZIP="deno.$DENO_VERSION.zip"
$CODE_ZIP="code.$CODE_VERSION.zip"
$GIT_ZIP="MinGit-$GIT_VERSION-64-bit.zip"
$PY_ZIP="python-$PY_VERSION-embed-amd64.zip"

$DENO_PATH="$TgtPath\Deno.$DENO_VERSION"
$CODE_PATH="$TgtPath\Code.$CODE_VERSION"
$GIT_PATH="$TgtPath\Git.$GIT_VERSION"
$PYTHON_PATH="$TgtPath\Python.$PY_VERSION"

$GET_PIP="get-pip.py"

###############################################################################
# Downloads
function Download-File($Src, $Tgt) {
    if ((Test-Path $Tgt)) {
        write-host -foregroundcolor Green "$Tgt exists"
    } else {
        Invoke-WebRequest -Uri $Src -OutFile $Tgt
    }
}

function Download-Extract-Archive($Src, $Tgt, $TgtPath) {
    Download-File $Src $tgt
    if ((Test-Path -Path $TgtPath)) {
        write-host -foregroundcolor Green "Path $TgtPath exists"
    } else {
        Expand-Archive -Force $Tgt -DestinationPath $TgtPath
    }
}

Download-Extract-Archive "https://dl.deno.land/release/$DENO_VERSION/deno-x86_64-pc-windows-msvc.zip" $TgtPath\$DENO_ZIP $DENO_PATH
Download-Extract-Archive "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive" $TgtPath\$CODE_ZIP $CODE_PATH
Download-Extract-Archive "https://github.com/git-for-windows/git/releases/download/v$GIT_VERSION.windows.1/$GIT_ZIP" $TgtPath\$GIT_ZIP $GIT_PATH
Download-Extract-Archive "https://www.python.org/ftp/python/$PY_VERSION/$PY_ZIP" "$TgtPath\$PY_ZIP" $PYTHON_PATH

###############################################################################
# Set Path Variable

$STDPATH="$env:SystemRoot\system32;$env:SystemRoot;$env:SystemRoot\System32\Wbem;$env:SystemRoot\System32\WindowsPowerShell\v1.0\"
$env:Path="$STDPATH;$PYTHON_PATH;$PYTHON_PATH\Scripts;$CODE_PATH;$GIT_PATH\cmd;$DENO_PATH"

$env:PYTHONHOME="$PYTHON_PATH"
$env:PYTHONPATH=

write-host "Path $env:Path"

python --version
###############################################################################
# Install Pip

if ((Test-Path $PYTHON_PATH\Scripts\pip.exe)) {
    write-host -foregroundcolor Green "pip.exe exists"
} else {
    Download-File "https://bootstrap.pypa.io/$GET_PIP" "$TgtPath\$GET_PIP"
    python "$TgtPath\$GET_PIP"
}

###############################################################################
# Python Fix
# to make pip work, see https://stackoverflow.com/questions/32639074/why-am-i-getting-importerror-no-module-named-pip-right-after-installing-pip
$content=@"
python$PY_SHORT.zip
.
Lib\site-packages
import site
"@

New-Item -Force -Path $PYTHON_PATH -Name "python$PY_SHORT._pth" -ItemType "file" -Value $content

###############################################################################
# Start Script
$content=@"
@echo off
set "PATH=$env:Path"
set "JUPYTER_CONFIG_DIR=$TgtPath"
:: start jupyter notebook $TgtPath\Sources\$REPO\notebooks\Python\00_Uebersicht.ipynb
start jupyter lab $TgtPath\Sources\$REPO\notebooks\Python\00_Uebersicht.ipynb
start code "$TgtPath\Sources"
start "Python-Umgebung in $TgtPath" %comspec% /K
"@
New-Item -Force -Path $TgtPath -Name "start.bat" -ItemType "file" -Value $content

###############################################################################
# Jupyter Config
$content=@"
c = get_config()  #noqa
c.ServerApp.ip = '127.0.0.1'
"@
New-Item -Force -Path $TgtPath -Name "jupyter_notebook_config.py" -ItemType "file" -Value $content

###############################################################################
# Python Modules

if ((Test-Path $PYTHON_PATH\Scripts\virtualenv.exe)) {
    write-host -foregroundcolor Green "virtualenv.exe exists"
} else {
    pip install virtualenv notebook jupyterlab matplotlib pandas PyQt6 pyqt6-tools
}

deno jupyter --install

###############################################################################
# Sources
$content=@"
print "Hello World!"
"@

if ((Test-Path -Path "$TgtPath\Sources")) {
    write-host -foregroundcolor Green "$TgtPath\Sources exists"
} else {
    New-Item -Path $TgtPath -Name "Sources" -ItemType "directory"
    New-Item -Force -Path $TgtPath\Sources -Name "hello.py" -ItemType "file" -Value $content
    Set-Location -Path "$TgtPath\Sources"
    git clone https://github.com/go-hse/$REPO.git
    Set-Location -Path "$TgtPath"
}


