#region modules
# get out of programm 
####################################################
####                                            ####
####                                            ####
####              import modules                ####
####                                            ####
####                                            ####
####################################################
print("Load modules")
import ctypes
import time
import shutil
# os.chdir("c:\Anaconda3\Lib\site-packages\pip")
import time as time
from types import ClassMethodDescriptorType 
import webbrowser as web
import pyautogui as pag 
import subprocess as sp
import pyperclip as pc
from shutil import copyfile
import smtplib
import os  as os 
import keyboard as kb
from email.message import EmailMessage
from ctypes import windll

from cryptography.fernet import Fernet
user32 = windll.user32
user32.SetProcessDPIAware()

#endregion

#region vars

####################################################
####                                            ####
####                                            ####
####              Variables                     ####
####                                            ####
####                                            ####
####################################################

print("Create variables")
imagerootfilepath = 'e:\dailyhostdata'
autopyusername = "autopy"
autopypass = 'W3lcomeT0aut0mat1on101'
outlookusername = "pwaller@sproutit.co.uk"
outlookurl = "https://login.microsoftonline.com"
insightsurl = "https://insights.controlup.com/auth"
grafanurl = "http://infrastructurechecks.sproutcloud.co.uk:3000/login"
egurl = "https://vsceg.sproutcloud.local/final/#!"
egusername = "a-pwaller"
# emailpassword = pag.password('Enter password for browsers (text will be hidden)')

#endregion

#region decryption
start = time.time()
####################################################
####                                            ####
####                                            ####
####              Decrypt data                  ####
####                                            ####
####                                            ####
####################################################
### load key 
# while kb.is_pressed('q') == 'False':


print("Load decryptoin keys and decrypt password files")
with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\pyautokey.key', 'rb') as mykey:
    key = mykey.read()

print(key)

##end load key 

### decrypt file 

f = Fernet(key)

with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\enc_outlookemailpass.txt', 'rb') as encrypted_file:
    encrypted = encrypted_file.read()

decrypted = f.decrypt(encrypted)

with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\dec_outlookemailpass.txt', 'wb') as decrypted_file:
    decrypted_file.write(decrypted)


with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\enc_egadminpass.txt', 'rb') as encrypted_file:
    encrypted = encrypted_file.read()

decrypted = f.decrypt(encrypted)

with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\dec_egadminpass.txt', 'wb') as decrypted_file:
    decrypted_file.write(decrypted)


### end decrypt file 

####################################################
####                                            ####
####                                            ####
####             copy password data             ####
####                                            ####
####                                            ####
####################################################

print("copy decrypted files")
os.chdir(r'Y:\\')
for i in os.listdir('./'):
    # if i == 'dec_outlookemailpass.txt and dec_egadminpass.txt':
    if ('dec_outlookemailpass.txt') or ('dec_egadminpass.txt') in i:
        print(i)
        os.system('copy dec_outlookemailpass.txt dec_new_outlookemailpass.txt')
        os.system('copy dec_egadminpass.txt dec_new_egadminpass.txt')

print("obtain email password")
with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\dec_new_outlookemailpass.txt', 'r') as file:
    emailpassword=file.read()
time.sleep(1)

print("obtain eg password")
with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\dec_new_egadminpass.txt', 'r') as file:
    egadminpasword=file.read()

time.sleep(1)

####################################################
####                                            ####
####                                            ####
####             delete decrypt data            ####
####                                            ####
####                                            ####
####################################################
print("Remove all clear text password data")
try:
    os.remove('dec_outlookemailpass.txt')
except:
    ctypes.windll.user32.MessageBoxW(0, "cannot delete dec_outlookemailpass.txt", "Warning!", 16)
try:
    os.remove('dec_new_outlookemailpass.txt')
except:
    ctypes.windll.user32.MessageBoxW(0, "cannot delete dec_new_outlookemailpass.txt", "Warning!", 16)
try:
    os.remove('dec_egadminpass.txt')
except:
    ctypes.windll.user32.MessageBoxW(0, "cannot delete dec_egadminpass.txt ", "Warning!", 16)
try:
    os.remove('dec_new_egadminpass.txt')
except:
    ctypes.windll.user32.MessageBoxW(0, "cannot delete dec_new_egadminpass.txt ", "Warning!", 16)

#endregion

#region dir data

