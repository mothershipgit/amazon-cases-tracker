# Amazon Cases — Project Memory

> Project-level context. Updated automatically as work progresses.

---

## Purpose
Track Amazon Seller Support cases across all brands. Backend API pulls emails from Missive, stores in SQLite, serves to HTML dashboard via REST API.

## Architecture (as of 2026-04-16)

Backend API (Railway) + Two dashboard versions (GitHub Pages). Dashboards load data via `fetch()`.

```
┌──────────────────────────────────┐     ┌──────────────────────────────────┐
│  Frontend (GitHub Pages)         │     │  Backend (Railway)               │
│  amazon-cases-v2.html (active)   │     │  amazon-cases-backend            │
│  amazon-cases-tracker.html (v1)  │     │                                  │
│                                  │     │  GET /api/cases                  │
│  fetch /api/cases                │◄───►│  GET /api/messages               │
│  fetch /api/messages             │     │  POST /api/refresh               │
│  POST /api/refresh               │     │  Missive API (paginated)         │
│  Firebase (user state)           │     │  SQLite (cases.db)               │
│  Charts.js + DataLabels          │     │  node-cron (daily 10AM UTC)      │
│  Google Auth                     │     │                                  │
└──────────────────────────────────┘     └──────────────────────────────────┘
```

## File Structure
```
Amazon Cases/
├── CLAUDE.md                    # This file — project memory
├── amazon-cases-v2.html         # Dashboard v2 (tabbed, active)
├── amazon-cases-tracker.html    # Dashboard v1 (legacy, still works)
├── cases_core.md                # Archive — no longer source of truth
├── asin-names.json              # ASIN → product name lookup (archive)
├── brand-accounts.json          # Email → Brand mapping (archive)
├── data/                        # Archive files
└── backend/                     # API backend (separate GitHub repo)
    ├── server.js                # Express entry point + daily cron
    ├── .env                     # MISSIVE_API_TOKEN, API_KEY
    ├── db/
    │   ├── database.js          # sql.js wrapper + migrations
    │   ├── schema.sql           # 4 tables: cases, messages, conversations, refresh_log
    │   └── cases.db             # SQLite database
    ├── routes/
    │   ├── cases.js             # GET /api/cases, GET /api/cases/:id
    │   ├── messages.js          # GET /api/messages (includes subject), GET /api/messages/:id
    │   └── refresh.js           # POST /api/refresh, GET /api/refresh/status
    ├── services/
    │   ├── missive.js           # Missive HTTP client (paginated since March 16)
    │   └── caseProcessor.js     # Email parsing, classification, auto-dismiss, dedup
    └── config/
        ├── brands.js            # Email→Brand mapping, marketplace inference
        ├── asinNames.js         # ASIN→product name lookup
        ├── issueTypes.js        # Issue type classification rules (2-tier)
        └── autoDismiss.js       # Subject patterns for auto-dismissing notifications
```

## Dashboard v2 (amazon-cases-v2.html)

### Two Tabs
1. **Cases** — standard cases + FBA issues (separate from notifications)
2. **Notifications** — notification emails from Amazon (donotreply@)

### Cases Tab Layout
```
KPI Strip: Open | Closed | Avg Days | Total Msgs | Resolved Rate
Charts (6): Assignee | Status | Daily | Monthly | Issue(Open) | Issue(All)
Filter Bar: Brand | MKT | Owner | Reset
Active Cases Table (14 cols)
FBA Section (collapsible)
Closed Section (collapsed by default)
Analytics Accordions: Total / Open / Closed
```

### Cases Table Columns (14)
```
Close | Case ID | Parent | Summary | Brand | MKT | Owner | Opened | ASIN/Product | Issue Type | Status | Notes | Msgs | Days
```

### Notifications Tab Layout
```
KPI Strip: Active | Auto-dismissed | Total
Filter Bar: Brand | MKT | Reset
Active Notifications Table (9 cols): Close | Case ID | Brand | MKT | Subject | Issue Type | Opened | Status | Days
Closed/Auto-dismissed Section (collapsed)
```

### Key Features
- **ASIN/Product dropdown** — every case has editable product dropdown synced to Firebase `asins/{caseId}`
- **Auto-dismiss** — notification cases matching subject patterns auto-closed + excluded from KPIs/charts
- **Message timeline** — expandable rows show email subjects (not body preview) per case
- **All charts above the table** — 6 charts in 2 rows before the filter bar
- **Per-tab filters** — Brand/MKT/Owner for Cases, Brand/MKT for Notifications

## Backend Features

