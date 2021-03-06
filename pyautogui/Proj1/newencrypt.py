## generate key 

from cryptography.fernet import Fernet
key = Fernet.generate_key()

with open(r'key\\mykey.key', 'wb') as mykey:
    mykey.write(key)


#### end generate 


### load key 

with open(r'key\\mykey.key', 'rb') as mykey:
    key = mykey.read()

print(key)

##end load key 

### decrypt file 

f = Fernet(key)

with open(r'protected\\enc_pass.txt', 'rb') as encrypted_file:
    encrypted = encrypted_file.read()

decrypted = f.decrypt(encrypted)

with open(r'protected\\dec_pass.txt', 'wb') as decrypted_file:
    decrypted_file.write(decrypted)


### end decrypt file 