#!/bin/bash

FILE="main"
TEST_FILE="test_utils"

docker pull kprzystalski/projobj-pascal:latest

docker run --rm -it -v "$(pwd)":/home/student/projobj/ kprzystalski/projobj-pascal:latest /bin/bash -c "\
  fpc $FILE.pas && ./$FILE && \
  fpc $TEST_FILE.pas && ./$TEST_FILE"

