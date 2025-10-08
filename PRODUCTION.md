# Production Deployment Best Practices

This document outlines best practices for deploying Photoshot to production.

## Architecture Overview

Photoshot consists of:
- **Next.js Application** - Web frontend and API routes
- **PostgreSQL Database** - User data, projects, shots
- **S3 Storage** - Image uploads and generated avatars
- **Replicate API** - AI model training and inference
- **SMTP Server** - Email authentication (optional)
- **Stripe** - Payment processing (optional)

## Recommended Production Stack

### Small Scale (< 1000 users)

**Platform**: Vercel  
**Database**: Neon or Supabase (Serverless PostgreSQL)  
**Storage**: AWS S3 or Cloudflare R2  
**Email**: SendGrid or Mailgun free tier  
**Cost**: ~$20-50/month

### Medium Scale (1000-10000 users)

**Platform**: Vercel Pro or Railway  
**Database**: Neon Scale or AWS RDS  
**Storage**: AWS S3 with CloudFront CDN  
**Email**: SendGrid or AWS SES  
**Monitoring**: Sentry, LogRocket  
**Cost**: ~$100-300/month

### Large Scale (> 10000 users)

**Platform**: Kubernetes (EKS, GKE, AKS) or custom infra  
**Database**: AWS RDS Multi-AZ or managed PostgreSQL  
**Storage**: AWS S3 with CloudFront CDN  
**Cache**: Redis for session/query caching  
**Email**: AWS SES or dedicated SMTP  
**Monitoring**: Datadog, New Relic, Sentry  
**Cost**: $500+/month

## Database Optimization

### Connection Pooling

For serverless deployments (Vercel, Railway), use connection pooling:

```env
# Neon
DATABASE_URL=postgres://user:pass@xxx.neon.tech/db?sslmode=require&pgbouncer=true

# Supabase (use session pooler)
DATABASE_URL=postgres://postgres.xxx:6543/postgres
```

### Indexes

Ensure these indexes exist for optimal performance:

```sql
-- Already in migrations, but verify:
CREATE INDEX idx_projects_user_id ON "Project"("userId");
CREATE INDEX idx_shots_project_id ON "Shot"("projectId");
CREATE INDEX idx_shots_status ON "Shot"("status");
CREATE INDEX idx_projects_model_status ON "Project"("modelStatus");
```

### Backup Strategy

- **Automated backups**: Enable on your database provider
- **Frequency**: Daily minimum, hourly for production
- **Retention**: 30 days minimum
- **Test restores**: Monthly

## Storage Optimization

### S3 Configuration

```json
{
  "Rules": [
    {
      "Id": "DeleteOldUploads",
      "Status": "Enabled",
      "Prefix": "uploads/",
      "Expiration": {
        "Days": 90
      }
    },
    {
      "Id": "TransitionToIA",
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "STANDARD_IA"
        }
      ]
    }
  ]
}
```

### CloudFront CDN

Add CloudFront in front of S3 for faster image delivery:

1. Create CloudFront distribution
2. Set S3 bucket as origin
3. Enable compression
4. Set cache TTL (1 day for avatars)
5. Update `next.config.js` image domains

## Security Hardening

### Environment Variables

Never commit secrets to git:

```bash
# Use secret management services
# Vercel: Built-in encrypted env vars
# AWS: Secrets Manager or Parameter Store
# Docker: Use secrets or external secret providers
```

### Database Security

```sql
-- Create read-only user for analytics
CREATE USER analytics_readonly WITH PASSWORD 'strong_password';
GRANT CONNECT ON DATABASE photoshot TO analytics_readonly;
GRANT USAGE ON SCHEMA public TO analytics_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analytics_readonly;
```

### API Rate Limiting

Add rate limiting to prevent abuse:

```typescript
// Example with Vercel KV (Redis)
import { Ratelimit } from "@upstash/ratelimit";
import { Redis } from "@upstash/redis";

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, "10 s"),
});

export async function middleware(request: Request) {
  const ip = request.headers.get("x-forwarded-for") ?? "127.0.0.1";
  const { success } = await ratelimit.limit(ip);
  
  if (!success) {
    return new Response("Too many requests", { status: 429 });
  }
}
```

### CORS Configuration

```typescript
// next.config.js
const nextConfig = {
  async headers() {
    return [
      {
        source: "/api/:path*",
        headers: [
          { key: "Access-Control-Allow-Credentials", value: "true" },
          { key: "Access-Control-Allow-Origin", value: process.env.ALLOWED_ORIGINS || "*" },
          { key: "Access-Control-Allow-Methods", value: "GET,POST,PUT,DELETE,OPTIONS" },
        ],
      },
    ];
  },
};
```

## Monitoring & Observability

### Health Checks

The `/api/health` endpoint is already configured. Monitor it with:

- **Uptime Robot** (free)
- **Better Uptime** (paid)
- **AWS Route 53 Health Checks**
- **Pingdom**

### Error Tracking

Integrate Sentry:

```bash
npm install @sentry/nextjs
```

```javascript
// sentry.config.js
Sentry.init({
  dsn: process.env.SENTRY_DSN,
  tracesSampleRate: 0.1,
  environment: process.env.NODE_ENV,
});
```

### Logging

Structured logging:

```typescript
// utils/logger.ts
export const logger = {
  info: (msg: string, meta?: object) => {
    console.log(JSON.stringify({ level: 'info', message: msg, ...meta, timestamp: new Date().toISOString() }));
  },
  error: (msg: string, error?: Error, meta?: object) => {
    console.error(JSON.stringify({ level: 'error', message: msg, error: error?.message, stack: error?.stack, ...meta, timestamp: new Date().toISOString() }));
  },
};
```

