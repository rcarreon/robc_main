
This directory contains Evolve Media's Root certificate and private key, 
as well as any certs that have been signed with the key.  The password for the 
Root CA's private key is found in the sysadmin root.kdb for use with keepass.


The Root CA's public key is distributed to all virtual machines via the sssd 
puppet module, since ldap auth via sssd must be encrypted.  This may be moved 
to the ldap or auth module at a later time.


Although it wasn't adhered to for the first 2 certificates signed with the new
CA (ldap.gnmedia.net and dev.ldap.gnmedia.net) I suggest using a serial
number that adheres to a format similar to that of dns zone files: 
e.g. 2014041101.  The only requirement from rfc2459 (section 3.3 and 4.1.2.2) 
is that certificates be a unique positive integer (perhaps 32 bit) for a given 
CA for use with CRL (certificate revocation lists), since we are not currently 
using a CA server this is merely a formality, but should keep us in a good 
place should we ever wish to implement one.



The Evolve Media  Root CA is valid until April 4, 2034.



Quick howto:

Make a CSR:

openssl req -out newcertificate.csr -new -newkey rsa:2048 -nodes \
-keyout newcertificate.key


After generating a CSR, you can sign the CSR using the Root CA like so:

openssl x509 -req -days 1825 -in newcertificate.csr -CA evmrootca.crt \
-CAkey evmrootca.key -set_serial 2014041401 -out newcertificate.crt

Again, the password can be found in the sysadmin (root.kdb) keepass file.


NOTE: the .p12 file extension found is used for importing the certificate 
into a cert db like the one found in 389 Directory Server.  As an example the 
one for ldap.gnmedia.net was generated like so: 

openssl pkcs12 -export -inkey ldap.gnmedia.net.key -in ldap.gnmedia.net.crt \
-out ldap.gnmedia.net.p12 -nodes -name 'ldap.gnmedia.net'


--rkruszewski  04142014


