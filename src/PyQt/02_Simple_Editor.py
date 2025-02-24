import sys
from PySide6.QtWidgets import QApplication, QMainWindow, QTextEdit, QFileDialog, QVBoxLayout, QWidget, QMenuBar
from PySide6.QtGui import QAction


class TextEditor(QMainWindow):
    def __init__(self):
        super().__init__()
        
        self.init_ui()
        
    def init_ui(self):
        self.text_edit = QTextEdit()
        self.setCentralWidget(self.text_edit)
        
        menu_bar = self.menuBar()
        file_menu = menu_bar.addMenu("Datei")
        
        open_action = QAction("Öffnen", self)
        open_action.triggered.connect(self.open_file)
        file_menu.addAction(open_action)
        
        save_action = QAction("Speichern", self)
        save_action.triggered.connect(self.save_file)
        file_menu.addAction(save_action)
        
        self.setWindowTitle("Einfacher Texteditor")
        self.resize(600, 400)
        
    def open_file(self):
        file_name, _ = QFileDialog.getOpenFileName(self, "Datei öffnen", "", "Textdateien (*.txt);;Alle Dateien (*)")
        if file_name:
            with open(file_name, 'r', encoding='utf-8') as file:
                self.text_edit.setText(file.read())
    
    def save_file(self):
        file_name, _ = QFileDialog.getSaveFileName(self, "Datei speichern", "", "Textdateien (*.txt);;Alle Dateien (*)")
        if file_name:
            with open(file_name, 'w', encoding='utf-8') as file:
                file.write(self.text_edit.toPlainText())

if __name__ == "__main__":
    app = QApplication(sys.argv)
    editor = TextEditor()
    editor.show()
    sys.exit(app.exec())
