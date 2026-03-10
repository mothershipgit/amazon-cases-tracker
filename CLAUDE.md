# Amazon Cases — Project Memory

> Project-level context. Updated automatically as work progresses.

---

## Purpose
Track Amazon Seller Support cases across all brands. Receive email notifications via Missive, log to cases_core.md, display in HTML dashboard, deploy to GitHub Pages.

## File Structure
```
Amazon Cases/
├── CLAUDE.md                    # This file — project memory
├── cases_core.md                # Source of truth — all case data (16 columns)
├── amazon-cases-tracker.html    # Combined tracker + dashboard (Charts.js)
├── Amazon Cases Tracker.md      # Obsidian view (simplified table)
├── asin-names.json              # ASIN → product name lookup (71 ASINs)
├── brand-accounts.json          # Email → Brand mapping
└── data/
    ├── amazon-cases-meta.json   # Processed email IDs (idempotency)
    └── msg-timeline.json        # Persistent message timeline (survives Missive deletions)
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
- **Repo:** `https://github.com/mothershipgit/amazon-cases-tracker`
- **Live URL:** `https://mothershipgit.github.io/amazon-cases-tracker/`
- **Branch:** `main`
- **Excluded from repo:** `brand-accounts.json`, `data/` (contain email addresses / IDs)
- **Push command:** `git add cases_core.md amazon-cases-tracker.html && git commit -m "..." && git push origin main`

## Daily Automation (Task Scheduler)
- **Task name:** `AmazonCasesDailyUpdate`
- **Schedule:** every day at 10:00 AM
- **Entry point:** `C:\AmazonUpdate\run.bat` (wrapper, no spaces in path)
- **Main script:** `daily-update.ps1` (in this folder)

**What the daily run does:**
1. `git pull` — picks up any manual changes pushed elsewhere
2. Claude checks Missive for new Amazon case emails
3. Updates `cases_core.md` + regenerates `amazon-cases-tracker.html`
4. `git commit + push` if anything changed
5. Writes log to `daily-update.log`

**To re-register task** (if Windows reinstalled etc.):
```
schtasks /create /tn "AmazonCasesDailyUpdate" /tr "C:\AmazonUpdate\run.bat" /sc daily /st 07:00 /f
```

**To check task status:**
```powershell
Get-ScheduledTaskInfo -TaskName AmazonCasesDailyUpdate
```

## Key Decisions
- **All UI state synced via Firebase Realtime Database** — no localStorage
- **Email detection**: always fetch all Missive messages, filter by processed ID list (deletion-safe)
- **`amazon_msgs_count`**: permanent historical counter, never decrements
- **Close workflow**: tick checkbox → row moves to Closed table + Outcome dropdown injected (default: Resolved) + date stamped → Firebase syncs `closed`, `close_dates`, `close_statuses`
- **KPI counters**: `updateKpiCounts()` recalculates Open/Closed from actual table rows after every close toggle and Firebase sync

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
- Options: **Resolved** (green), **Not Resolved** (red), **On Hold** (orange), **Waiting on Amazon** (blue), **Waiting on Us** (red)
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
