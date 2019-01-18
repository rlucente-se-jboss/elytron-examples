#!/usr/bin/env bash

. $(dirname $0)/../demo.conf

PUSHD ${WORK_DIR}
  rm -fr java.security.properties wildfly-${VER_INST_EAP} *.bcfks
POPD

