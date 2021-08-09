from time import sleep, time
import keyboard as kb 
# kb.is_pressed('esc') == 'False'
# while True:
#     try:
#         if kb.is_pressed('q'):
#             print("pressed q")
#             break
#     except:
#         print("ok")
while kb.is_pressed('esc') == False:
    print("ok")
    
# import keyboard  # using module keyboard
# while True:  # making a loop
#     try:  # used try so that if user pressed other than the given key error will not be shown
#         if keyboard.is_pressed('q'):  # if key 'q' is pressed 
#             print('You Pressed A Key!')
#             break  # finishing the loop
#     except:
#         break  # if user pressed a key other than the given key the loop will breakq  q

    
