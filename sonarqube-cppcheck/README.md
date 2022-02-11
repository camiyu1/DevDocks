SonarQube Docker Image

## Prerequisite

- Docker

## To build a container image

```sh
$ ./build.sh
```

## To execute a container

```sh
$ ./run.sh <c++ project directory>
```

## To use

### Run SonarQube Server
```sh
$ sonar.sh start

# To check if it run correctly
$ sonar.sh status

# To stop SonarQube Server
$ sonar.sh stop

# If you want to see console messages
$ sonar.sh console

```

Connect to http://localhost:9000, and change the initial credential for SonarQube(admin/admin).

### Run a code quality analysis

**[Basic Setting (SonarQube)]**

First you have to create project in SonarQube web server (http://localhost:9000). You will receive project token that will be used later.

**[Basic Setting (Container)]**

You have to copy `/workspace/sonar-project.properties` to `/workspace/src/` (it mounts the source directory given as an argument of `run.sh`)

You can generate from a project root directory
```sh
$ cppcheck -v --enable=all --xml-version=2 . 2> cppcheck.xml
```
**[Code Coverage Report (optional)]**

To make coverage report

1) Add the compile flag "-g -O0 -fprofile-arcs -ftest-coverage"
   ex. set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage")

2) Run test codes
3) After running test code, *.gcda will be generated in a build directory
4) Finally, gcovr report can be generated from project root directory
   ```sh
   gcovr -r ./ --xml-pretty --object-directory=. >  gcovr.xml
   ```

**[Upload the result to the sonarqube server]**

```sh
$ sonar-scanner \
  -Dsonar.projectKey=<Project Name> \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=<Project Token>