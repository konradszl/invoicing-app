# Multi-tenancy isolation
• **Date**: `2026-08-13`  
• **Status**: `Accepted`

### Context
Multiple organizations use the system. The data of one organization must be
isolated and not available to others.

### Decision
I chose row-level isolation on every tenant-owned table. It's simple and easy
to maintain: one backup, one migration and one connection pool instead of per
tenant.

### Consequences
Every query must be scoped, and a forgotten WHERE clause (without `WHERE 
organization_id = '...'`) leaks data across tenants. I know exactly the cost of
RLS: solving connection-pooling with `SET LOCAL`, a non-owner app role 
without `BYPASSRLS`, and `FORCE ROW LEVEL SECURITY`. I will add RLS after
building version 1 of the app.

### Alternatives considered
Multi-tenant architecture could be implemented as schema-per-tenant or 
database-per-tenant. However, both impose costs I cannot absorb building
solo: migration cost across N schemas, connection pool pressure, and 
operational overhead.