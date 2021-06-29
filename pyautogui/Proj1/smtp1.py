####################################################
####                                            ####
####                                            ####
####                Email data                  ####
####                                            ####
####                                            ####
####################################################
import smtplib
import os  as os 
from email.message import EmailMessage
msg=EmailMessage()
msg['Subject']="Insights Data"
msg['From']="AutoPy@sproutit.co.uk"
msg['To']="infrastructure.management@sproutit.co.uk"



for i in os.listdir("c:\dailyhostdata"):
    if i.endswith('.png'):
        with open(i,"rb") as file:
            myfile_data = file.read()
            myfile_name = file.name
            msg.add_attachment(myfile_data,maintype="application",subtype="octet-stream",filename=myfile_name)

with smtplib.SMTP('vSTMAIL1.london.sprout.local',25) as server:
    server=smtplib.SMTP('vSTMAIL1.london.sprout.local',25)
    server.send_message(msg)

print("email Sent!")
