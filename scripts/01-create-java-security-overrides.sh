#!/usr/bin/env bash

. $(dirname $0)/../demo.conf

tmpfile=$(mktemp /tmp/security.providers.list.XXXXXX)

PUSHD "$WORK_DIR"

cat > java.security.properties <<END1
#
# This file overrides the values in the java.security policy file
# which can be found in:
#
#    JRE_HOME=$JRE_HOME
#    \$JRE_HOME/lib/security/java.security
#
END1

JAVA_SECURITY_POLICY="$JRE_HOME/lib/security/java.security"
grep -E '^security.provider.[0-9]+=' $JAVA_SECURITY_POLICY | \
    grep -v 'com\.sun\.net\.ssl\.internal\.ssl\.Provider' > $tmpfile

newnum=2
for prov in $(cat $tmpfile)
do
    provnum=$(echo $prov | cut -d. -f3 | cut -d= -f1)
    (( newnum = newnum + 1 ))
    echo $prov | sed "s/\.$provnum=/\.$newnum=/g"
done > $tmpfile.1

echo "security.provider.1=org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider" >> java.security.properties
echo "security.provider.2=org.bouncycastle.jsse.provider.BouncyCastleJsseProvider fips:BCFIPS" >> java.security.properties
cat "$tmpfile.1" >> java.security.properties

cat >> java.security.properties <<END2

securerandom.source=file:/dev/urandom
securerandom.strongAlgorithms=DEFAULT:BCFIPS
ssl.KeyManagerFactory.algorithm=X509

END2
POPD

rm -f "$tmpfile" "$tmpfile.1"

