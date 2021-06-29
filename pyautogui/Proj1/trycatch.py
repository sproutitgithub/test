import ctypes
import os
import webbrowser as web
if os.path.isdir('c:\\test'):
    "true"
else:
    os.mkdir('c:\\test')

try:
    web.open1("https://Google.com")
except:
    ctypes.windll.user32.MessageBoxW(0, "Error loading browser", "Warning!", 16)