### Auto-Dismiss Notifications
Config: `backend/config/autoDismiss.js` — subject patterns that auto-close noise notifications:
- Refund initiated, payment on the way, shipped items, FBA fees, etc.
- Auto-dismissed cases: `close=1`, `auto_dismissed=1`, excluded from all KPIs/charts

### Missive Pagination
`listAllConversationsSince(label, sinceDate)` — paginates through all conversations back to a cutoff date (currently March 16, 2026). Uses `until` parameter with `last_activity_at` for pagination. Rate-limited 1s between pages.

### Case Type Detection
- **Standard** — has case ID in subject (`[CASE 12345]` etc.)
- **FBA Issue** — subject matches "missing inbound/items"
- **Notification** — from `donotreply@amazon.com`, no case ID, deterministic `NOTIF-{suffix}` ID

### Message Subject Storage
Messages table includes `subject` field — stores email subject/title per message. Displayed in timeline instead of body preview.

## GitHub & Deployment

### Frontend (Dashboard HTML)
- **Repo:** `https://github.com/mothershipgit/amazon-cases-tracker`
- **v2 URL:** `https://mothershipgit.github.io/amazon-cases-tracker/amazon-cases-v2.html`
- **v1 URL:** `https://mothershipgit.github.io/amazon-cases-tracker/`

### Backend (API)
- **Repo:** `https://github.com/mothershipgit/amazon-cases-backend`
- **Live URL:** `https://amazon-cases-backend-production.up.railway.app`
- **Railway:** Hobby plan (sleep-on-idle enabled)
- **Daily cron:** node-cron at 10:00 AM UTC

### Environment Variables (Railway)
```
NIXPACKS_NODE_VERSION=22
PORT=3002
API_KEY=cases2026
MISSIVE_API_TOKEN=<token>
CRON_ENABLED=true
```

## Firebase Keys (Realtime Database)
| Key | Type | Purpose |
|-----|------|---------|
| `owners/{case_id}` | string | Assignee (Unassigned/Tom/Vitali/Natasha/Leticia/Francesco) |
| `closed/{case_id}` | boolean | Closed state |
| `close_dates/{case_id}` | string | Close date (YYYY-MM-DD) |
| `close_statuses/{case_id}` | string | Outcome: Resolved/Not Resolved/On Hold/etc. |
| `notes/{case_id}` | string | Free-text notes |
| `next_actions/{case_id}` | string | Next action text (legacy, column removed in v2) |
| `parent_cases/{case_id}` | string | Parent case ID |
| `issue_types/{case_id}` | string | Issue type override |
| `marketplaces/{case_id}` | string | Marketplace override (DE/FR/IT/ES/UK/US) |
| `asins/{case_id}` | string | ASIN/Product override (v2 only) |
| `seen_emails/{case_id}/{uid}` | number | Per-user last-seen timestamp for envelope icons |

## Key Decisions
- **Two dashboards** — v2 is the active version, v1 kept as fallback
- **Tabbed layout** — Cases and Notifications are separate tabs with own KPIs/tables
- **14-column table** — Summary at position 4 (after Parent), no Last Update or Next Action columns
- **All 6 charts above the table** — Assignee, Status, Daily, Monthly, Issue(Open), Issue(All)
- **Auto-dismiss** — noise notifications auto-closed by subject pattern match, excluded from stats
- **ASIN dropdown** — editable product assignment via dropdown, stored in Firebase
- **Paginated Missive pull** — fetches all conversations since March 16 with pagination
- **Subject in timeline** — messages store and display email subject, not body preview
- **SQLite is source of truth** — cases_core.md is archive only
- **Firebase for UI state** — owners, notes, closed state, marketplace/issue overrides
- **EXCLUDED_FROM_STATS** — case IDs excluded from KPI calculations (e.g., VIP outlier)

## Missive Integration
- **Amazon Cases label ID:** `c88eb69d-7abe-4ca7-97b2-118fefc36042`
- Pagination via `until` parameter on `/conversations` endpoint (max 50 per page)
- Single conversation can contain multiple case IDs — opened_date filtering handles this
- QSTA dual-inbox dedup via `email_message_id`

## Issue Type Categories
Other, VAT, GPSR Compliance, Image Compliance, Business Compliance, Listing Compliance, Logistics, Product Safety, Restricted Products, Regulatory Compliance, IP Violation, IP Complaint, Authenticity Complaint, Product Condition Complaint, Listing Policy Violation, Reviews Policy Violation, Policy Violation, Premium Support, Escalation, Notification, KYC, Investigation
