#!/bin/bash

# Photoshot Health Check Script
# Checks if the application is healthy and running

set -e

# Configuration
HOST="${HOST:-localhost}"
PORT="${PORT:-3000}"
HEALTH_ENDPOINT="${HEALTH_ENDPOINT:-/api/health}"
TIMEOUT="${TIMEOUT:-10}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Checking Photoshot health..."
echo "Host: $HOST:$PORT"
echo "Endpoint: $HEALTH_ENDPOINT"
echo ""

# Check if application is responding
response=$(curl -s -o /dev/null -w "%{http_code}" --max-time $TIMEOUT "http://${HOST}:${PORT}${HEALTH_ENDPOINT}" 2>/dev/null || echo "000")

if [ "$response" = "200" ]; then
    echo -e "${GREEN}✓ Application is healthy${NC}"
    
    # Get detailed health info
    health_data=$(curl -s --max-time $TIMEOUT "http://${HOST}:${PORT}${HEALTH_ENDPOINT}" 2>/dev/null)
    echo ""
    echo "Health Details:"
    echo "$health_data" | jq '.' 2>/dev/null || echo "$health_data"
    exit 0
elif [ "$response" = "503" ]; then
    echo -e "${RED}✗ Application is unhealthy (Service Unavailable)${NC}"
    
    # Get error details
    health_data=$(curl -s --max-time $TIMEOUT "http://${HOST}:${PORT}${HEALTH_ENDPOINT}" 2>/dev/null)
    echo ""
    echo "Error Details:"
    echo "$health_data" | jq '.' 2>/dev/null || echo "$health_data"
    exit 1
elif [ "$response" = "000" ]; then
    echo -e "${RED}✗ Cannot connect to application${NC}"
    echo "Make sure the application is running on http://${HOST}:${PORT}"
    exit 1
else
    echo -e "${YELLOW}⚠ Unexpected response code: $response${NC}"
    exit 1
fi
