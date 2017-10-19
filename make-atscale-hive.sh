#!/bin/bash

help() {
  echo "Usage: $0 [--docker-local] [--build-version build_version]"
  echo "--docker-local: run within docker, useful for testing dockery things on the commandline locally"
  echo "--build-version: value that gets pushed into all pom.xml before building, ex: 1.2.3-AS45-branch-67"
}

while [ $# -gt 0 ]; do
  case "$1" in
    --build-version)
      AS_BUILD_VERSION="$2"
      BV_FLAG="--build-version $AS_BUILD_VERSION"
      shift 2
      ;;
    --docker-local)
      RESTART_IN_DOCKER=1
      shift 1
      ;;
    -h)
      help
      exit
      ;;
    *)
      echo "ERROR - '$1' is not a supported argument"
      help
      exit 1
      ;;
  esac
done

if [ ! -z "$RESTART_IN_DOCKER" ]; then
  docker build -t local-build-hive .
  docker run -v ${PWD}:/build -v ${PWD}/.m2:/root/.m2 -i -t local-build-hive /bin/bash -c "cd /build; /bin/bash make-atscale-hive.sh $BV_FLAG"
  exit
fi

if [ ! -z "$AS_BUILD_VERSION" ]; then
  echo "Assigning build version ${AS_BUILD_VERSION}"
  mvn versions:set -DnewVersion=${AS_BUILD_VERSION}
fi

HOME=/tmp

mvn clean package -DskipTests -Phadoop-2 -Pdist
