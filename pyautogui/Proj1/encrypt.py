### encrypt password
# from cryptography.fernet import Fernet
# key = Fernet.generate_key()
# crypt = Fernet(key)
# pw = crypt.encrypt(b'Camberwe!!Carr0t!') # encrypt it here with password 

# decryptstring = crypt.decrypt(pw)
# print(pw)
# print(decryptstring)



from cryptography.fernet import Fernet
# key = Fernet.generate_key()

# # create key file 
# with open(r"\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\pyautokey.key",'wb') as mykey:
#     mykey.write(key)

# # read and store key in RAM 
# with open(r"\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\pyautokey.key",'rb') as mykey:
#     key = mykey.read()

# # encrypt a file
# from cryptography.fernet import Fernet
# file = Fernet.generate_key()

# with open(r"\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\Pyautopass.txt",'rb') as orig_file:
#     original = orig_file.read()

# encrypted = file.encrypt(original)

# with open(r"\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\Pyautopass.txt",'wb') as enc_file:
#     enc_file.write(encrypted)

# fhread = open(r"\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\pyautokey.txt",'r')
# print(fhread.readline())


# fh= open('c:\\test.txt', 'w')
# fh.write("hi")

from cryptography.fernet import Fernet

### create the key and write to key dir 
# key = Fernet.generate_key()

# with open(r'key\\mykey.key', 'wb') as mykey:
#     mykey.write(key)

##end 



#### read the key and read the original file with password
# with open(r'key\\mykey.key', 'rb') as mykey:
#     key = mykey.read()

# f = Fernet(key)

# with open(r'protected\\pass.txt', 'rb') as original_file:
#      original = original_file.read()

###end  read

### write the encrypted file - i can then delete the unencrypted file 

f = Fernet(key)

encrypted = f.encrypt(original)

with open (r'protected\\enc_pass.txt', 'wb') as encrypted_file:
    encrypted_file.write(encrypted)

###end encrypt


### read the encrypted file and decrypt using the key 
# f = Fernet(key)

# with open(r'protected\\enc_pass.txt', 'rb') as encrypted_file:
#     encrypted = encrypted_file.read()

# decrypted = f.decrypt(encrypted)

# with open(r'protected\\dec_pass.txt', 'wb') as decrypted_file:
#     decrypted_file.write(decrypted)

###end decrypr 