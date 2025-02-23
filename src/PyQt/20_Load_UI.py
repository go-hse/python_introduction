import os
import sys

# for embedded installation
sys.path.append(os.path.join(os.path.dirname(__file__), 'uic'))

from PyQt6.QtWidgets import QApplication, QWidget, QMainWindow

# pyuic6 -o MainWidow.py MainWidow.ui
from MainWindow import Ui_MainWindow


class App(QMainWindow):
    def __init__(self):
        super().__init__()

        # use the Ui_login_form
        self.ui = Ui_MainWindow()       
        self.ui.setupUi(self)
        self.ui.actionBeenden.triggered.connect(self.exit_app)
        
        # show the login window
        self.show()
    

    def exit_app(self):
        print("bye")
        exit()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    login_window = App()
    sys.exit(app.exec())