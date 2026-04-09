#!/bin/bash
#
BASE_URL="http://localhost:8080/api"
USERNAME="magda1"
PASSWORD_GOOD="123"
PASSWORD_WRONG="1"

echo "=== GET /users ==="
curl -s "$BASE_URL/users"
echo -e "\n"

echo "=== POST /login (good credentials) ==="
curl -s -X POST "$BASE_URL/login" \
     -H "Content-Type: application/json" \
     -d "{\"username\": \"$USERNAME\", \"password\": \"$PASSWORD_GOOD\"}"
echo -e "\n"

echo "=== POST /login (wrong credentials) ==="
curl -s -X POST "$BASE_URL/login" \
     -H "Content-Type: application/json" \
     -d "{\"username\": \"$USERNAME\", \"password\": \"$PASSWORD_WRONG\"}"
echo -e "\n"

