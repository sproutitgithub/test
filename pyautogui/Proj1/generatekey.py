## generate key 

from cryptography.fernet import Fernet
key = Fernet.generate_key()

with open(r'key\\mykey.key', 'wb') as mykey:
    mykey.write(key)


#### end generate 