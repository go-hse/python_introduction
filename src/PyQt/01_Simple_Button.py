import sys
from PyQt6.QtWidgets import QApplication, QWidget, QVBoxLayout, QPushButton, QLabel

class CounterApp(QWidget):
    def __init__(self):
        super().__init__()
        self.counter = 0  # Zählvariable
        layout = QVBoxLayout()
        
        self.label = QLabel(f"Zähler: {self.counter}")
        layout.addWidget(self.label)
        
        self.button = QPushButton("Hochzählen")
        self.button.clicked.connect(self.increment_counter)
        layout.addWidget(self.button)
        
        self.setLayout(layout)
        self.setWindowTitle("PyQt6 Zähler")
        
    def increment_counter(self):
        self.counter += 1
        self.label.setText(f"Zähler: {self.counter}")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = CounterApp()
    window.show()
    sys.exit(app.exec())
