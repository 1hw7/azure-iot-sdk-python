#!/bin/bash
# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

# This script updates a fresh Ubuntu installation with all the dependent
# components necessary to use the IoT Client SDK for C and Python.

build_root=$(cd "$(dirname "$0")/../.." && pwd)
cd $build_root

PYTHON_VERSION=2.7

process_args()
{
    save_next_arg=0
    
    for arg in $*
    do
      if [ $save_next_arg == 1 ]
      then
        PYTHON_VERSION="$arg"
        if [ $PYTHON_VERSION != "2.7" ] && [ $PYTHON_VERSION != "3.4" ] && [ $PYTHON_VERSION != "3.5" ] && [ $PYTHON_VERSION != "3.6" ]
        then
          echo "Supported python versions are 2.7, 3.4 or 3.5"
          exit 1
        fi 
        save_next_arg=0
      else
        case "$arg" in
          "--build-python" ) save_next_arg=1;;
          * ) ;;
        esac
      fi
    done
}

process_args $*

# instruct C setup to install all dependent libraries
./c/build_all/mac/setup.sh
[ $? -eq 0 ] || exit $?

scriptdir=$(cd "$(dirname "$0")" && pwd)

if [ $PYTHON_VERSION == "3.4" ] || [ $PYTHON_VERSION == "3.5" ] || [ $PYTHON_VERSION == "3.6" ]
then
	deps="boost-python --with-python3"
else
	deps="boost-python"
fi 

deps_install ()
{
	brew install $deps
}

deps_install

