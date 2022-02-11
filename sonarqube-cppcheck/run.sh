#!/usr/bin/env bash

arg_help=0
arg_tag="camiyu1/sonarqube"
arg_workdir=`pwd`
arg_workdir_change=0

while [[ $# -gt 0 ]]; do case $1 in
  -h|--help) arg_help=1;;
  --tag) arg_tag="$2"; shift;;
  --workdir) arg_workdir="$2"; arg_workdir_change=1; shift;;
  *) echo "Unknown parameter: $1"; echo "$0 --help"; exit 1;
esac; shift; done

if [ $arg_help -eq 1 ]; then
  echo "Usage: $0 [options]"
  echo " --help or -h          : Print this help menu."
  echo " --tag     <imagename> : Image name for the built container"
  echo " --workdir <directory> : Specify directory (Generally Source Code Dir)"
fi

post="src"

# if [ $arg_workdir_change -eq 0 ]; then
#   post=`echo ${arg_workdir} | awk -F\/ '{print $NF}'`
# fi

# SonarQube port TCP/9000
docker run -it -p 9000:9000/tcp -v${arg_workdir}:/workspace/${post} ${arg_tag}