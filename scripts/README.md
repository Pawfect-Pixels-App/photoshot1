# Deployment Scripts

Utility scripts for deploying and managing Photoshot.

## Scripts

### Vercel Deployment Scripts

#### setup-vercel-secrets.sh

Automated script to create all required Vercel secrets for deployment.

**Usage:**
```bash
./scripts/setup-vercel-secrets.sh
```

**What it does:**
- Guides you through creating all required Vercel secrets
- Prompts for values for each secret
- Provides examples and descriptions for each secret
- Runs `vercel secrets add` for each secret

**Prerequisites:**
- Vercel CLI installed (`npm i -g vercel`)
- Logged in to Vercel (`vercel login`)
- Project linked to Vercel (`vercel link`)

**See also:** [VERCEL_SETUP.md](../VERCEL_SETUP.md) for detailed deployment guide

#### check-vercel-setup.sh

Diagnostic script to check if your Vercel project is properly configured.

**Usage:**
```bash
./scripts/check-vercel-setup.sh
```

**What it does:**
- Checks if Vercel CLI is installed
- Verifies you're logged in
- Confirms project is linked
- Lists which secrets are missing
- Provides next steps to fix issues

**Use this when:**
- Getting "Secret does not exist" errors
- Want to verify setup before deploying
- Troubleshooting deployment issues

---

### deploy.sh

Automated deployment script for self-hosted environments.

**Usage:**
```bash
./scripts/deploy.sh
```

**What it does:**
1. Checks Node.js version (18+)
2. Verifies .env.local exists
3. Installs dependencies
4. Generates Prisma Client
5. Runs database migrations
6. Builds the application

**Requirements:**
- Node.js 18+
- Yarn package manager
- .env.local file with environment variables
- Database connection configured

### health-check.sh

Health check script to verify the application is running correctly.

**Usage:**
```bash
# Check local instance
./scripts/health-check.sh

# Check remote instance
HOST=your-domain.com PORT=443 ./scripts/health-check.sh

# With custom endpoint
HOST=localhost PORT=3000 HEALTH_ENDPOINT=/api/health ./scripts/health-check.sh
```

**Environment Variables:**
- `HOST` - Hostname to check (default: localhost)
- `PORT` - Port to check (default: 3000)
- `HEALTH_ENDPOINT` - Health endpoint path (default: /api/health)
- `TIMEOUT` - Request timeout in seconds (default: 10)

**Exit Codes:**
- `0` - Healthy
- `1` - Unhealthy or unreachable

## Integration with CI/CD

### GitHub Actions

```yaml
- name: Deploy
  run: ./scripts/deploy.sh

- name: Health Check
  run: ./scripts/health-check.sh
```

### Cron Job (Monitoring)

```bash
# Check health every 5 minutes
*/5 * * * * /path/to/photoshot/scripts/health-check.sh || echo "Photoshot is down!" | mail -s "Alert" admin@example.com
```

### Docker

```dockerfile
# In your Dockerfile
COPY scripts/health-check.sh /app/scripts/
RUN chmod +x /app/scripts/health-check.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD /app/scripts/health-check.sh || exit 1
```

## Custom Scripts

Feel free to add your own deployment scripts:

- `scripts/backup.sh` - Database backup
- `scripts/restore.sh` - Database restore
- `scripts/migrate.sh` - Run migrations only
- `scripts/rollback.sh` - Rollback to previous version

## Troubleshooting

### Vercel "Secret does not exist" error

Run the diagnostic script:
```bash
./scripts/check-vercel-setup.sh
```

Then create missing secrets:
```bash
./scripts/setup-vercel-secrets.sh
```

See [VERCEL_SETUP.md](../VERCEL_SETUP.md) for detailed help.

### "Permission denied" error

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

### "yarn: command not found"

Install yarn:
```bash
npm install -g yarn
```

### Health check fails

1. Ensure application is running
2. Check PORT matches your configuration
3. Verify health endpoint is accessible
4. Check firewall settings

## Quick Reference

**First time deploying to Vercel?**
```bash
# 1. Install and setup Vercel CLI
npm i -g vercel
vercel login
vercel link

# 2. Check what's missing
./scripts/check-vercel-setup.sh

# 3. Create secrets
./scripts/setup-vercel-secrets.sh

# 4. Deploy
vercel --prod
```

**Self-hosted deployment?**
```bash
./scripts/deploy.sh
```

**Check if app is healthy?**
```bash
./scripts/health-check.sh
```
