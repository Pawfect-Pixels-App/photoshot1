#!/bin/bash

# Photoshot Deployment Script
# This script automates the deployment process for self-hosted environments

set -e  # Exit on error

echo "=========================================="
echo "Photoshot Deployment Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env.local exists
if [ ! -f .env.local ]; then
    echo -e "${RED}Error: .env.local file not found${NC}"
    echo "Please create .env.local file with required environment variables"
    echo "You can copy .env.example: cp .env.example .env.local"
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${RED}Error: Node.js version must be 18 or higher${NC}"
    echo "Current version: $(node -v)"
    exit 1
fi

echo -e "${GREEN}✓ Node.js version check passed${NC}"

# Install dependencies
echo ""
echo "Installing dependencies..."
yarn install --frozen-lockfile
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Generate Prisma Client
echo ""
echo "Generating Prisma Client..."
yarn prisma:generate
echo -e "${GREEN}✓ Prisma Client generated${NC}"

# Run database migrations
echo ""
echo "Running database migrations..."
yarn prisma:migrate:deploy
echo -e "${GREEN}✓ Database migrations completed${NC}"

# Build application
echo ""
echo "Building application..."
yarn build
echo -e "${GREEN}✓ Application built successfully${NC}"

echo ""
echo "=========================================="
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo "=========================================="
echo ""
echo "To start the application:"
echo "  yarn start"
echo ""
echo "Or with PM2:"
echo "  pm2 start yarn --name photoshot -- start"
echo "  pm2 save"
echo ""
