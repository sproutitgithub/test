# import ctypes
# import shutil
# # os.chdir("c:\Anaconda3\Lib\site-packages\pip")
# import time as time
# from types import ClassMethodDescriptorType 
# import webbrowser as web
# import pyautogui as pag 
# import subprocess as sp
# import pyperclip as pc
# from shutil import copyfile
# import smtplib
# import os  as os 
# from email.message import EmailMessage
# from ctypes import windll
# from cryptography.fernet import Fernet
# import os as os
# # for i in
# os.chdir(r'Y:\\')
# for i in os.listdir('./'):
#     if i == 'dec_pass.txt':
#         print(i)
#         os.system('copy dec_pass.txt dec_new_pass.txt')

# with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\dec_new_pass.txt', 'r') as file:
#     passstr=file.read()

# time.sleep(2)

# os.remove('dec_pass.txt')
# os.remove('dec_new_pass.txt')

import os  as os 
print("copy decrypted files")
os.chdir(r'Y:\\')
for i in os.listdir('./'):
    # if i == ['test1.txt' , 'test2.txt']:
        if ('test1.txt') or ('test2.txt') in i:
            print(i)
        # os.system('copy dec_outlookemailpass.txt dec_new_outlookemailpass.txt')
        # os.system('copy dec_egadminpass.txt dec_new_egadminpass.txt')
