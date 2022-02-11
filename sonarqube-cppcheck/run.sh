#!/usr/bin/env bash

arg_help=0
arg_tag="camiyu1/sonarqube"
arg_workdir=``
arg_workdir_change=0

while [[ $# -gt 0 ]]; do case $1 in
  -h|--help) arg_help=1;;
  --tag) arg_tag="$2"; shift;;
  --workdir) arg_workdir="$2"; arg_workdir_change=1; shift;;
  *) echo "Unknown parameter: $1"; echo "$0 --help"; exit 1;
esac; shift; done

if [ $arg_help -eq 1 ] || [ $arg_workdir_change -eq 0 ]; then
  echo "Usage: $0 --workdir <directory> [tag <imagename>]"
  echo " --help or -h          : Print this help menu."
  echo " --workdir <directory> : Specify Workspace (Source Dir)"
  echo " --tag     <imagename> : Image name for the built container"
  exit 1;
fi

if [  ]; then
   echo ""
fi

# SonarQube port TCP/9000
docker run -it -p 9000:9000/tcp -v${arg_workdir}:/Workspace ${arg_tag}