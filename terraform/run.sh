#!/bin/bash

# Usage:
# run.sh {environment} {command}
# 
# Examples:
# run.sh aws init
# run.sh aws plan
# run.sh aws apply

TF_ENV=$1

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Always run from the location of this script
cd $MY_DIR

if [ $# -gt 0 ]; then
    shift # Shift arguments -> Use all arguments except first one
    terraform -chdir=./environments/$TF_ENV $@
fi
