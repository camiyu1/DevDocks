ARG OS_VERSION=20.04

FROM ubuntu:${OS_VERSION}
LABEL maintainer="camiyu1@gmail.com"
SHELL ["/bin/bash", "-c"]

# without user prompts
ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=camiyu1

# User Add
RUN useradd -m -s /bin/bash ${USERNAME}
RUN usermod -aG sudo ${USERNAME}

# Install necessary packages
RUN apt-get update
RUN apt-get install -y sudo \
    python3-pip \
    unzip \
    git \
    wget \
    default-jre

# Install SonarQube, SonarScanner, CppCheck, Gcovr
RUN mkdir /workspace/
RUN pip3 install --upgrade pip

# cppcheck: Code quality
RUN apt-get install -y cppcheck
# gcovr: Code coverage
RUN pip3 install gcovr==5.0

COPY sonarqube.zip /workspace/
COPY scanner.zip /workspace/
COPY sonar-project.properties /workspace/

ARG SONAR_CXX_PLUGIN=sonar-cxx-plugin-2.0.6.2925.jar
ARG SONAR_CXX_PLUGIN_URL=https://github.com/SonarOpenCommunity/sonar-cxx/releases/download/cxx-2.0.6/${SONAR_CXX_PLUGIN}
ARG SONAR_VER=8.9.7.52159
ARG SCANNER_VER=4.6.2.2472

RUN cd /workspace && \
    unzip sonarqube.zip && \
    unzip scanner.zip && \
    wget -O ${SONAR_CXX_PLUGIN} ${SONAR_CXX_PLUGIN_URL} && \
    mv ${SONAR_CXX_PLUGIN} sonarqube*/extensions/plugins/ && \
    rm sonarqube.zip scanner.zip

RUN chown -R camiyu1 /workspace/

WORKDIR /workspace/

ENV PATH=${PATH}:/workspace/sonarqube-${SONAR_VER}/bin/linux-x86-64:/workspace/sonar-scanner-${SCANNER_VER}-linux/bin

# Run SonarQube and /bin/bash as a username
USER ${USERNAME}
RUN ["/bin/bash"]
