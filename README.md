# encryptmesscli
this script use openssl with aes-256-cbc and rsa to encrypt message <strong>3 times</strong> for email or chat

## How to use it:
- Generate AES and RSA keys: digit
```
./encryptmesscli.sh -g
```
to generate AES keys and RSA pair keys; the script could require to digit a pass phrase.
<hr>

- Export your aes keys: your customer have got to copy his rsa.pub key, rename it with his name (example, alice.pub) and send it to you. With the customer's rsa.pub key, digit

```
./encryptmesscli.sh -x
```
enter the name of sent customer rsa.pub key (example, alice); the script will encrypt your AES keys with the customer rsa.pub key; the script will create 6 new AES keys with customer name. these 6 keys are ready to send to your customer.
<hr>

- Import received the provider aes keys: once you have the provider AES keys, use

```
./encryptmesscli.sh -i
```
and digit your name (example, alice), and your provider AES keys will be import (ATTENTION: your actual AES keys will be overwritten)
<hr>

- Encrypt a message: once generate AES and RSA keys and then shared AES keys with your customer, digit

```
./encryptmesscli.sh -e "some text"
```
and the script will encrypt <strong>3 times</strong> it and encode in base64; the encrypted message will be ready to be sent via mail or chat.
<hr>

- Decrypt a message: once you have received an encrypted message from your customer or provider, digit

```
./encryptmesscli.sh -d "encrypted text"
```
and the script will decrypt the message!
