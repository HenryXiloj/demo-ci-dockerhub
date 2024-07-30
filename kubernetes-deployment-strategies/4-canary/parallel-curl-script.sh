#!/bin/bash

# Function to make a single request
make_request() {
    echo "Request $1"
    response=$(curl -s "http://localhost:8080/green")
    echo "Response $1: $response"
    sleep 0.1  # Adds a 100ms delay after each request
}

# Run 1000 requests in parallel
export -f make_request
seq 1 1000 | xargs -P 0 -I {} bash -c 'make_request "$@"' _ {}

echo "All requests completed"