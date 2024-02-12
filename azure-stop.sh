#!/bin/bash

source ./stop.sh

terraform -chdir=terraform/ destroy -auto-approve
