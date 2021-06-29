import os
import shutil
# os.chdir("c:\Anaconda3\Lib\site-packages\pip")
import time as time 
import webbrowser as web
import pyautogui as pag 
import subprocess as sp
import pyperclip as pc
from shutil import copyfile
import smtplib
import os  as os 
from email.message import EmailMessage
from ctypes import windll
user32 = windll.user32
user32.SetProcessDPIAware()
imagerootfilepath = 'e:\dailyhostdata'
autopyusername = "autopy"
autopypass = 'W3lcomeT0aut0mat1on101'
outlookusername = "pwaller@sproutit.co.uk"
outlookurl = "https://login.microsoftonline.com"
insightsurl = "https://insights.controlup.com/auth"
grafanurl = "http://infrastructurechecks.sproutcloud.co.uk:3000/login"
# emailpassword = pag.password('Enter password for browsers (text will be hidden)')
web.open("https://Google.com")
time.sleep(2)
sp.call("C:\Program Files\Google\Chrome\Application\chrome.exe")
time.sleep(2)

pag.click(332,50) # click ther tab on chrome to set as browser
time.sleep(1)
pag.click(310,50) # click inside search field of chrome 
pag.write(grafanurl)
time.sleep(2)
pag.press(['enter'])
time.sleep(2)
pag.click(970,410) # click username 
pag.write(autopyusername)
pag.click(970,465) # click password
pag.write(autopypass)
time.sleep(1)
pag.click(1000,530) # click login
# pag.click(['Enter'])
time.sleep(5)
pag.click(30,180) # click dashboards
time.sleep(1)
pag.click(95,250) # click manage
time.sleep(1)
pag.click(700,551) # click summary_configuration
time.sleep(1)
pag.click(675,585) # click client_configuration
time.sleep(5)
pag.screenshot('e:\dailyhostdata\Client_Summary.png', region=(0,0,1920,1080)) # take screenshot
pag.click()

pag.click(30,180) # click dashboards
time.sleep(1)
pag.click(95,250) # click manage
time.sleep(1)
pag.click(700,551) # click summary_configuration
time.sleep(1)
pag.click(675,615) # click jenkins_configuration
time.sleep(5)
pag.screenshot('e:\dailyhostdata\Jenkins_Summary.png', region=(0,0,1920,1080)) # take screenshot

pag.click(30,180) # click dashboards
time.sleep(1)
pag.click(95,250) # click manage
time.sleep(1)
pag.click(700,551) # click summary_configuration
time.sleep(1)
pag.click(675,650) # click jenkins_configuration
time.sleep(5)
pag.screenshot('e:\dailyhostdata\VMM_Summary.png', region=(0,0,1920,1080)) # take screenshot


pag.click(30,180) # click dashboards
time.sleep(1)
pag.click(95,250) # click manage
time.sleep(1)
pag.click(700,435) # click hyperV_Performance_Management
time.sleep(1)
pag.click(700,465) # click hyperV_Performance_charts
time.sleep(5)
pag.screenshot('e:\dailyhostdata\hyperv_perf_chart1.png', region=(0,0,1920,1080)) # take screenshot
pag.scroll(-150)
pag.scroll(-150)
time.sleep(1)
pag.screenshot('e:\dailyhostdata\hyperv_perf_chart2.png', region=(0,0,1920,1080)) # take screenshot
time.sleep(1)
pag.click(25,825) # click user profile icon 
time.sleep(2)
pag.click(110,788) # click logoff
time.sleep(2)
pag.click(1895,13) # Close browser
time.sleep(2)




