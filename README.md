# encryptmesscli
this script use openssl with aes-256-cbc and rsa to encrypt message <strong>3 times</strong> for email or chat

## How to use it:
- Generate AES and RSA keys: digit
```
./encryptmesscli.sh -g
```
to generate AES keys and RSA pair keys;
<hr>
- Export your aes keys: your customer have got to copy his rsa.pub key and send it to you. With your customer's rsa.pub key, digit

```
./encryptmesscli.sh -x
```
enter the name of sent customer rsa.pub key (example, alice.pub); the script will encrypt your aes key with your client rsa.pub key;
<hr>
- Import a customer aes keys: once you have a client aes keys, use

```
./encryptmesscli.sh -i
```
and digit your name (example, alice), and your customer aes keys will be import (ATTENTION: your actual aes keys will be overwritten)
<hr>
- Encrypt a message: once generate AES and RSA keys and then shared aes keys with your customer, digit

```
./encryptmesscli.sh -e "some text"
```
and the script will encrypt <strong>3 times</strong> it and encode in base64; it will be ready to be sent via mail or chat.
<hr>
- Decrypt a message once you have received an encrypted message, digit

```
./encryptmesscli.sh -d "encrypted text"
```
and the script will decrypt the message!
