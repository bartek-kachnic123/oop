#!/bin/bash

BASE_URL="http://localhost:8080/products"

echo "=============================="
echo "CREATE PRODUCT"
echo "=============================="

CREATE_RESPONSE=$(curl -s -X POST $BASE_URL \
-H "Content-Type: application/json" \
-d '{"name":"Xbox","price":1999.99}')

echo "$CREATE_RESPONSE"

PRODUCT_ID=$(echo $CREATE_RESPONSE | grep -oP '"id":"\K[^"]+')

echo ""
echo "Created product ID:"
echo "$PRODUCT_ID"

echo ""
echo "=============================="
echo "GET ALL PRODUCTS"
echo "=============================="

curl -s $BASE_URL
echo ""

echo ""
echo "=============================="
echo "GET SINGLE PRODUCT"
echo "=============================="

curl -s "$BASE_URL/$PRODUCT_ID"
echo ""

echo ""
echo "=============================="
echo "UPDATE PRODUCT"
echo "=============================="

curl -s -X PUT "$BASE_URL/$PRODUCT_ID" \
-H "Content-Type: application/json" \
-d '{"name":"Gaming Laptop","price":4999.99}'

echo ""

echo ""
echo "=============================="
echo "GET UPDATED PRODUCT"
echo "=============================="

curl -s "$BASE_URL/$PRODUCT_ID"
echo ""

echo ""
echo "=============================="
echo "DELETE PRODUCT"
echo "=============================="

curl -s -X DELETE "$BASE_URL/$PRODUCT_ID"
echo ""

echo ""
echo "=============================="
echo "GET ALL AFTER DELETE"
echo "=============================="

curl -s $BASE_URL
echo ""

echo ""
echo "CRUD TEST FINISHED"

