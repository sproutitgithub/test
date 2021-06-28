import os
import shutil
# os.chdir("c:\Anaconda3\Lib\site-packages\pip")
import time as time 
import webbrowser as web
import pyautogui as pag 
import subprocess as sp
import pyperclip as pc
from shutil import copyfile
emailpassword = pag.password('Enter password for browsers (text will be hidden)')


if os.path.isdir('c:\dailyhostdata'):
    "true"
else:
    os.mkdir('c:\dailyhostdata')
web.open("https://Google.com")
# sp.call("C:\Program Files\Google\Chrome\Application\chrome.exe")
time.sleep(2)
sp.call("C:\Program Files\Google\Chrome\Application\chrome.exe")
time.sleep(5)
pag.click(332,50) # click ther tab on chrome to set as browser
time.sleep(2)
pag.click(310,50) # click inside search field of chrome 
pag.write("https://insights.controlup.com/auth")
time.sleep(2)
pag.press(['enter'])
time.sleep(5)   
pag.click(837,495) # click in user name field
pag.write("pwaller@sproutit.co.uk")
time.sleep(1)
pag.press(['enter'])
time.sleep(2)
sp.call("C:\Program Files\Google\Chrome\Application\chrome.exe")
time.sleep(1)
time.sleep(2)
# pag.moveTo(330.58)
pag.click(330,58) # click inside search field of chrome 
pag.write("https://login.microsoftonline.com")
time.sleep(2)
pag.press(['enter'])
time.sleep(2)
pag.click(910,450) # click the user name 
time.sleep(2)
pag.click(870,445)
time.sleep(1)
pag.write(emailpassword) # type the password
pag.press(['enter'])
time.sleep(3)
pag.click(22,413) # click the outlook icon on the left of the page 
time.sleep(10) # lets wait for the control up email 
pag.click(421,94) # click in the outlook search field
pag.write("controlup") # type in control up
pag.press(['enter'])
time.sleep(10)
pag.click(460,303) # click on the latest CU email 
time.sleep(3)
pag.click(870,405) # click next to the left of the OTP
pag.dragTo(918,405)# drag the mouse to the right of the OTP
time.sleep(1)
pag.hotkey('ctrl','c')
pag.click(1896,94) # click the username 
time.sleep(1)
pag.click(1884,150) # click the logoff button
time.sleep(10)
pag.click(1894,13) # close the outlook chrome window
time.sleep(1)
pag.click(770,400) # click inside the OTP field of CU browser
pag.hotkey('ctrl','v')
pag.click(1120,570) # click continue button 
time.sleep(5)
pag.click(50,843) # click host trends
time.sleep(5)




pag.click(550,220) # click main header drop down for host trends
time.sleep(1)
pag.click(550,290) # click one line per host
time.sleep(5)

pag.click(740,220) # click select host
time.sleep(1)
pag.click(740,265) # click select host search
time.sleep(1)
pag.hotkey('ctrl','a')
pag.press('[delete]')
time.sleep(1)
pag.write("SC-LON1-SD0") # type in SC-LON1-SD0x
time.sleep(1)
pag.click(695,305) # tick first host
pag.click(695,340) # tick second host
pag.click(695,370) # tick third host
pag.click(695,400) # tick fourth host
pag.click(768,606) # click ok
time.sleep(10)
from ctypes import windll
user32 = windll.user32
user32.SetProcessDPIAware()
pag.screenshot('c:\dailyhostdata\SD-LON1-SD0.png', region=(0,0,1920,1080)) # take screenshot

# #remove ticks
pag.click(740,220) # click select host
time.sleep(1)

# pag.click(740,265) # untick host search
pag.click(695,305) # untick first host
pag.click(695,340) # untick second host
pag.click(695,370) # untick third host
pag.click(695,400) # untick fourth host



# pag.click(740,220) # click select host
# time.sleep(1)
pag.click(740,265) # click select host search
time.sleep(1)
pag.hotkey('ctrl','a')
pag.press('[delete]')
time.sleep(1)
pag.write("SC-LON1-VDI0") # type in SC-LON1-VDI0x
time.sleep(1)
pag.click(695,305) # tick first host
pag.click(695,340) # tick second host
pag.click(695,370) # tick third host
pag.click(768,606) # click ok
time.sleep(10)
from ctypes import windll
user32 = windll.user32
user32.SetProcessDPIAware()
pag.screenshot('c:\dailyhostdata\SD-LON1-VDI0.png', region=(0,0,1920,1080)) # take screenshot

# #remove ticks
pag.click(740,220) # click select host
time.sleep(1)
# pag.click(740,265) # click select host search
pag.click(695,305) # untick first host
pag.click(695,340) # untick second host
pag.click(695,370) # untick third host




