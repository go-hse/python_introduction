import importlib.resources as resources
import shutil
import pathlib
import os


def main():
    target_dir = pathlib.Path(os.getcwd()) / "notebooks_python_introduction"
    target_dir.mkdir(parents=True, exist_ok=True)

    with resources.path("python_introduction", "notebooks") as nb_dir:
        for item in nb_dir.rglob("*.ipynb"):
            rel_path = item.relative_to(nb_dir)
            dest = target_dir / rel_path
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy(item, dest)

    print(f"✅ Notebooks wurden nach {target_dir} kopiert.")
