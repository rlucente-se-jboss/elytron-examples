#!/usr/bin/env bash

. $(dirname $0)/../demo.conf

PUSHD ${WORK_DIR}
  echo

  echo -n "Copy keystores ............................. "
  cp *.bcfks ${JBOSS_HOME}/standalone/configuration
  ISOK

  tmpfile=$(mktemp /tmp/cli.XXXXXX)

  echo -n "Resolve variables in CLI ................... "
  envsubst < cli/elytron-twoway-tls.cli > ${tmpfile}
  ISOK

  echo -n "Configure two way TLS for mgmt auth ........ "
  JAVA_OPTS="-Djava.security.properties=java.security.properties" \
    ${JBOSS_HOME}/bin/jboss-cli.sh \
    --file=${tmpfile} &> /dev/null
  ISOK
  
  echo -n "Clean up the CLI file ...................... "
  rm -fr ${tmpfile}
  ISOK
 
  echo
POPD