# pag.click(740,220) # click select host
# time.sleep(1)
pag.click(740,265) # click select host search
time.sleep(1)
pag.hotkey('ctrl','a')
pag.press('[delete]')
time.sleep(1)
pag.write("SC-LON1-VH0") # type in SC-LON1-VH0x
time.sleep(1)
pag.click(695,305) # tick first host
pag.click(695,340) # tick second host
pag.click(695,370) # tick third host
pag.click(695,400) # tick fourth host
pag.click(695,435) # tick fifth host
pag.click(695,465) # tick sixth host
pag.click(695,496) # tick seventh host
time.sleep(1)
pag.click(768,606) # click ok
time.sleep(10)
from ctypes import windll
user32 = windll.user32
user32.SetProcessDPIAware()
pag.screenshot('c:\dailyhostdata\SD-LON1-VH0.png', region=(0,0,1920,1080)) # take screenshot

# #remove ticks
pag.click(740,220) # click select host
time.sleep(1)
# pag.click(740,265) # click select host search
# time.sleep(1)
pag.click(695,305) # untick first host
pag.click(695,340) # untick second host
pag.click(695,370) # untick third host
pag.click(695,400) # untick fourth host
pag.click(695,435) # untick fifth host
pag.click(695,465) # untick sixth host
pag.click(695,496) # untick seventh host



# pag.click(740,220) # click select host
# time.sleep(1)
pag.click(740,265) # click select host search
time.sleep(1)
pag.hotkey('ctrl','a')
pag.press('[delete]')
time.sleep(1)
pag.write("SC-LON2-SD0") # type in SC-LON2-SD0x
time.sleep(1)
pag.click(695,305) # tick first host
pag.click(695,340) # tick second host
pag.click(695,370) # tick third host
pag.click(695,400) # tick fourth host
pag.click(768,606) # click ok
time.sleep(10)
from ctypes import windll
user32 = windll.user32
user32.SetProcessDPIAware()
pag.screenshot('c:\dailyhostdata\SD-LON2-SD0.png', region=(0,0,1920,1080)) # take screenshot

#remove ticks
pag.click(740,220) # click select host
time.sleep(1)
# pag.click(740,265) # untick host search
pag.click(695,305) # untick first host
pag.click(695,340) # untick second host
pag.click(695,370) # untick third host
pag.click(695,400) # untick fourth host


# pag.click(740,220) # click select host
# time.sleep(1)
pag.click(740,265) # click select host search
time.sleep(1)
pag.hotkey('ctrl','a')
pag.press('[delete]')
time.sleep(1)
pag.write("SC-VH0") # type in SC-VH0X-LON2
time.sleep(1)
pag.click(695,340) # tick first host
pag.click(695,370) # tick second host
pag.click(695,400) # tick third host
pag.click(695,435) # tick fourth host
pag.click(768,606) # click ok
time.sleep(10)
from ctypes import windll
user32 = windll.user32
user32.SetProcessDPIAware()
pag.screenshot('c:\dailyhostdata\SD-VH0X-LON2.png', region=(0,0,1920,1080)) # take screenshot

#remove ticks
pag.click(740,220) # click select host
time.sleep(1)
# pag.click(740,265) # untick host search
pag.click(695,340) # untick first host
pag.click(695,370) # untick second host
pag.click(695,400) # untick third host
pag.click(695,435) # tick fourth host


# pag.click(740,220) # click select host
# time.sleep(1)
pag.click(740,265) # click select host search
time.sleep(1)
pag.hotkey('ctrl','a')
pag.press('[delete]')
time.sleep(1)
pag.write("SC-VDI0") # type in SC-VDI0X-LON2
time.sleep(1)
pag.click(695,305) # tick first host
pag.click(695,340) # tick second host
pag.click(695,370) # tick third host
pag.click(695,400) # tick fourth host
pag.click(695,435) # tick fifth host
pag.click(768,606) # click ok
time.sleep(10)
from ctypes import windll
user32 = windll.user32
user32.SetProcessDPIAware()
pag.screenshot('c:\dailyhostdata\SD-VDI0X-LON2.png', region=(0,0,1920,1080)) # take screenshot

#remove ticks
pag.click(740,220) # click select host
time.sleep(1)
# pag.click(740,265) # untick host search
pag.click(695,305) # untick first host
pag.click(695,340) # untick second host
pag.click(695,370) # untick third host
pag.click(695,400) # untick fourth host
pag.click(695,435) # untick fifth host

pag.click(1858,100) # Click to prepare logoff 
pag.click(1750,225) # Click to logoff 
pag.click(1895,13) # Close browser







