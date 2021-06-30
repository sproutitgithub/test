### load key 
from cryptography.fernet import Fernet
with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\pyautokey.key', 'rb') as mykey:
    key = mykey.read()

print(key)

##end load key 

### decrypt file 

f = Fernet(key)

with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\enc_pass.txt', 'rb') as encrypted_file:
    encrypted = encrypted_file.read()

decrypted = f.decrypt(encrypted)

with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\dec_pass.txt', 'wb') as decrypted_file:
    decrypted_file.write(decrypted)


### end decrypt file 