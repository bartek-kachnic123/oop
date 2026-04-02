#!/bin/bash

CLIENT_URL="http://localhost:8000/api/client"
PRODUCT_URL="http://localhost:8000/api/product"
ORDER_URL="http://localhost:8000/api/order"

# --- CREATE CLIENT ---
CREATE_CLIENT=$(curl -s -X POST $CLIENT_URL \
-H "Content-Type: application/json" \
-d '{"name":"Jan Kowalski","email":"jan@example.com"}')
echo $CREATE_CLIENT
CLIENT_ID=$(echo $CREATE_CLIENT | grep -o '"id":[0-9]*' | grep -o '[0-9]*')
echo "Created Client ID: $CLIENT_ID"
echo

# --- CREATE PRODUCTS ---
CREATE_PRODUCT1=$(curl -s -X POST $PRODUCT_URL \
-H "Content-Type: application/json" \
-d '{"name":"Laptop","price":3999.99,"description":"Gaming laptop"}')
PRODUCT1_ID=$(echo $CREATE_PRODUCT1 | grep -o '"id":[0-9]*' | grep -o '[0-9]*')

CREATE_PRODUCT2=$(curl -s -X POST $PRODUCT_URL \
-H "Content-Type: application/json" \
-d '{"name":"Mouse","price":199.99,"description":"Wireless mouse"}')
PRODUCT2_ID=$(echo $CREATE_PRODUCT2 | grep -o '"id":[0-9]*' | grep -o '[0-9]*')

echo "Created Product IDs: $PRODUCT1_ID, $PRODUCT2_ID"
echo

# --- CREATE ORDER ---
CREATE_ORDER=$(curl -s -X POST $ORDER_URL \
-H "Content-Type: application/json" \
-d "{\"client_id\":$CLIENT_ID,\"products\":[$PRODUCT1_ID,$PRODUCT2_ID]}")
echo $CREATE_ORDER
ORDER_ID=$(echo $CREATE_ORDER | grep -o '"id":[0-9]*' | head -n1 | grep -o '[0-9]*')
echo "Created Order ID: $ORDER_ID"
echo

# --- GET ALL ORDERS ---
echo "=== GET ALL ORDERS ==="
curl -s $ORDER_URL
echo
echo

echo
echo $ORDER_ID
echo

# --- GET ONE ORDER ---
echo "=== GET ONE ORDER ==="
curl -s $ORDER_URL/$ORDER_ID
echo
echo

# --- UPDATE ORDER ---
echo "=== UPDATE ORDER ==="
curl -s -X PUT $ORDER_URL/$ORDER_ID \
-H "Content-Type: application/json" \
-d "{\"products\":[$PRODUCT2_ID]}"
echo
echo

# --- DELETE ORDER ---
echo "=== DELETE ORDER ==="
curl -s -X DELETE $ORDER_URL/$ORDER_ID
echo
echo

# --- GET AFTER DELETE ---
echo "=== GET AFTER DELETE ==="
curl -s $ORDER_URL/$ORDER_ID
echo

