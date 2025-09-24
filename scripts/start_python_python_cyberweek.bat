@echo off
set "PATH=C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Repo\unified_shell\;C:\Tools\Node\node-v22.11.0-win-x64;C:\Tools\Node;C:\Tools\Microsoft VS Code;C:\Tools\Git\bin;;C:\Tools\Python\3.13.1;C:\Tools\Python\3.13.1\Scripts"
call C:\Tools\Python\\venvs.3.13.1\python_cyberweek\Scripts\activate
doskey /macrofile=C:\Repo\unified_shell\\includes\commonmacros.txt
doskey frz=pip freeze ^> requirements.txt

echo jupyter lab ..\notebooks

cmd.exe /K title C:\Tools\Python\\venvs.3.13.1\python_cyberweek


:: pip install notebook jupyterlab matplotlib pandas PyQt6