import ctypes
import shutil
# os.chdir("c:\Anaconda3\Lib\site-packages\pip")
import time as time
from types import ClassMethodDescriptorType 
import webbrowser as web
from PIL.ImageOps import grayscale
import pyautogui as pag 
import subprocess as sp
import pyperclip as pc
from shutil import copyfile
import smtplib
import os  as os 
from email.message import EmailMessage
from ctypes import windll
from cryptography.fernet import Fernet
user32 = windll.user32
user32.SetProcessDPIAware()
imagerootfilepath = 'e:\dailyhostdata'
autopyusername = "autopy"
autopypass = 'W3lcomeT0aut0mat1on101'
outlookusername = "pwaller@sproutit.co.uk"
outlookurl = "https://login.microsoftonline.com"
insightsurl = "https://insights.controlup.com/auth"
grafanurl = "http://infrastructurechecks.sproutcloud.co.uk:3000/login"
egurl = "https://vsceg.sproutcloud.local/final/#!"
# emailpassword = pag.password('Enter password for browsers (text will be hidden)')


sp.Popen(r'"C:\Program Files\Internet Explorer\IEXPLORE.EXE" www.google.com')
time.sleep(3)
sp.call("C:\Program Files\Internet Explorer\iexplore.exe")
time.sleep(3)
pag.click(845,505) # click ed username 
pag.write('a-pwaller')
pag.click(845,565) # click the eg password field
pag.write('Pa55w0rd101!')
pag.click(1035,625) # click the eg login button
time.sleep(5)
pag.locateOnScreen('egmonitorbtn.PNG',confidence=0.8)
pag.click(pag.locateOnScreen('egmonitorbtn.PNG',confidence=0.5,grayscale=True)) # eg monitor button click 
time.sleep(5)
pag.click(pag.locateOnScreen('nimblestorage.PNG',confidence=0.8)) # click nimble storage in home screen
time.sleep(5)
pag.click(pag.locateOnScreen('nimb1.PNG',confidence=0.8)) # click nimble1 icon
time.sleep(5)
pag.click(430,295) # click nimble system 
time.sleep(3)
pag.click(320,325) # click nimble io perf 
time.sleep(1)
pag.screenshot('e:\\dailyhostdata\\nimble1.png', region=(0,0,1920,1080)) # take screenshot
time.sleep(1)
pag.click(1875,150) # click back
time.sleep(3)
pag.click(pag.locateOnScreen('nimb2.PNG',confidence=0.9)) # click nimble1 icon
time.sleep(5)
pag.click(430,295) # click nimble system 
time.sleep(3)
pag.click(320,325) # click nimble io perf 
time.sleep(5)
pag.screenshot('e:\\dailyhostdata\\nimble2.png', region=(0,0,1920,1080)) # take screenshot
time.sleep(2)
pag.click(pag.locateOnScreen('eglogout.PNG',confidence=0.9)) # click nimble1 icon
time.sleep(2)

