import sys
import json
from PyQt6.QtWidgets import QApplication, QMainWindow, QTableWidget, QTableWidgetItem, QVBoxLayout, QWidget, QPushButton, QFileDialog

class JsonTableApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.init_ui()
    
    def init_ui(self):
        self.setWindowTitle("JSON Tabelle")
        self.setGeometry(100, 100, 800, 600)
        
        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)
        
        self.layout = QVBoxLayout()
        self.central_widget.setLayout(self.layout)
        
        self.table = QTableWidget()
        self.table.setSortingEnabled(True)        
        self.layout.addWidget(self.table)
        
        self.load_button = QPushButton("JSON laden")
        self.load_button.clicked.connect(self.load_json)
        self.layout.addWidget(self.load_button)
        
        self.load_json("t_2024.json")  # Standardmäßig die Datei laden
    
    def load_json(self, file_path=None):
        if file_path is None:
            file_path, _ = QFileDialog.getOpenFileName(self, "JSON Datei öffnen", "", "JSON Dateien (*.json)")
            if not file_path:
                return
        
        with open(file_path, "r", encoding="utf-8") as file:
            data = json.load(file)
        
        if not data:
            return
        
        headers = list(data[0].keys())
        self.table.setColumnCount(len(headers))
        self.table.setRowCount(len(data))
        self.table.setHorizontalHeaderLabels(headers)
        
        for row_idx, row_data in enumerate(data):
            for col_idx, key in enumerate(headers):
                self.table.setItem(row_idx, col_idx, QTableWidgetItem(str(row_data[key])))
        
if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = JsonTableApp()
    window.show()
    sys.exit(app.exec())
