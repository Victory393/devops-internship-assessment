#!/bin/bash

# 1. Start a background Python web server on port 8000 using our web directory
echo "Starting local web server..."
python3 -m http.server 8000 --directory website &
SERVER_PID=$!

# Wait 2 seconds for the server to spin up safely
sleep 2

# 2. Ping the server and grab the HTTP status code
echo "Testing web server health status..."
STATUS_CODE=$(curl -o /dev/null -s -w "%{http_code}" http://localhost:8000/)

# 3. Stop the web server safely using its Process ID (PID)
echo "Stopping web server (PID: $SERVER_PID)..."
kill $SERVER_PID

# 4. Evaluate the status code condition
echo "----------------------------------------"
if [ "$STATUS_CODE" -eq 200 ]; then
    echo "SUCCESS: Web server is up and healthy! (Status: $STATUS_CODE)"
    exit 0
else
    echo "CRITICAL FAILURE: Web server returned status code: $STATUS_CODE"
    exit 1
fi