####################################################
####                                            ####
####                                            ####
####             Directory data                 ####
####                                            ####
####                                            ####
####################################################
while kb.is_pressed('q') == False:
        print(f"if {imagerootfilepath} not available then create it")
        if os.path.isdir(imagerootfilepath):
            "true"
        else:
            os.mkdir(imagerootfilepath)

        print("Open browser chrome")
        try:
            web.open("https://Google.com")
        except:
            ctypes.windll.user32.MessageBoxW(0, "Error loading browser", "Warning!", 16)

        #endregion

        #region insights

        ####################################################
        ####                                            ####
        ####                                            ####
        ####             Insights data                  ####
        ####                                            ####
        ####                                            ####
        ####################################################
        print("open second chrome browser for Insights")
        # sp.call("C:\Program Files\Google\Chrome\Application\chrome.exe")
        time.sleep(2)
        sp.call("C:\Program Files\Google\Chrome\Application\chrome.exe")
        time.sleep(5)
        pag.click(332,50) # click ther tab on chrome to set as browser
        time.sleep(2)
        pag.click(310,50) # click inside search field of chrome 
        pag.write(insightsurl)
        time.sleep(2)
        pag.press(['enter'])
        time.sleep(5)   
        pag.click(837,495) # click in user name field
        pag.write(outlookusername)
        time.sleep(1)
        pag.press(['enter'])
        time.sleep(2)
        print("open second chrome browser for Outlook")
        sp.call("C:\Program Files\Google\Chrome\Application\chrome.exe")
        time.sleep(1)
        time.sleep(2)
        # pag.moveTo(330.58)
        pag.click(330,58) # click inside search field of chrome 
        pag.write(outlookurl)
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


        #region SC-LON1-SD0

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
        # from ctypes import windll
        # user32 = windll.user32
        # user32.SetProcessDPIAware()
        pag.screenshot('e:\dailyhostdata\SD-LON1-SD0.png', region=(0,0,1920,1080)) # take screenshot

        # #remove ticks
        pag.click(740,220) # click select host
        time.sleep(1)

        # pag.click(740,265) # untick host search
        pag.click(695,305) # untick first host
        pag.click(695,340) # untick second host
        pag.click(695,370) # untick third host
        pag.click(695,400) # untick fourth host

        #endregion 

        #region SC-LON1-VDI0

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
        # from ctypes import windll
        # user32 = windll.user32
        # user32.SetProcessDPIAware()
        pag.screenshot('e:\dailyhostdata\SD-LON1-VDI0.png', region=(0,0,1920,1080)) # take screenshot

        # #remove ticks
        pag.click(740,220) # click select host
        time.sleep(1)
        # pag.click(740,265) # click select host search
        pag.click(695,305) # untick first host
        pag.click(695,340) # untick second host
        pag.click(695,370) # untick third host

        #endregion

        #region SC-LON1-VH0

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
        # from ctypes import windll
        # user32 = windll.user32
        # user32.SetProcessDPIAware()
        pag.screenshot('e:\dailyhostdata\SD-LON1-VH0.png', region=(0,0,1920,1080)) # take screenshot

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

        #endregion

        #region SC-LON2-SD0

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
        # from ctypes import windll
        # user32 = windll.user32
        # user32.SetProcessDPIAware()
        pag.screenshot('e:\dailyhostdata\SD-LON2-SD0.png', region=(0,0,1920,1080)) # take screenshot

        #remove ticks
        pag.click(740,220) # click select host
        time.sleep(1)
        # pag.click(740,265) # untick host search
        pag.click(695,305) # untick first host
        pag.click(695,340) # untick second host
        pag.click(695,370) # untick third host
        pag.click(695,400) # untick fourth host

        #endregion

        #region SC-VH0

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
        # from ctypes import windll
        # user32 = windll.user32
        # user32.SetProcessDPIAware()
        pag.screenshot('e:\dailyhostdata\SD-VH0X-LON2.png', region=(0,0,1920,1080)) # take screenshot

        #remove ticks
        pag.click(740,220) # click select host
        time.sleep(1)
        # pag.click(740,265) # untick host search
        pag.click(695,340) # untick first host
        pag.click(695,370) # untick second host
        pag.click(695,400) # untick third host
        pag.click(695,435) # tick fourth host

        #endregion

        #region SC-VDI0

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
        # from ctypes import windll
        # user32 = windll.user32
        # user32.SetProcessDPIAware()
        pag.screenshot('e:\dailyhostdata\SD-VDI0X-LON2.png', region=(0,0,1920,1080)) # take screenshot

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

        #endregion

        #endregion

        #region grafan
        ####################################################
        ####                                            ####
        ####                                            ####
        ####             Grafana data                   ####
        ####                                            ####
        ####                                            ####
        ####################################################

        print("obtain grafana data")
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
        pag.click(695,701) # click VMM_configuration_Management
        time.sleep(1)
        pag.click(700,800) # click VMM_configuration
        time.sleep(5)
        pag.screenshot('e:\dailyhostdata\VMM_Configuration.png', region=(0,0,1920,1080)) # take screenshot

        pag.click(30,180) # click dashboards
        time.sleep(1)
        pag.click(95,250) # click manage
        time.sleep(1)
        pag.click(700,400) # click HyperV_configuration_Management
        time.sleep(1)
        pag.click(700,425) # click HyperV_configuration
        time.sleep(5)
        pag.screenshot('e:\dailyhostdata\HyperV_Configuration.png', region=(0,0,1920,1080)) # take screenshot


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

        #endregion 

        #region eg
        ####################################################
        ####                                            ####
        ####                                            ####
        ####                EG data                     ####
        ####                                            ####
        ####                                            ####
        ####################################################

        print("obtain eg data")

        print("open first browser IE")
        sp.Popen(r'"C:\Program Files\Internet Explorer\IEXPLORE.EXE" www.google.com')
        time.sleep(3)
        print("open second browser IE")
        sp.call("C:\Program Files\Internet Explorer\iexplore.exe")
        time.sleep(3)
        pag.click(845,505) # click ed username 
        pag.write(egusername)
        pag.click(845,565) # click the eg password field
        pag.write(egadminpasword)
        pag.click(1035,625) # click the eg login button
        time.sleep(5)
        # pag.locateOnScreen('egmonitorbtn.PNG',confidence=0.8)
        # pag.click(pag.locateOnScreen('egmonitorbtn.PNG',confidence=0.5,grayscale=True)) # eg monitor button click 
        pag.click(305,105) # eg monitor button click
        time.sleep(5)
        # pag.click(pag.locateOnScreen('nimblestorage.PNG',confidence=0.8)) # click nimble storage in home screen
        pag.click(320,345) # click nimble storage in home screen
        time.sleep(5)
        # pag.click(pag.locateOnScreen('nimb1.PNG',confidence=0.8)) # click nimble1 icon
        pag.click(300,255) # click nimble1 icon
        time.sleep(5)
        pag.click(430,295) # click nimble system 
        time.sleep(3)
        pag.click(320,325) # click nimble io perf 
        time.sleep(1)
        pag.screenshot('e:\\dailyhostdata\\nimble1.png', region=(0,0,1920,1080)) # take screenshot
        time.sleep(1)
        pag.click(1875,150) # click back
        time.sleep(3)
        # pag.click(pag.locateOnScreen('nimb2.PNG',confidence=0.9)) # click nimble1 icon
        pag.click(530,255) # click nimble2 icon
        time.sleep(5)
        pag.click(430,295) # click nimble system 
        time.sleep(3)
        pag.click(320,325) # click nimble io perf 
        time.sleep(5)
        pag.screenshot('e:\\dailyhostdata\\nimble2.png', region=(0,0,1920,1080)) # take screenshot
        time.sleep(2)
        # pag.click(pag.locateOnScreen('eglogout.PNG',confidence=0.9)) # logoff
        pag.click(1892,103) # Logoff 
        time.sleep(2)

        #endregion

        #region email 
        ####################################################
        ####                                            ####
        ####                                            ####
        ####                Email data                  ####
        ####                                            ####
        ####                                            ####
        ####################################################
        msg=EmailMessage()
        msg['Subject']="Insights Data"
        msg['From']="AutoPy@sproutit.co.uk"
        msg['To']="infrastructure.management@sproutit.co.uk"


        os.chdir('E://dailyhostdata')
        for i in os.listdir('./'):
            if i.endswith('.png'):
                with open(i,"rb") as file:
                    myfile_data = file.read()
                    myfile_name = file.name
                    msg.add_attachment(myfile_data,maintype="application",subtype="octet-stream",filename=myfile_name)

        with smtplib.SMTP('vSTMAIL1.london.sprout.local',25) as server:
            server=smtplib.SMTP('vSTMAIL1.london.sprout.local',25)
            server.send_message(msg)

        print("email Sent!")

        #endregion


        end = time.time()
        print(end - start)