### Metrics

Key metrics to track:

- **Application**:
  - Request rate and latency
  - Error rate (4xx, 5xx)
  - Database query performance
  - API endpoint usage

- **Business**:
  - New user signups
  - Studio creation rate
  - Training completion rate
  - Payment conversion rate

- **Infrastructure**:
  - CPU and memory usage
  - Database connections
  - S3 storage usage
  - Replicate API costs

## Performance Optimization

### Next.js Configuration

```javascript
// next.config.js
const nextConfig = {
  // Already configured
  output: "standalone",
  
  // Add these
  compress: true,
  poweredByHeader: false,
  
  // Image optimization
  images: {
    formats: ['image/avif', 'image/webp'],
    minimumCacheTTL: 60,
    remotePatterns: [
      { protocol: "https", hostname: "replicate.delivery" },
      { protocol: "https", hostname: "your-cloudfront-domain.cloudfront.net" },
    ],
  },
  
  // Enable SWC minification
  swcMinify: true,
};
```

### Database Optimization

```typescript
// Use connection pooling
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient({
  datasources: {
    db: {
      url: process.env.DATABASE_URL,
    },
  },
  log: process.env.NODE_ENV === 'development' ? ['query', 'error'] : ['error'],
});

// Add query timeout
prisma.$use(async (params, next) => {
  const timeout = 5000; // 5 seconds
  const result = await Promise.race([
    next(params),
    new Promise((_, reject) => 
      setTimeout(() => reject(new Error('Query timeout')), timeout)
    ),
  ]);
  return result;
});
```

### Caching Strategy

```typescript
// Use Next.js built-in caching
export const revalidate = 3600; // 1 hour

// Or React Query for client-side
const { data } = useQuery('projects', fetchProjects, {
  staleTime: 5 * 60 * 1000, // 5 minutes
  cacheTime: 10 * 60 * 1000, // 10 minutes
});
```

## Scaling Strategies

### Horizontal Scaling

For high traffic, scale horizontally:

```yaml
# Kubernetes example
apiVersion: apps/v1
kind: Deployment
metadata:
  name: photoshot
spec:
  replicas: 3  # Multiple instances
  strategy:
    type: RollingUpdate
  template:
    spec:
      containers:
      - name: photoshot
        image: photoshot:latest
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "2000m"
```

### Database Scaling

- **Read replicas**: For read-heavy workloads
- **Vertical scaling**: Increase instance size
- **Connection pooling**: PgBouncer or built-in
- **Query optimization**: Regular EXPLAIN ANALYZE

### Storage Scaling

- **S3 is auto-scaling** - no action needed
- **Use CloudFront** - Reduce S3 API calls
- **Lifecycle policies** - Auto-archive old data
- **Multipart uploads** - For large files

## Cost Optimization

### Replicate Costs

- Monitor training costs per user
- Set credit limits per studio
- Optimize training parameters
- Cache model versions

### S3 Costs

- Use Intelligent-Tiering storage class
- Set lifecycle policies
- Enable S3 Transfer Acceleration only if needed
- Use CloudFront to reduce data transfer

### Database Costs

- Right-size your instance
- Use connection pooling
- Archive old data
- Monitor slow queries

## Disaster Recovery

### Backup Plan

1. **Database**: Automated daily backups + point-in-time recovery
2. **S3**: Versioning enabled + cross-region replication
3. **Configuration**: Infrastructure as Code (Terraform)
4. **Secrets**: Backup in secure vault

### Recovery Procedures

```bash
# Database restore (example with pg_restore)
pg_restore -h $NEW_DB_HOST -U $DB_USER -d photoshot backup.dump

# Verify data
psql -h $NEW_DB_HOST -U $DB_USER -d photoshot -c "SELECT COUNT(*) FROM \"User\";"

# Update DNS to point to new instance
# Test all functionality
# Monitor for issues
```

## Compliance

### GDPR Compliance

- Implement data export functionality
- Add data deletion capability
- Document data retention policies
- Add cookie consent banner
- Update privacy policy

### Data Retention

```sql
-- Delete old unverified accounts
DELETE FROM "User" 
WHERE "emailVerified" IS NULL 
AND "createdAt" < NOW() - INTERVAL '30 days';

-- Archive completed projects older than 1 year
-- Move to cold storage or delete per policy
```

## Support & Maintenance

### Regular Tasks

- **Daily**: Check error logs, monitor uptime
- **Weekly**: Review performance metrics, check costs
- **Monthly**: Security updates, dependency updates
- **Quarterly**: Disaster recovery test, capacity planning

### Update Process

```bash
# 1. Test in staging
git checkout develop
git pull
yarn install
yarn build
# Test thoroughly

# 2. Deploy to production
git checkout main
git merge develop
git push
# CI/CD automatically deploys

# 3. Monitor
# Watch error rates and logs for 24h
```

## Checklist Before Going Live

- [ ] All environment variables configured
- [ ] Database backups enabled
- [ ] S3 versioning enabled
- [ ] HTTPS/SSL configured
- [ ] Health checks configured
- [ ] Error tracking configured
- [ ] Monitoring alerts set up
- [ ] Cost alerts configured
- [ ] Security headers enabled
- [ ] Rate limiting implemented
- [ ] Privacy policy and terms of service added
- [ ] GDPR compliance reviewed
- [ ] Load testing performed
- [ ] Disaster recovery plan documented
- [ ] Support process defined

## Additional Resources

- [Next.js Production Checklist](https://nextjs.org/docs/going-to-production)
- [Vercel Best Practices](https://vercel.com/docs/concepts/solutions/overview)
- [Prisma Production Best Practices](https://www.prisma.io/docs/guides/performance-and-optimization/connection-management)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
