#!/bin/bash

CLEAN_BUILD=false
SKIP_TESTS=true
DOCKER_TAG=1.3
DOCKER_PUSH=false

# Exit immediately if a command returns an error code
set -e

echo -e "Building T2-Project\n-------------------"

# set dir
dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
T2_DIR=$dir/../../microservices
echo -e "\nWorking directory: $T2_DIR"

# compile projects
declare -a projects=("common" "cart" "creditinstitute" "inventory" "orchestrator" "order" "payment" "ui" "uibackend" "e2e-tests")
for project in "${projects[@]}"
do
    echo -e "\nBuild & Install '$project'\n"
    cd $T2_DIR/$project
    if [ "$CLEAN_BUILD" = true ] ; then
        ./mvnw clean
    fi
    if [ "$SKIP_TESTS" != true ] ; then
        ./mvnw install
    else
        ./mvnw install -DskipTests
    fi

    # Docker build everything, except 'common' and 'e2e-tests'
    if [ "$project" != 'common' ] && [ "$project" != 'e2e-tests' ] ; then
        docker build -t t2project/$project:$DOCKER_TAG .
        if [ "$DOCKER_PUSH" = "true" ] ; then
            docker push t2project/$project:$DOCKER_TAG
        fi
    fi

    # Build e2e-tests with different name
    if [ "$project" = 'e2e-tests' ] ; then
        docker build -t t2project/e2etest:$DOCKER_TAG .
        if [ "$DOCKER_PUSH" = "true" ] ; then
            docker push t2project/e2etest:$DOCKER_TAG
        fi
    fi
done
