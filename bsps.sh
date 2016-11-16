#!/bin/bash

VERSION="0.1.0"

CAPITALS=true
LENGTH=16
MIN_LENGTH=8
MAX_LENGTH=64
NUMBERS=true
SPECIALS=true
YEAR=`date +%Y`

while [[ $# -gt 0 ]]
do

key="$1"
case "$key" in
    "-c"|"--nocaps" )
    CAPITALS=false
    ;;
    "-l"|"--length" )
    LENGTH="$2"
    shift
    ;;
    "-n"|"--nonums" )
    NUMBERS=false
    ;;
    "-s"|"--nospecs" )
    SPECIALS=false
    ;;
    "-v"|"--version" )
    echo "v $VERSION"
    exit
    ;;
    "-y"|"--year" )
    
    YEAR="$2"
    
    shift
    ;;
    * )
    echo "Invalid option $1"
    ;;
esac

shift

done

# ensure that the LENGTH is within acceptable bounds
if [[ $LENGTH -lt $MIN_LENGTH ]]
then
    LENGTH=$MIN_LENGTH
elif [[ $LENGTH -gt $MAX_LENGTH ]]
then
    LENGTH=$MAX_LENGTH
fi

echo "Type host name and press [ENTER]"

read HOST

echo "Type username and press [ENTER]"

read USERNAME

echo "Please type your unique password and press [ENTER]"

read -s PASSWORD
# get the digest of the SHA-512 hash
DIGEST=`echo "$HOST$PASSWORD$USERNAME$YEAR" | openssl sha512 -binary`

ENCODED=`echo "$DIGEST" | base64 -w 0`
PWORD=`echo "$ENCODED" | cut -c1-$LENGTH`

# replace all slashes with either !'s or a's
if [[ $SPECIALS = true ]]
then
    PWORD="${PWORD//\//!}"
else
    PWORD="${PWORD//\//a}"
fi
# replace all plus signs with either $'s or b's
if [[ $SPECIALS = true ]]
then
    PWORD="${PWORD//+/$}"
else
    PWORD="${PWORD//+/b}"
fi
# replace all equal signs with either #'s or c's
if [[ $SPECIALS = true ]]
then
    PWORD="${PWORD//=/#}"
else
    PWORD="${PWORD//=/c}"
fi
if [[ $SPECIALS = true ]]
then
    # ensure a minimum of 2 special characters
    if [[ $(grep -o "[!#\$]" <<< "$PWORD" | wc -l) -lt 2 ]]
    then
        PWORD=`echo "$PWORD" | sed -e 's/./!/4'`
        PWORD=`echo "$PWORD" | sed -e 's/./!/8'`
    fi
else
    # replace all special characters with the number 0
    PWORD=`echo "$PWORD" | sed -e 's/[!#\$]/0/'`
fi
if [[ $NUMBERS = true ]]
then
    # ensure a minimum of 2 numbers
    if [[ $(grep -o "[0-9]" << "$PWORD" | wc -l) -lt 2 ]]
    then
        PWORD=`echo "$PWORD" | sed -e 's/[a-zA-Z]/1/1'`
        PWORD=`echo "$PWORD" | sed -e 's/[a-zA-Z]/2/2'`
    fi
else
    # replace all numbers with the characters A-J
    PWORD=`echo "$PWORD" | tr 0123456789 ABCDEFGHIJ`
fi
if [[ $CAPITALS = true ]]
then
    # ensure a minimum of 2 uppercase characters
    if [[ $(grep -o "[A-Z]" <<< "$PWORD" | wc -l) -lt 2 ]]
    then
        PWORD=`echo "$PWORD" | sed -e 's/[a-z]/A/1'`
        PWORD=`echo "$PWORD" | sed -e 's/[a-z]/B/2'`
    fi
else
    # replace all uppercase letters with lowercase letters
    PWORD=`echo "$PWORD" | tr [:upper:] [:lower:]`
fi
if [[ $(grep -o "[a-z]" <<< "$PWORD" | wc -l) -lt 2 ]]
then
    PWORD=`echo "$PWORD" | sed -e 's/./a/6'`
    PWORD=`echo "$PWORD" | sed -e 's/./b/7'`
fi

echo "Password"
echo "========"
echo "$PWORD"
