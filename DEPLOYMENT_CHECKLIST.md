# Deployment Checklist

Use this checklist to ensure a successful deployment of Photoshot.

## Pre-Deployment

### 1. Environment Setup
- [ ] PostgreSQL database provisioned
- [ ] AWS S3 bucket created with appropriate permissions
- [ ] Replicate account created and API token obtained
- [ ] All required environment variables documented
- [ ] `.env.local` or platform environment variables configured

### 2. Database Configuration
- [ ] Database connection string tested
- [ ] Database user has CREATE, DROP, ALTER permissions (for migrations)
- [ ] Connection pooling configured (if using serverless)
- [ ] Database backups configured

### 3. Storage Configuration (S3)
- [ ] S3 bucket created in desired region
- [ ] IAM user created with programmatic access
- [ ] IAM policy attached with `s3:PutObject`, `s3:GetObject`, `s3:DeleteObject` permissions
- [ ] Bucket CORS configured if needed
- [ ] Access keys documented securely

### 4. AI/ML Configuration (Replicate)
- [ ] Replicate account verified
- [ ] API token generated and saved
- [ ] Account has sufficient credits
- [ ] Username verified (matches REPLICATE_USERNAME)
- [ ] Instance token chosen (3-character identifier)

### 5. Optional Services
- [ ] Stripe account setup (if monetizing)
- [ ] SMTP server configured (for email auth)
- [ ] OpenAI API key obtained (for prompt wizard)

## Deployment

### Vercel Deployment
- [ ] Repository connected to Vercel
- [ ] Environment variables added in Vercel dashboard
- [ ] Build settings verified (uses `vercel-build` script)
- [ ] Domain configured (if custom domain)
- [ ] `NEXTAUTH_URL` set to deployment URL
- [ ] Deployment successful
- [ ] Logs checked for errors

### Docker Deployment
- [ ] Dockerfile tested locally
- [ ] `.env.local` file created and populated
- [ ] `docker-compose.prod.yml` configured
- [ ] Docker image builds successfully
- [ ] Container runs without errors
- [ ] Database migrations run successfully
- [ ] Health check endpoint responds

### Railway Deployment
- [ ] Project created in Railway
- [ ] PostgreSQL service provisioned
- [ ] Repository connected
- [ ] Environment variables configured
- [ ] Build and deploy successful
- [ ] Domain assigned

### Render Deployment
- [ ] Web service created
- [ ] PostgreSQL database provisioned
- [ ] `render.yaml` configuration verified
- [ ] Environment variables set
- [ ] Build command configured
- [ ] Start command configured
- [ ] Health check path set to `/api/health`
- [ ] Deployment successful

### Self-Hosted (VPS) Deployment
- [ ] Server provisioned (minimum 2GB RAM recommended)
- [ ] Node.js 18+ installed
- [ ] PostgreSQL 14+ installed or accessible
- [ ] PM2 or process manager installed
- [ ] Repository cloned
- [ ] Dependencies installed
- [ ] Environment variables configured
- [ ] Database migrations run
- [ ] Application built successfully
- [ ] Application started with process manager
- [ ] Reverse proxy configured (Nginx/Caddy)
- [ ] SSL certificate installed
- [ ] Firewall configured
- [ ] Auto-start on boot configured

## Post-Deployment

### Verification
- [ ] Application loads in browser
- [ ] Health check endpoint returns 200: `GET /api/health`
- [ ] Login page accessible
- [ ] Email authentication works (if configured)
- [ ] Image upload to S3 works
- [ ] Replicate integration tested
- [ ] Payment flow works (if Stripe configured)
- [ ] No console errors in browser
- [ ] No server errors in logs

### Security
- [ ] HTTPS enabled (SSL certificate)
- [ ] Environment variables secured (not in code)
- [ ] Database has restricted access (not public)
- [ ] S3 bucket permissions reviewed
- [ ] API keys rotated from defaults
- [ ] Strong SECRET value set
- [ ] CORS configured appropriately
- [ ] Rate limiting considered

### Monitoring & Maintenance
- [ ] Error tracking configured (Sentry recommended)
- [ ] Uptime monitoring set up
- [ ] Log aggregation configured
- [ ] Database backup schedule verified
- [ ] S3 bucket lifecycle policies set
- [ ] Cost monitoring alerts configured
- [ ] Performance monitoring enabled

### Documentation
- [ ] Deployment process documented for team
- [ ] Environment variables documented
- [ ] Rollback procedure documented
- [ ] Access credentials stored securely
- [ ] Contact information for services documented

## Testing Checklist

### Functional Testing
- [ ] User registration works
- [ ] Email login works
- [ ] Studio creation works
- [ ] Image upload works
- [ ] Training starts successfully
- [ ] Training completion webhook works
- [ ] Shot generation works
- [ ] Bookmark functionality works
- [ ] Payment processing works (if applicable)
- [ ] Prompt wizard works (if OpenAI configured)

### Performance Testing
- [ ] Page load times acceptable (< 3s)
- [ ] Image loading optimized
- [ ] Database queries optimized
- [ ] Large image uploads work
- [ ] Multiple concurrent users tested

### Browser Testing
- [ ] Chrome/Edge tested
- [ ] Firefox tested
- [ ] Safari tested
- [ ] Mobile browsers tested
- [ ] Responsive design verified

## Troubleshooting

### Common Issues

**Build fails**
- Check all environment variables are set
- Verify Node.js version (18+)
- Check for missing dependencies
- Review build logs for specific errors

**Database connection fails**
- Verify DATABASE_URL format
- Check database is running
- Verify network access to database
- Check database user permissions

**S3 upload fails**
- Verify IAM credentials
- Check bucket name and region
- Review bucket permissions
- Check CORS configuration

**Replicate errors**
- Verify API token is valid
- Check account has credits
- Verify username is correct
- Review Replicate dashboard for errors

**Email not sending**
- Check SMTP server configuration
- Verify email credentials
- Check firewall allows SMTP port
- Review email service logs

## Rollback Plan

If deployment fails:

1. **Vercel**: Rollback to previous deployment in dashboard
2. **Docker**: Stop container, revert to previous image
3. **Railway**: Rollback in deployment history
4. **Render**: Rollback in deployment history
5. **Self-hosted**: Stop service, restore from backup, restart

## Support

- GitHub Issues: https://github.com/Pawfect-Pixels-App/photoshot1/issues
- Documentation: See DEPLOYMENT.md and QUICKSTART.md
- Community: Check existing discussions and issues

## Notes

- Always test in a staging environment first
- Keep backups before major changes
- Monitor logs after deployment
- Have a rollback plan ready
- Document any custom changes
