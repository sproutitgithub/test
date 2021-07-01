def gen_key_and_pass(keyname,passphrase,filename):


    from cryptography.fernet import Fernet
    key = Fernet.generate_key()

    os.chdir(r'Y:\\')
        with open(r'$filename.txt', 'w') as filecreate:
            filecreate.write(filecreate)

    with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\keyname.key', 'wb') as mykey:
        mykey.write(key)

    with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\keyname.key', 'rb') as mykey:
        key = mykey.read()

    
    f = Fernet(key)

    with open(r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\$filename.txt', 'rb') as orig_pass:
        original = orig_pass.read()

    encrypted = f.encrypt(original)

    with open (r'\\vscdevops\\buildconfigurations\\Sprout Cloud\\Configs\\Secure\\pyauto\\enc_$filename.txt', 'wb') as encrypted_file:
        encrypted_file.write(encrypted)