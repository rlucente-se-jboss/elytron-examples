#!/usr/bin/env bash

. $(dirname $0)/../demo.conf

PUSHD ${WORK_DIR}
  echo

  echo -n "Installing wildfly-${VER_INST_EAP} ............ " 
  unzip -q ${BIN_DIR}/wildfly-${VER_DIST_EAP}.zip
  ISOK

  echo -n "Enable admin user .......................... "
  ${JBOSS_HOME}/bin/add-user.sh -u admin -p "admin1jboss!" --silent
  ISOK

  echo -n "Remove admin password since using TLS ...... "
  sed -i.bak 's/^\(admin=\)..*/\1/g' ${JBOSS_HOME}/domain/configuration/mgmt-users.properties && \
    sed -i.bak 's/^\(admin=\)..*/\1/g' ${JBOSS_HOME}/standalone/configuration/mgmt-users.properties
  ISOK

  echo -n "Fix enable-elytron script per WFLY-11536 ... "
  sed -i.bak 's!\(/host=master/core-service=management/management-interface=native-interface\)!#\1!g' ${JBOSS_HOME}/docs/examples/enable-elytron.cli
  ISOK

  echo -n "Enable elytron ............................. "
  ${JBOSS_HOME}/bin/jboss-cli.sh \
    --file=${JBOSS_HOME}/docs/examples/enable-elytron.cli &> /dev/null
  ISOK

  echo -n "Override java.security policy file ......... "
  if [[ -z "$(grep java.security.properties ${JBOSS_HOME}/bin/standalone.conf | grep -v '^#')" ]]
  then
    echo "JAVA_OPTS=\"\$JAVA_OPTS -Djava.security.properties=${JBOSS_HOME}/../java.security.properties\"" >> ${JBOSS_HOME}/bin/standalone.conf
  fi
  ISOK
 
  echo
POPD

