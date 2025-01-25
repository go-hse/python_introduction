@echo off
for /r %%f in (*.ipynb) do (
    echo Entferne Outputs in %%f
    python scripts\reset.py %%f
)