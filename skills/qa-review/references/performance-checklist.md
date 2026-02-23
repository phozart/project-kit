# Performance Checklist

Performance testing and optimization validation checklist.

## Load Testing

### Test Scenarios
- [ ] Normal load (expected daily traffic)
- [ ] Peak load (2x normal)
- [ ] Stress test (find breaking point)
- [ ] Spike test (sudden traffic increase)
- [ ] Endurance test (sustained load over time)

### Metrics to Measure
- [ ] Response time (p50, p95, p99)
- [ ] Throughput (requests per second)
- [ ] Error rate (% of failed requests)
- [ ] Concurrent users supported
- [ ] Resource utilization (CPU, memory, disk, network)

### Tools
- JMeter, Gatling, k6, Locust, Artillery

## Backend Performance

### Database Optimization
- [ ] Queries use appropriate indexes
- [ ] No N+1 query problems
- [ ] Connection pooling configured
- [ ] Query execution plans reviewed
- [ ] Slow query log monitored
- [ ] Database caching enabled (Redis, Memcached)

### API Performance
- [ ] Response time < 200ms for p95
- [ ] Pagination on large datasets
- [ ] Rate limiting configured
- [ ] Response compression (gzip)
- [ ] Caching headers set appropriately
- [ ] GraphQL query complexity limits

### Async Processing
- [ ] Long-running tasks use background jobs
- [ ] Message queues for async operations
- [ ] Worker scaling configured
- [ ] Dead letter queue for failures

### Caching Strategy
- [ ] Cache hit rate > 80% for cacheable data
- [ ] Cache invalidation strategy defined
- [ ] Cache stampede prevention
- [ ] Appropriate TTL values
- [ ] CDN for static assets

## Frontend Performance

### Bundle Size
- [ ] JavaScript bundle < 200KB (gzipped)
- [ ] CSS bundle < 50KB (gzipped)
- [ ] Code splitting implemented
- [ ] Lazy loading for routes
- [ ] Tree shaking enabled
- [ ] Unused dependencies removed

### Load Time
- [ ] First Contentful Paint (FCP) < 1.8s
- [ ] Largest Contentful Paint (LCP) < 2.5s
- [ ] Time to Interactive (TTI) < 3.8s
- [ ] Cumulative Layout Shift (CLS) < 0.1
- [ ] First Input Delay (FID) < 100ms

### Asset Optimization
- [ ] Images optimized (WebP, AVIF)
- [ ] Images lazy loaded
- [ ] Critical CSS inlined
- [ ] Fonts subset and preloaded
- [ ] JavaScript minified
- [ ] CSS minified

### Network Optimization
- [ ] HTTP/2 or HTTP/3 enabled
- [ ] CDN for static assets
- [ ] DNS prefetch for external domains
- [ ] Resource hints (preload, prefetch)
- [ ] Service worker for offline support

## Data Pipeline Performance

### Batch Processing
- [ ] Partitioning strategy optimized
- [ ] Broadcast joins for small datasets
- [ ] Data skew handled
- [ ] Checkpointing configured
- [ ] Parallelism tuned

### Streaming
- [ ] Backpressure handling
- [ ] Windowing configured appropriately
- [ ] State management optimized
- [ ] Late data handling

## Monitoring and Profiling

### Monitoring
- [ ] Application performance monitoring (APM) enabled
- [ ] Resource metrics collected
- [ ] Custom business metrics tracked
- [ ] Alerting configured for degradation

### Profiling
- [ ] CPU profiling performed
- [ ] Memory profiling performed
- [ ] Database query profiling
- [ ] Network profiling
- [ ] Bottlenecks identified and resolved
