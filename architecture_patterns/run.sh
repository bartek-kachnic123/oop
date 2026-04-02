#!/bin/bash

docker pull kprzystalski/projobj-php:latest

docker run -it --rm -p 8000:8000 -v $(pwd)/app:/home/student/projobj \
    kprzystalski/projobj-php:latest sh -c "composer install && php -S 0.0.0.0:8000 -t public"

