# BashPass #

**BashPass** is a very simplistic password generator. The password generated
for any given set of inputs depends on the current year. A previous year's 
password can be generated as well.

It should be used to set your password and to retrieve it as needed. It will
give a new password for the same inputs every year, facilitating password
changes.

## Getting Started #

Just install this somewhere and run the file this way:

```
bash bsps.sh [args]
```

or `chmod +x bsps.sh` in order to allow direct execution:

```
./bsps.sh [args]
```

## Use #

By default, you will get a 16 character password that contains lowercase
letters, uppercase letters, numbers, and special characters. Arguments
can be given to change the default behavior.

```
bsps.sh
```

You will be prompted to give a host (the service), your login, and a password
of your choosing. Those will be used along with the current year to generate
your password.

Example inputs:

```
Provide host:
gmail.com
Provide username:
john.f.marion
Provide password:
[silent input]
```

It does not really matter what is put in, the same inputs during the same year
will always generate the same password.

### The Version #

Check the version before using. Different versions will likely produce
different outputs.

```
bsps.sh -v
bsps.sh --version
```

### Changing Password Length #

The maximum possible password length is 64 and the minimum possible length is 8.

To set the length to 10, for example:

```
bsps.sh -l 10
bsps.sh --length 10
```

### A New Year #

Use `-y` to get the password for a different year.

Once a new year (GMT time) arrives, you will need to get the previous year's
password:

```
bsps.sh -y 2015
bsps.sh --year 2015
```

Use that to log in to whichever service, then change your password using current
year settings.

### Changing Password Characteristics #

```bash
bsps.sh -n        # no numbers
bsps.sh -nonums   # no numbers
bsps.sh -c        # no caps
bsps.sh --nocaps  # no caps
bsps.sh -s        # no special characters
bsps.sh --nospecs # no special characters
```

You can combine these but you cannot do things like `-nc`.

```
bsps -c -n # no caps and no numbers
```

## By #

[John F Marion](http://www.johnfmarion.com/)