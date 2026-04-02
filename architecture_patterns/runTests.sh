#!/bin/bash

BASE_URL="http://localhost:8000"

docker pull kprzystalski/projobj-php:latest

CONTAINER_ID=$(docker run -d -p 8000:8000 \
    -v $(pwd)/app:/home/student/projobj \
    kprzystalski/projobj-php:latest \
    sh -c "composer install && php -S 0.0.0.0:8000 -t public")

echo "Waiting for server to start..."

until curl -s $BASE_URL >/dev/null; do
    sleep 1
done

echo "Server started"
./app/test/test_api_products.sh

docker stop $CONTAINER_ID
docker rm $CONTAINER_ID

