import os
import shutil
# os.chdir("c:\Anaconda3\Lib\site-packages\pip")
import time as time 
import webbrowser as web
import pyautogui as pag 
import subprocess as sp
import pyperclip as pc
from shutil import copyfile
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

chrome_options = Options()
chrome_options.add_argument("--start-maximized")

driver = webdriver.Chrome(chrome_options=chrome_options)
driver.get('https://google.com')