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
    └── amazon-cases-meta.json   # Processed email IDs (idempotency)
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

## Key Decisions
- **Owner assignments**: done via Copy Assignments JSON in HTML → paste to Claude → updates cases_core.md
- **Email detection**: always fetch all Missive messages, filter by processed ID list (deletion-safe)
- **`amazon_msgs_count`**: permanent historical counter, never decrements
- **Close workflow**: tick checkbox in HTML → row moves to Closed table + stamps date → Copy Assignments JSON includes `close` + `close_dates` arrays
- **Deployment**: static HTML copied to `deploy/index.html` → pushed to GitHub Pages
  - Live URL: https://mothershipgit.github.io/amazoncases/
  - Repo: https://github.com/mothershipgit/amazoncases.git (HTTPS)

## LocalStorage Keys (HTML)
| Key | Type | Purpose |
|-----|------|---------|
| `amazon_case_owners` | dict | Assignee per case |
| `amazon_case_closed` | array | Closed case IDs |
| `amazon_case_close_dates` | dict | Close date per case |

## Active Cases (as of last update)
See `cases_core.md` for live data.

## Missive Integration
- **Amazon Cases label ID:** `c88eb69d-7abe-4ca7-97b2-118fefc36042`
- Case 12122795542 has 2 separate Missive conversation threads → both stored in `conversation_ids`
- Write Obsidian note directly via Write tool (not MCP) — Obsidian picks up via file watcher

## Notes
- Case 10526714132 removed (453 days old, distorting statistics)
- Sort active cases by `last_activity_at` (newest first)
- **Amazon Msgs** = count of messages from `@amazon.*` domains only

## Skill
Managed by `.claude/skills/missive-reader/SKILL.md`
