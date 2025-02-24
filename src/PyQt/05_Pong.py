import sys
from PySide6.QtWidgets import QApplication, QMainWindow, QWidget
from PySide6.QtCore import Qt, QTimer, QRect
from PySide6.QtGui import QPainter, QColor


class PongGame(QWidget):
    def __init__(self):
        super().__init__()
        self.init_game()
        self.setFocusPolicy(Qt.FocusPolicy.StrongFocus)  # Setzt den Fokus auf das Widget
        
    def init_game(self):
        self.setWindowTitle("Pong mit PySide6")
        self.setGeometry(100, 100, 800, 400)
        
        self.ball_x = 390
        self.ball_y = 190
        self.ball_dx = 3
        self.ball_dy = 3
        
        self.paddle1_y = 150
        self.paddle2_y = 150
        self.paddle_speed = 10
        
        self.pressed_keys = set()
        
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_game)
        self.timer.start(16)  # Etwa 60 FPS
        
    def paintEvent(self, event):
        painter = QPainter(self)
        painter.setRenderHints(QPainter.RenderHint.Antialiasing )        
        painter.setBrush(QColor(255, 255, 255))
        
        # Ball zeichnen
        painter.drawEllipse(self.ball_x, self.ball_y, 20, 20)
        
        # Schläger zeichnen
        painter.drawRect(QRect(20, self.paddle1_y, 10, 80))
        painter.drawRect(QRect(770, self.paddle2_y, 10, 80))
    
    def keyPressEvent(self, event):
        self.pressed_keys.add(event.key())
        event.accept()
    
    def keyReleaseEvent(self, event):
        self.pressed_keys.discard(event.key())
        event.accept()
        
    def update_game(self):
        self.ball_x += self.ball_dx
        self.ball_y += self.ball_dy
        
        # Bewegung der Schläger
        if Qt.Key.Key_W in self.pressed_keys:
            self.paddle1_y = max(self.paddle1_y - self.paddle_speed, 0)
        if Qt.Key.Key_S in self.pressed_keys:
            self.paddle1_y = min(self.paddle1_y + self.paddle_speed, self.height() - 80)
        if Qt.Key.Key_Up in self.pressed_keys:
            self.paddle2_y = max(self.paddle2_y - self.paddle_speed, 0)
        if Qt.Key.Key_Down in self.pressed_keys:
            self.paddle2_y = min(self.paddle2_y + self.paddle_speed, self.height() - 80)
        
        # Kollision mit oberen und unteren Wänden
        if self.ball_y <= 0 or self.ball_y >= self.height() - 20:
            self.ball_dy = -self.ball_dy
        
        # Kollision mit Schlägern
        if (self.ball_x <= 30 and self.paddle1_y < self.ball_y < self.paddle1_y + 80) or \
           (self.ball_x >= 750 and self.paddle2_y < self.ball_y < self.paddle2_y + 80):
            self.ball_dx = -self.ball_dx
        
        # Reset bei Tor
        if self.ball_x <= 0 or self.ball_x >= self.width() - 20:
            self.ball_x, self.ball_y = 390, 190
            self.ball_dx = -self.ball_dx
        
        self.update()

class PongMainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.game_widget = PongGame()
        self.setCentralWidget(self.game_widget)
        self.setWindowTitle("Pong mit PyQt6")
        self.resize(800, 400)
        self.game_widget.setFocus()  # Fokus direkt auf das Spielfeld setzen

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = PongMainWindow()
    window.show()
    sys.exit(app.exec())
