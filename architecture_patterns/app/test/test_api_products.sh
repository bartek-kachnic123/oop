#!/bin/bash

BASE_URL="http://localhost:8000/api/products"

echo "=== CREATE ==="
CREATE_RESPONSE=$(curl -s -X POST $BASE_URL \
-H "Content-Type: application/json" \
-d '{"name":"Laptop","price":3999.99,"description":"Gaming laptop"}')

echo $CREATE_RESPONSE
echo

ID=$(echo $CREATE_RESPONSE | grep -o '"id":[0-9]*' | grep -o '[0-9]*')

echo "Created ID: $ID"
echo

echo "=== GET ALL ==="
curl -s $BASE_URL
echo
echo

echo "=== GET ONE ==="
curl -s $BASE_URL/$ID
echo
echo

echo "=== UPDATE ==="
curl -s -X PUT $BASE_URL/$ID \
-H "Content-Type: application/json" \
-d '{"name":"Laptop 2","price":3499.99,"description":"Updated version"}'
echo
echo

echo "=== DELETE ==="
curl -s -X DELETE $BASE_URL/$ID
echo
echo

echo "=== GET AFTER DELETE ==="
curl -s $BASE_URL/$ID
echo
