# find locationy = "true"
y = "true"
import time as time 
import pyautogui as pag 
import keyboard as kb
# while y == "true":
while True:
    if kb.is_pressed('q') == 'True':
        break
    else:
        print(pag.position())
        pag.sleep(1)
        
q





