#!/bin/bash

BASE_URL="http://localhost:8000/api/client"

echo "=== CREATE CLIENT ==="
CREATE_RESPONSE=$(curl -s -X POST $BASE_URL \
-H "Content-Type: application/json" \
-d '{"name":"Jan Kowalski","email":"jan@example.com"}')
echo $CREATE_RESPONSE
echo

ID=$(echo $CREATE_RESPONSE | grep -o '"id":[0-9]*' | grep -o '[0-9]*')
echo "Created Client ID: $ID"
echo

echo "=== GET ALL CLIENTS ==="
curl -s $BASE_URL
echo
echo

echo "=== GET ONE CLIENT ==="
curl -s $BASE_URL/$ID
echo
echo

echo "=== UPDATE CLIENT ==="
curl -s -X PUT $BASE_URL/$ID \
-H "Content-Type: application/json" \
-d '{"name":"Jan Nowak","email":"jan.nowak@example.com"}'
echo
echo

echo "=== DELETE CLIENT ==="
curl -s -X DELETE $BASE_URL/$ID
echo
echo

echo "=== GET AFTER DELETE ==="
curl -s $BASE_URL/$ID
echo

