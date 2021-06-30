## generate key 

from cryptography.fernet import Fernet
key = Fernet.generate_key()

with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\pyautokey.key', 'wb') as mykey:
    mykey.write(key)


#### end generate 

