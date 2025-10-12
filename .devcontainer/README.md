# Dev Container Configuration

This directory contains the development container configuration for Photoshot.

## What is a Dev Container?

Dev Containers allow you to use a Docker container as a full-featured development environment. This ensures all developers have a consistent development environment with all required dependencies pre-installed.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for VS Code

## Getting Started

1. Open this project in VS Code
2. When prompted, click "Reopen in Container" (or use Command Palette: `Dev Containers: Reopen in Container`)
3. VS Code will build the dev container and install all dependencies
4. Once ready, the dev container includes:
   - Node.js 18
   - Yarn package manager
   - PostgreSQL database (accessible at localhost:5432)
   - Maildev server for email testing (Web UI at http://localhost:1080)
   - All VS Code extensions for Next.js, TypeScript, Prisma, and ESLint

## Environment Variables

After the container is created, you'll need to configure your environment variables:

1. A `.env.local` file is automatically created from `.env.example`
2. Edit `.env.local` and fill in the required values:
   - API keys for Replicate, Stripe, OpenAI
   - S3 bucket credentials
   - Other configuration as needed

See the main [README.md](../README.md) for detailed information about each environment variable.

## Running the Application

The dev container pre-configures the PostgreSQL database connection. To start developing:

1. Run database migrations:
   ```bash
   yarn prisma:migrate:dev
   ```

2. Start the development server:
   ```bash
   yarn dev
   ```

3. Open http://localhost:3000 in your browser

## Included Services

- **PostgreSQL**: Database server on port 5432
  - Username: `photoshot`
  - Password: `photoshot`
  - Database: `photoshot`
- **Maildev**: Email testing server
  - Web UI: http://localhost:1080
  - SMTP: localhost:25

## VS Code Extensions

The following extensions are automatically installed:

- ESLint - Code linting
- Prettier - Code formatting
- Prisma - Database schema support
- Docker - Container management
- GitLens - Git integration

## Troubleshooting

### Container won't start
- Ensure Docker Desktop is running
- Try rebuilding the container: Command Palette → `Dev Containers: Rebuild Container`

### Database connection issues
- The database URL is pre-configured to `postgresql://photoshot:photoshot@localhost:5432/photoshot`
- Ensure the PostgreSQL service is running in docker-compose

### Port conflicts
- If ports 3000, 5432, 1080, or 25 are already in use, you'll need to stop other services or modify the port mappings in `docker-compose.yml`
