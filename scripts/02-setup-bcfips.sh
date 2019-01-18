#!/usr/bin/env bash

. $(dirname $0)/../demo.conf

PUSHD $WORK_DIR
echo

echo "Provide password if prompted by sudo"
sudo cp dist/bc*.jar $JRE_HOME/lib/ext

echo -n "Import root CA .............. "
keytool -importcert \
        -trustcacerts \
        -file certs/ca.cert.pem \
        -keystore ${TRUSTSTORE_FILE} \
        -storetype bcfks \
        -storepass "${TRUSTSTORE_PASSWORD}" \
        -alias root_ca \
        -noprompt \
        -J-Djava.security.properties=java.security.properties \
        &> /dev/null
ISOK

echo -n "Import intermediate CA ...... "
keytool -importcert \
        -trustcacerts \
        -file certs/intermediate.cert.pem \
        -keystore ${TRUSTSTORE_FILE} \
        -storetype bcfks \
        -storepass "${TRUSTSTORE_PASSWORD}" \
        -alias intermediate_ca \
        -noprompt \
        -J-Djava.security.properties=java.security.properties \
        &> /dev/null
ISOK

echo    "*** Must import client cert into truststore! ***"
echo -n "Import client certificate ... "
keytool -importcert \
        -file certs/client.cert.pem \
        -keystore ${TRUSTSTORE_FILE} \
        -storetype bcfks \
        -storepass "${TRUSTSTORE_PASSWORD}" \
        -alias ${CLIENT_ALIAS} \
        -noprompt \
        -J-Djava.security.properties=java.security.properties \
        &> /dev/null
ISOK

echo -n "Import server certificate ... "
keytool -importkeystore \
        -srckeystore certs/server.p12 \
        -srcstoretype pkcs12 \
        -srcstorepass "${KEYSTORE_PASSWORD}" \
        -destkeystore ${KEYSTORE_FILE} \
        -deststoretype bcfks \
        -deststorepass "${KEYSTORE_PASSWORD}" \
        -J-Djavax.net.ssl.trustStore=${TRUSTSTORE_FILE} \
        -J-Djava.security.properties=java.security.properties \
        &> /dev/null
ISOK

echo "Dumping ${TRUSTSTORE_FILE} ... "
keytool -list \
        -keystore ${TRUSTSTORE_FILE} \
        -storetype bcfks \
        -storepass "${TRUSTSTORE_PASSWORD}" \
        -J-Djava.security.properties=java.security.properties

echo "Dumping ${KEYSTORE_FILE} ... "
keytool -list \
        -keystore ${KEYSTORE_FILE} \
        -storetype bcfks \
        -storepass "${KEYSTORE_PASSWORD}" \
        -J-Djava.security.properties=java.security.properties

echo
POPD

