@echo off
echo Starting Shell %~f0
set HERE=%CD%
echo BATCH in %HERE%
powershell -executionpolicy remotesigned -File  %HERE%\setup_python.ps1 %HERE%

pause
:: %comspec% /K title Python %PYTHON_HOME%


