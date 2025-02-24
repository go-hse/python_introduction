@echo off
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Copyright 2024: Andreas Roessler, HS Esslingen
:: Version 1.0, 29.08.2024
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set GIT_VERSION=2.47.1
set PY_VERSION=3.12.5
set PY_SHORT=312
set DENO_VERSION=v2.1.4

set SCRIPTDIR=%~dp0
:: Save current directory
set PARENT=%CD%
echo PARENT: %PARENT%

cd /D %PARENT%

:: Current User PATH
set "ORGPATH=%PATH%"

:: DEFAULT WINDOWS-PATH
set PATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\

call :FindProgram git.exe :InstallGit GIT_PATH
call :FindProgram code.exe :InstallCode CODE_PATH
:: call :FindProgram deno.exe :InstallDeno DENO_PATH
:: call :InstallPython 

%comspec% /K title %PARENT%

:: FINISH Goto End-Of-File
GOTO :eof

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Unterprogramm zur Ausgabe
:EchoRed
powershell.exe write-host -foregroundcolor Red %1 %2 %3
goto:eof

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Unterprogramm zur Programmsuche
:FindProgram
echo FindProgram Arg %1 %2 %3

set "PROGRAM_NAME=%1"
set "INSTALL_CALL=%2"
set "PROGRAM_PATH="
set "PROGRAM_DIR="

echo Find %PROGRAM_NAME% in %PATH%

for %%I in ("%PROGRAM_NAME%") do (
    if exist "%%~$PATH:I" (
        set "PROGRAM_PATH=%%~$PATH:I"
        set "PROGRAM_DIR=%%~dp$PATH:I"
    )
)

if defined PROGRAM_PATH (
    echo %PROGRAM_NAME% gefunden: %PROGRAM_PATH%
    echo Verzeichnis: %PROGRAM_DIR%
    set "%~3=%PROGRAM_DIR%"
) else (
    echo %PROGRAM_NAME% wurde nicht im Pfad gefunden.
    call %INSTALL_CALL%
)
echo End of FindProgram Arg %1 %2 %3
exit /b
:: ENDE 
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Unterprogramm zum Download
:Download
echo Download Arg %1 %2 %3
set "SRC=%1"
set "TGT=%2"

if exist %TGT% (
    echo Download Target %TGT% exists
) else (
    powershell -command "Invoke-WebRequest -Uri "\"%SRC%\"" -OutFile '%TGT%'"
)
call :EchoRed Download %TGT% finished
exit /b
:: ENDE
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Unterprogramm zum Extrahieren
:Extract
echo Extract Arg %1 %2 %3
set "SRC=%1"
set "TGT=%2"

if exist %TGT%\ (
    echo Extract Destination %TGT% exists
) else (
    powershell -command "Expand-Archive -Force '%SRC%' -DestinationPath '%TGT%'"
)

exit /b
:: ENDE
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Deno
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:InstallDeno

set TARGET=x86_64-pc-windows-msvc

set DOWNLOAD="https://dl.deno.land/release/%DENO_VERSION%/deno-%TARGET%.zip"
set DENO_ZIP=code.zip
set DENO_PATH=%PARENT%\Deno.%DENO_VERSION%

if exist %DENO_PATH%\ (
    echo Deno %DENO_PATH% exists
) else (
    call :Download %DOWNLOAD% %DENO_ZIP%
    call :Extract %PARENT%\%DENO_ZIP% %DENO_PATH%
    :: curl -A "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64)" -L %DOWNLOAD% -o %DENO_ZIP%
    :: powershell -command "Expand-Archive -Force '%PARENT%\%DENO_ZIP%' -DestinationPath '%DENO_PATH%'"
)

exit /b


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: VS CODE
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:InstallCode

set DOWNLOAD="https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"
set CODE_ZIP=code.zip
set CODE_PATH=%PARENT%\Code

if exist %CODE_PATH%\ (
    echo ZIP %CODE_PATH% exists
) else (
    call :Download %DOWNLOAD% %CODE_ZIP%
    call :Extract %PARENT%\%CODE_ZIP% %CODE_PATH%
)

if exist %CODE_PATH%\data (
    echo Data Dir %CODE_PATH%\data exists
) else (
    mkdir %CODE_PATH%\data\user-data\User
)

:: VS Code Settings
(
echo ^{"extensions.ignoreRecommendations": true,"terminal.integrated.defaultProfile.windows": "Command Prompt"^}
) > %CODE_PATH%\data\user-data\User\settings.json

exit /b

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: GIT
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:InstallGit
set GIT_ZIP=MinGit-%GIT_VERSION%-64-bit.zip

set DOWNLOAD="https://github.com/git-for-windows/git/releases/download/v%GIT_VERSION%.windows.1/%GIT_ZIP%"
set GIT_PATH=%PARENT%\Git.%GIT_VERSION%
call :Download %DOWNLOAD% %GIT_ZIP%
call :Extract %PARENT%\%GIT_ZIP% %GIT_PATH%
exit /b

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: PYTHON
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:InstallPython

set PY_ZIP=python-%PY_VERSION%-embed-amd64.zip
set DOWNLOAD="https://www.python.org/ftp/python/%PY_VERSION%/%PY_ZIP%"
set PYTHON_PATH=%PARENT%\Python.%PY_VERSION%

if exist %PYTHON_PATH% (
    echo ZIP %PYTHON_PATH% exists
) else (
    call :Download %DOWNLOAD% %PY_ZIP%
    call :Extract %PARENT%\%PY_ZIP% %PYTHON_PATH%
)

set STDPATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\
set "PATH=%STDPATH%;%PYTHON_PATH%;%PYTHON_PATH%\Scripts;%CODE_PATH%;%GIT_PATH%\cmd;%DENO_PATH%"

set LOADER=get-pip.py
if exist %LOADER% (
    echo LOADER %LOADER% exists
) else (
    curl -sSL https://bootstrap.pypa.io/%LOADER% -o %LOADER%
    python %LOADER%
)

:: to make pip work, see https://stackoverflow.com/questions/32639074/why-am-i-getting-importerror-no-module-named-pip-right-after-installing-pip
(
echo python%PY_SHORT%.zip
echo .
echo Lib\site-packages
) > %PYTHON_PATH%\python%PY_SHORT%._pth

pip install virtualenv

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: install modules
:: https://jupyter.org/install
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pip install notebook jupyterlab matplotlib pandas PyQt5

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Create and fill Sources Dir
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
cd /D %PARENT%
mkdir Sources
echo print^('Hello World!'^) > Sources\01_hello_world.py

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: GET JUPYTERS BY HTTPS
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set REPO=python_introduction
git clone https://github.com/go-hse/%REPO%.git

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Write SCRIPTS
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
(
echo c = get_config^(^)  #noqa
echo c.ServerApp.ip = '127.0.0.1'
) > %PARENT%\jupyter_notebook_config.py

:: install deno as kernel in jupyter
deno jupyter --install 

(
echo @echo off
echo set "PATH=%PATH%"
echo set "JUPYTER_CONFIG_DIR=%PARENT%"
echo start jupyter notebook %REPO%\notebooks
echo start code Sources
echo start "Python-Umgebung in %PARENT%" %comspec% /K
) > %PARENT%\start_python.bat

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: START
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

python --version
python Sources\01_hello_world.py
exit /b
