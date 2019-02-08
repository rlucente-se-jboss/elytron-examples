# Elytron Examples

THIS IS A WORK IN PROGRESS

This project demonstrates how to configure the elytron security
subsystem when configuring CLIENT-CERT authentication with a root
certificate authority (CA), an intermediate CA, a server certificate
and private key, and a client certificate and private key.  The
CAs, server, and client certificates can be generated using the
[intranet-test-certs](https://github.com/rlucente-se-jboss/intranet-test-certs) project.

## Prerequisites
Clone this repository to your workstation and then make sure that
the `certs` and the `dist` directories are populated according to
their respective `README.md` files.

If using the certificates from the
[intranet-test-certs](https://github.com/rlucente-se-jboss/intranet-test-certs),
make sure that the `OPENSSL_DEFAULT_PASSWORD` in the file `demo.conf`
for the intranet-test-certs project matches the `KEYSTORE_PASSWORD` and
`TRUSTSTORE_PASSWORD` in this project's `demo.conf` file.

Import the files `certs/ca.cert.pem` and `certs/intermediate.cert.pem`
into your browser as trusted authorities.  If prompted, enable the
CA certs to identify websites.  Additionally, import `certs/client.p12`
into your browser as a user certificate.

## Install
Run the following commands to install wildfly and configure the
elytron subsystem.

    pushd scripts && ./clean.sh && ./01-create-java-security-overrides.sh && ./02-setup-bcfips.sh && ./03-install.sh && ./04-config-auth.sh && popd

## Try it out
Run the application server using:

    wildfly-15.0.1.Final/bin/standalone.sh -c standalone-full-ha.xml

Once the server is fully started, browse to https://localhost:9993
and verify that you're prompted for your user certificate and
authenticated to the management web console.

