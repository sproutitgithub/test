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

### encrypt file 

f = Fernet(key)

with open(r'protected\\pass.txt', 'rb') as orig_pass:
    original = orig_pass.read()

encrypted = f.encrypt(original)

with open (r'protected\\enc_pass.txt', 'wb') as encrypted_file:
    encrypted_file.write(encrypted)

###end encrypt file 