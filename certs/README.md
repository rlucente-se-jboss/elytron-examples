This folder *MUST* contain the following files:

* `ca.cert.pem` - the root certificate authority (root CA)
* `intermediate.cert.pem` - the intermediate certificate authority (intermediate CA)
* `client.cert.pem` - the client certificate to add to the truststore
* `server.p12` - the server certificate and key as a PKCS#12 keystore

This folder MAY include the following file if you want to add a CRL
to the truststore:

* `intermediate-ca.crl` - the certificate revocation list in DER format

This folder MAY include the following file but this really needs
to be imported into the client's browser along with `ca.cert.pem`
and `intermediate.cert.pem`:

* `client.p12` - the client certificate and key in a PKCS#12 keystore

