#!/bin/bash
if [[ "$1" == "-g" ]];
then
	KEY1=$(head -c 64 /dev/urandom|hexdump -v -e '1/1 "%02X"')
	IV1=$(head -c 32 /dev/urandom|hexdump -v -e '1/1 "%02X"')
	KEY2=$(head -c 64 /dev/urandom|hexdump -v -e '1/1 "%02X"')
	IV2=$(head -c 32 /dev/urandom|hexdump -v -e '1/1 "%02X"')
	KEY3=$(head -c 64 /dev/urandom|hexdump -v -e '1/1 "%02X"')
	IV3=$(head -c 32 /dev/urandom|hexdump -v -e '1/1 "%02X"')
	echo -n "$KEY1" > ./aes1.key
	echo -n "$IV1" > ./aes1.iv
	echo -n "$KEY2" > ./aes2.key
	echo -n "$IV2" > ./aes2.iv
	echo -n "$KEY3" > ./aes3.key
	echo -n "$IV3" > ./aes3.iv
	openssl genrsa -aes128 4096 -out ./rsa.prv
	openssl rsa -in rsa.prv -pubout -out ./rsa.pub
elif [[ "$1" == "-i" ]];
then
	if [[ "$2" == "" ]];
	then
		read -p "Digit your name: " CLIENT
	else
		CLIENT="$2"
	fi
	if [[ -f "$CLIENT"1.key && -f "$CLIENT"1.iv && -f "$CLIENT"2.key && -f "$CLIENT"2.iv && -f "$CLIENT"3.key && -f "$CLIENT"3.iv ]];
	then
		openssl rsautl -decrypt -inkey ./rsa.prv -in "$CLIENT"1.key -out aes1.key
		openssl rsautl -decrypt -inkey ./rsa.prv -in "$CLIENT"1.iv -out aes1.iv
		openssl rsautl -decrypt -inkey ./rsa.prv -in "$CLIENT"2.key -out aes2.key
		openssl rsautl -decrypt -inkey ./rsa.prv -in "$CLIENT"2.iv -out aes2.iv
		openssl rsautl -decrypt -inkey ./rsa.prv -in "$CLIENT"3.key -out aes3.key
		openssl rsautl -decrypt -inkey ./rsa.prv -in "$CLIENT"3.iv -out aes3.iv
	else
		echo "ERROR: ""$CLIENT""'s aes keys not exist"
	fi
elif [[ "$1" == "-x" ]];
then
	if [[ "$2" == "" ]];
	then
		read -p "Digit the customer name: " CLIENT
	else
		CLIENT="$2"
	fi
	openssl rsautl -encrypt -inkey ./rsa.pub -pubin -in aes1.key -out "$CLIENT"1.key
	openssl rsautl -encrypt -inkey ./rsa.pub -pubin -in aes1.iv -out "$CLIENT"1.iv
	openssl rsautl -encrypt -inkey ./rsa.pub -pubin -in aes2.key -out "$CLIENT"2.key
	openssl rsautl -encrypt -inkey ./rsa.pub -pubin -in aes2.iv -out "$CLIENT"2.iv
	openssl rsautl -encrypt -inkey ./rsa.pub -pubin -in aes3.key -out "$CLIENT"3.key
	openssl rsautl -encrypt -inkey ./rsa.pub -pubin -in aes3.iv -out "$CLIENT"3.iv
elif [[ "$1" == "-e" ]];
then
	if [[ -f ./aes1.key && -f ./aes1.iv &&  -f ./aes2.key && -f ./aes2.iv &&  -f ./aes3.key && -f ./aes3.iv ]];
	then
		if [[ "$KEY1" == "" ]];
		then
			KEY1=$(cat ./aes1.key)
			IV1=$(cat ./aes1.iv)
			KEY2=$(cat ./aes2.key)
			IV2=$(cat ./aes2.iv)
			KEY3=$(cat ./aes3.key)
			IV3=$(cat ./aes3.iv)
		fi
		echo "$2"
		echo -n "$2" | openssl aes-256-cbc -e -K "$KEY1" -iv "$IV1"| openssl aes-256-cbc -e -K "$KEY2" -iv "$IV2"| openssl aes-256-cbc -e -K "$KEY3" -iv "$IV3"| base64
		echo ""
	else
		echo "encryptmessgui.sh -g to generate aes keys"
	fi
elif [[ "$1" == "-d" ]];
then
	if [[ -f ./aes1.key && -f ./aes1.iv &&  -f ./aes2.key && -f ./aes2.iv &&  -f ./aes3.key && -f ./aes3.iv ]];
	then
		if [[ "$KEY1" == "" ]];
		then
			KEY1=$(cat ./aes1.key)
			IV1=$(cat ./aes1.iv)
			KEY2=$(cat ./aes2.key)
			IV2=$(cat ./aes2.iv)
			KEY3=$(cat ./aes3.key)
			IV3=$(cat ./aes3.iv)
		fi
		echo -n "$2" | base64 -d | openssl aes-256-cbc -d -K "$KEY3" -iv "$IV3" | openssl aes-256-cbc -d -K "$KEY2" -iv "$IV2" | openssl aes-256-cbc -d -K "$KEY1" -iv "$IV1"
		echo ""
	else
		echo "encryptmessgui.sh -g to generate aes keys"
	fi
else
	echo "arg1=-g|-e|-d|-x|-i"
	echo "arg2=encrypted text|plain text"
	echo -e "example, encryptmessgui -g\t\t\tto generate KEY and IV"
	echo -e "example, encryptmessgui -e \"text\"\t\tencrypt plain text message"
	echo -e "example, encryptmessgui -d \"encrypted text\"\tdecrypt encrypted text message"
	echo -e "example, encryptmessgui -x \"client name\"\texport your aes keys for a client"
	echo -e "example, encryptmessgui -i \"your name\"\t\timport other aes keys (delete your actual aes keys)"
fi
