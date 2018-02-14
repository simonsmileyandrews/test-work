#!/bin/sh

##################################################################
#
# local-docker-build.sh [BUILD_TYPE] [--stacktrace | --debug]
#
# @params: BUILD_TYPE
#          Valid values: ciDev (default), ciOmqa, ciDrop
#
# @author: Branko Minic
#
# This script contains commands to run a gradle build. This script should ONLY be run from within a
# Docker container.
#
# This script will change directory to the workspace (this should be the project's root directory),
# before temporarily renaming the local.properties file (Android Studio specific file), and then
# actually calling the gradle build.
#
# In addition, more details for the build can be obtained by adding either --stacktrace or --debug
# to the parameter list.
#
# To execute the script in Docker, execute the following command from the Terminal, ensuring that
# the <path-to-local-project> is configured for your dev environment.
#
# docker run -v <path-to-local-project-workspace>:/workspace registry.omdev.io:443/<docker-image-name> bash /workspace/local-docker-build.sh [BUILD_TYPE]
#
###################################################################

BUILD_TYPE=${1:-ciDev}

cd /workspace

if [ -f local.properties ]; then
    echo "Renaming local.properties -> _local.properties"
    mv local.properties _local.properties
else
    echo "local.properties doesn't exist - nothing to do!"
fi

echo "**************************************************************"
echo "***                                                        ***"
echo "***                  GRADLE BUILD STARTED                  ***"
echo "***                                                        ***"
echo "**************************************************************"
echo
echo ./gradlew $BUILD_TYPE ${2}
./gradlew $BUILD_TYPE ${2} || EXIT_CODE=$?

echo "**************************************************************"
echo "***                                                        ***"
echo "***                 GRADLE BUILD FINISHED                  ***"
echo "***                                                        ***"
echo "**************************************************************"

if [ -f _local.properties ]; then
    echo "Reverting _local.properties -> local.properties"
    mv _local.properties local.properties
else
    echo "_local.properties doesn't exist - nothing to do!"
fi

if [[ ! -z "${EXIT_CODE}" ]]; then
  echo "Gradle build failed with exit code ${EXIT_CODE}"
  exit "${EXIT_CODE}"
fi

