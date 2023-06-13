#!/bin/bash

mkdir -p dist
mkdir -p assets

# Debian platform
platform="debian10" ../build_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

platform="debian11" ../build_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

platform="debian12" ../build_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi
