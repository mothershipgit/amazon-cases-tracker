# Amazon Cases — Project Memory

> Project-level context. Updated automatically as work progresses.

---

## Purpose
Track Amazon Seller Support cases across all brands. Backend API pulls emails from Missive, stores in SQLite, serves to HTML dashboard via REST API.

## Architecture (as of 2026-03-16)

**Old:** Static HTML with embedded data, Claude manually edits HTML on every email pull.
**New:** Backend API (Railway) + Dynamic HTML (GitHub Pages). Dashboard loads data via `fetch()`.

```
┌──────────────────────────────┐     ┌──────────────────────────────────┐
│  Frontend (GitHub Pages)     │     │  Backend (Railway)               │
│  amazon-cases-tracker.html   │     │  amazon-cases-backend            │
│                              │     │                                  │
│  fetch /api/cases            │◄───►│  GET /api/cases                  │
│  fetch /api/messages         │     │  GET /api/messages               │
│  POST /api/refresh           │     │  POST /api/refresh               │
│  Firebase (user state)       │     │  Missive API (direct HTTP)       │
│  Charts.js                   │     │  SQLite (cases.db)               │
│  Google Auth                 │     │  node-cron (daily 10AM UTC)      │
└──────────────────────────────┘     └──────────────────────────────────┘
```

## File Structure
```
Amazon Cases/
├── CLAUDE.md                    # This file — project memory
├── cases_core.md                # Archive — no longer source of truth (SQLite is)
├── amazon-cases-tracker.html    # Dashboard HTML (data loaded from API)
├── Amazon Cases Tracker.md      # Obsidian view (simplified table)
├── asin-names.json              # ASIN → product name lookup
├── brand-accounts.json          # Email → Brand mapping
├── data/
│   ├── amazon-cases-meta.json   # Archive — migrated to SQLite
│   └── msg-timeline.json        # Archive — migrated to SQLite
└── backend/                     # API backend (separate GitHub repo)
    ├── server.js                # Express entry point
    ├── .env                     # MISSIVE_API_TOKEN, API_KEY
    ├── db/
    │   ├── database.js          # sql.js wrapper
    │   ├── schema.sql           # 4 tables: cases, messages, conversations, refresh_log
    │   ├── migrate.js           # One-time migration from .md/.json files
    │   └── cases.db             # SQLite database
    ├── routes/
    │   ├── cases.js             # GET /api/cases, GET /api/cases/:id
    │   ├── messages.js          # GET /api/messages, GET /api/messages/:id
    │   └── refresh.js           # POST /api/refresh, GET /api/refresh/status
    ├── services/
    │   ├── missive.js           # Direct Missive HTTP API client
    │   └── caseProcessor.js     # Email parsing, classification, dedup, normalizeIssueType
    └── config/
        ├── brands.js            # Email→Brand mapping, marketplace inference
        └── asinNames.js         # ASIN→product name lookup
```

## Brands Tracked
| Brand | Accounts |
|-------|----------|
| QSTA | Multiple EU marketplaces |
| Vegan Vitality | UK |
| Hudson Chase | UK |
| TCU | UK |

## cases_core.md Schema (16 columns)
`close | case_id | brand | marketplace | asin_summary | issue_type | status_bucket | status_current | opened_date | days_open | closed_date | last_update_date | amazon_msgs_count | owner | next_action_due | next_action`

## GitHub & Deployment

### Frontend (Dashboard HTML)
- **Repo:** `https://github.com/mothershipgit/amazon-cases-tracker`
- **Live URL:** `https://mothershipgit.github.io/amazon-cases-tracker/`
- **Branch:** `main`

### Backend (API)
- **Repo:** `https://github.com/mothershipgit/amazon-cases-backend`
- **Live URL:** `https://amazon-cases-backend-production.up.railway.app`
- **Railway:** Separate service, Hobby plan (sleep-on-idle enabled)
- **Daily cron:** node-cron at 10:00 AM UTC (CRON_ENABLED=true)

### Environment Variables (Railway)
```
NIXPACKS_NODE_VERSION=22
PORT=3002
API_KEY=cases2026
MISSIVE_API_TOKEN=<token>
CRON_ENABLED=true
```

## Daily Automation
**Old:** Windows Task Scheduler → Claude CLI → edits HTML → git push
**New:** Railway node-cron → backend calls Missive API → updates SQLite automatically

The Windows Task Scheduler (`AmazonCasesDailyUpdate`) is **obsolete** — can be disabled.

## Key Decisions
- **Data via API** — HTML no longer has embedded CASES/MSG_DATA arrays. Data loaded via fetch() from backend API.
- **Table rows dynamically generated** — renderTableRows() builds rows from API data. No static <tr> in HTML.
- **Refresh button** — triggers POST /api/refresh → pulls Missive emails → polls status → reloads data.
- **Issue type normalization** — backend normalizeIssueType() consolidates categories (all VAT→"VAT", all safety→"Product Safety", etc.)
- **VIP case pinned** — VIP Seller Relations/Premium Support always sorted to top of active table.
- **SQLite is source of truth** — cases_core.md is now an archive, not actively updated.
- **MSG_DATA from API** — stored in SQLite messages table, served via GET /api/messages.
- **All UI state synced via Firebase Realtime Database** — no localStorage
- **Email detection**: always fetch all Missive messages, filter by processed ID list (deletion-safe)
- **`amazon_msgs_count`**: permanent historical counter, never decrements
- **Close workflow**: tick checkbox → row moves to Closed table + Outcome dropdown injected (default: Resolved) + date stamped → Firebase syncs `closed`, `close_dates`, `close_statuses`
- **KPI counters**: `updateKpiCounts()` recalculates Open/Closed from actual table rows after every close toggle and Firebase sync
- **Notification cases**: Emails from `donotreply@amazon.com` / `do-not-reply@amazon.com` with no case ID are captured as `case_type: 'notification'` with deterministic ID format `NOTIF-{last6charsOfConvUUID}` (stable across rebuilds). Marketplace inferred from full email body via `/messages/{id}` endpoint (country names, amazon.XX/sellercentral URLs, language detection). ASIN extracted from full body. Included in KPI stats and assignee charts. Shown in main Active Cases table with amber NOTIF badge. Intended as parent cases — when a real case is opened to address the notification, link it as a child.
- **Marketplace dropdown**: Marketplace column is an editable dropdown (DE/FR/IT/ES/UK/US) persisted via Firebase `marketplaces/{case_id}`. Overrides backend-detected marketplace. Color-coded per marketplace. Changes trigger chart rebuild.
- **Issue type categories**: KYC and Investigation are issue types (not statuses). Full list: Other, VAT, GPSR Compliance, Image Compliance, Business Compliance, Listing Compliance, Logistics, Product Safety, Restricted Products, Regulatory Compliance, IP Violation, IP Complaint, Authenticity Complaint, Product Condition Complaint, Listing Policy Violation, Reviews Policy Violation, Policy Violation, Premium Support, Escalation, Notification, KYC, Investigation.
- **Charts read from DOM**: Analytics charts (`getLiveSubset`) sync issue_type and marketplace from DOM dropdowns before building, ensuring Firebase overrides are reflected. Accordion charts rebuild every time opened (not lazy-init once).
- **Issue Type per Product chart**: Only shows cases that have an ASIN — cases without ASIN are excluded to prevent issue types appearing as product names.

## Firebase Keys (Realtime Database)
| Key | Type | Purpose |
|-----|------|---------|
| `owners/{case_id}` | string | Assignee per case (Unassigned/Tom/Vitali) |
| `closed/{case_id}` | boolean | Closed state |
| `close_dates/{case_id}` | string | Close date (YYYY-MM-DD) |
| `close_statuses/{case_id}` | string | Outcome: Resolved/Not Resolved/On Hold/Waiting on Amazon/Waiting on Us |
| `notes/{case_id}` | string | Free-text notes |
| `next_actions/{case_id}` | string | Next action text |
| `parent_cases/{case_id}` | string | Parent case ID |
| `issue_types/{case_id}` | string | Issue type override |
| `marketplaces/{case_id}` | string | Marketplace override (DE/FR/IT/ES/UK/US) |

## HTML Dashboard Features

### MSG_DATA — Message Timeline
- **Static JS object** embedded in HTML alongside `CASES` array
- Contains chronological message data for each open case: `{ ts, from, preview }`
- **Must be regenerated every time HTML is rebuilt** (missive-reader Step 7) — it does not persist
- `initMsgTimeline()` creates expandable rows with ▶/▼ toggle and badge count
- Detail rows use `.msg-detail-row` class with `data-parent-case` attribute

**Filtering rules:**
- Only messages where `ts >= case.opened_date - 86400` (filters out predecessor case messages from reused Missive threads)
- Deduplication by `email_message_id` (handles QSTA dual-inbox)
- VIP/Premium Support cases with 25+ messages excluded to avoid HTML bloat

### Parent-Child Case Grouping
- Cases can be linked as parent/child in the HTML (`.parent-link` span)
- `sortTable()` treats parent+children as unbreakable blocks — only parent row data determines sort position
- `regroupRows()` ensures children always appear directly after their parent
- Both functions exclude `.msg-detail-row` elements from grouping/sorting via `:not(.msg-detail-row)`

### Closed Table — Outcome Dropdown
- When a case moves to closed table, the Status Bucket column becomes an **Outcome** dropdown
- Options: **Resolved** (green), **Not Resolved** (red), **On Hold** (orange), **Waiting on Amazon** (blue), **Waiting on Us** (red), **Investigation** (purple)
- Default value: Resolved
- When case is reopened, dropdown reverts to static status badge from CASES array
- Synced via Firebase `close_statuses/{case_id}`
- Included in Copy Assignments JSON as `close_statuses`

### EXCLUDED_FROM_STATS
- `const EXCLUDED_FROM_STATS = ['CASE_ID', ...]` — array of case IDs excluded from dashboard statistics
- Used for outlier cases that distort averages (e.g., very old cases)

### Charts (Chart.js)
- **Assignee charts** (`ch-assignee-total`, `ch-assignee-open`) — rebuild automatically when Firebase owner sync fires, so they reflect live owner assignments (not just `cases_core.md` defaults). Uses `buildAssigneeCharts()` which destroys and recreates chart instances.
- **Cases Created Daily** (`ch-daily`) — last 30 days with zero-filled gaps (shows days without cases)
- **Monthly Cases** (`ch-monthly`) — cases grouped by `YYYY-MM` from `opened_date`
- **Workload by Status** — doughnut chart of all cases by `status_bucket`
- **Marketplace & Brand** — grouped bar charts (cases per marketplace by brand, and vice versa)
- **Case Types & Products** — issue type distribution + product/issue type grouped bar

## Active Cases (as of last update)
See `cases_core.md` for live data.

## Missive Integration
- **Amazon Cases label ID:** `c88eb69d-7abe-4ca7-97b2-118fefc36042`
- Case 12122795542 has 2 separate Missive conversation threads → both stored in `conversation_ids`
- A single Missive conversation can contain messages from **multiple Amazon case IDs** (predecessor cases reusing same email thread) — opened_date filtering handles this
- Write Obsidian note directly via Write tool (not MCP) — Obsidian picks up via file watcher

## Notes
- Case 10526714132 removed (453 days old, distorting statistics)
- Case 10995838672 (VIP) has 26+ conversations — excluded from MSG_DATA timeline
- Sort active cases by `last_activity_at` (newest first)
- **Amazon Msgs** = count of messages from `@amazon.*` domains only
- **MSG_DATA badge vs Msgs column**: Badge shows all messages from live Missive fetch (with opened_date filter); Msgs column reflects only messages processed by missive-reader. Temporary mismatches resolve on next skill run.

## Skill
Managed by `.claude/skills/missive-reader/SKILL.md`
