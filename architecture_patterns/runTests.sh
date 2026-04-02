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
echo "test product api" && ./app/test/test_product_api.sh
echo "test client api" && ./app/test/test_client_api.sh
echo "test order api" && ./app/test/test_order_api.sh

docker stop $CONTAINER_ID
docker rm $CONTAINER_ID

