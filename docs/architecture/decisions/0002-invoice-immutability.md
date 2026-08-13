# Invoice immutability
• **Date**: `2026-08-14`  
• **Status**: `Accepted`

### Context
An invoice isn't a database row that happens to be important - it's a legal
document with tax consequences. Once the invoice is issued, it's been sent 
to a counterparty and reported to tax authorities. Its contents can no longer 
change. Rails makes `UPDATE` trivially easy and application-level guards don't 
bind the console, psql, or other clients.

### Decision
Corrections are made with a new separate document and the relation between them
is made by `corrects_invoice_id`. Invoice content is immutable by trigger, and
the status column can be modified.

### Consequences
A large part of the invoice is frozen: amounts, line items, client snapshot, 
invoice numbers and dates. Some columns still move like `status` and `paid_at`.
Trigger needs to be created on `invoices` table after initial schema setup, to
ensure proper immutability. The cost is higher: fixing a typo on an issued 
invoice means issuing a correction, which is slower than editing - that's the
price of legal correctness.

### Alternatives considered
The easiest alternative is model-level validation - it is bypassed by 
`rails console`, `update_column`, psql and migrations. I rejected it because
the guarantee has to hold below the application. Second alternative is append-only
event sourcing where you never update at all, state changes become rows in an events 
table. It's the stronger option, but the cost of maintenance and time that needs
to be invested is not worth it for 1 version of the app and building solo.