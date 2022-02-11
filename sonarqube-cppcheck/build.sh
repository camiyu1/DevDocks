#!/usr/bin/env bash
#
# Author: Yong Hak Lee (camiyu1@gmail.com)
# Date: Feb. 11, 2022

function print_title() {
  echo "======================================================"
  echo $1
  echo "======================================================"
}

function download() {
  wget -O $1 $2
  if [ $? -ne 0 ]; then
    echo "Download failed"; exit 1
  fi
}

arg_help=0
arg_tag="camiyu1/sonarqube"
arg_down=1

while [[ $# -gt 0 ]]; do case $1 in
  -h|--help) arg_help=1;;
  --no-down) arg_down=0;;
  --tag) arg_tag="$2"; shift;;
  *) echo "Unknown parameter: $1"; echo "$0 --help"; exit 1;
esac; shift; done

if [ $arg_help -eq 1 ]; then
  echo "Usage: $0 [options]"
  echo " --help or -h         : Print this help menu."
  echo " --tag    <imagename> : Image name for the built container"
  echo " --no-down            : Build without downloading sonarqube, sonarscanner (not recommend)"
  exit 1;
fi

sonar_version="8.9.7.52159"
scanner_version="4.6.2.2472"
sonar_url="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${sonar_version}.zip"
scanner_url="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${scanner_version}-linux.zip"

if [ $arg_down -eq 1 ]; then
  print_title "Download SonarQube community edition : ${sonar_version}"
  download sonarqube.zip ${sonar_url}

  print_title "Download SonarScanner : ${scanner_version}"
  download scanner.zip ${scanner_url}
fi

print_title "Docker Buiding.... :
             docker build -f ubuntu-20.04-sonarqube.Dockerfile -t ${arg_tag} ."

docker build -f ubuntu-20.04-sonarqube.Dockerfile -t ${arg_tag} .

if [ $? -eq 0 ]; then
  print_title "Built successfully!"
else
  print_title "Build failed..."
fi
