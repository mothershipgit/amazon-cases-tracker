<!--
cases_core.md — Amazon Seller Support / Account Health Case Tracker
Single source of truth for operational case tracking.

MANUAL TRIAGE (humans fill these — Claude never auto-overwrites):
  - owner:           New cases default to "Unassigned". Never changed by Claude.
  - next_action:     Claude only fills if explicitly stated in email with high confidence.
  - next_action_due: Claude only fills if explicitly stated (e.g. "respond within 48 hours").
  - brand:           Claude fills only if clearly identifiable from email. Otherwise blank.
  - issue_type:      Claude fills from email subject where possible.

STATUS BUCKETS:
  "Waiting on Us"    — Amazon requested action/info from us
  "Waiting on Amazon"— We are waiting for Amazon to respond/investigate
  "On Hold"          — Paused / deferred
  "Not Resolved"     — Closed without resolution
  "Resolved"         — Case closed/reinstated/no further action

Updated automatically by Claude via missive-reader skill.
Last updated: 2026-03-11 | 5 active · 19 closed
-->

| close | case_id | brand | marketplace | asin_summary | issue_type | status_bucket | status_current | opened_date | days_open | closed_date | last_update_date | amazon_msgs_count | owner | next_action_due | next_action |
|-------|---------|-------|-------------|--------------|------------|---------------|----------------|-------------|-----------|-------------|------------------|-------------------|-------|-----------------|-------------|
| false | 10995838672 | QSTA | UK | B0BM1WPXC5 | VIP Seller Relations | Waiting on Amazon | Modification applied correctly, VIP team confirming | 2026-02-18 | 21 | | 2026-03-09 | 26 | Unassigned | | |
| false | 12212227522 | Vegan Vitality | IT | | Italian VAT Verification | Waiting on Us | Reminder - more information needed to resolve case | 2026-03-09 | 2 | | 2026-03-11 | 4 | Tom | | |
| false | 12208889982 | QSTA | IT | B0B6GHYP1V | Product Safety Investigation | Waiting on Us | Safety incident reported - action required | 2026-03-08 | 3 | | 2026-03-08 | 1 | Vitali | | |
| false | 12212267962 | TCU | IT | | Italian VAT Verification | Waiting on Amazon | Follow-up on VAT activation error received | 2026-03-09 | 2 | | 2026-03-11 | 3 | Tom | | |
| false | 12202348262 | Hudson Chase | ES | | VAT Number Issue | Waiting on Amazon | Grace period request being investigated | 2026-03-05 | 6 | | 2026-03-11 | 3 | Tom | | |
| true | 12139919272 | QSTA | FR | B0BH37FCZQ | FBA Stock Investigation | Resolved | Investigation complete, corrective measures taken | 2026-02-16 | 22 | 2026-03-10 | 2026-02-26 | 6 | Vitali | 2026-02-19 | Provide correct ASIN for mislabeled units |
| true | 12122795542 | QSTA | IT | B0BC4FT3XP | Restricted Products Appeal | Resolved | Awaiting Policy team update on SAS escalation | 2026-02-12 | 26 | 2026-03-10 | 2026-03-09 | 10 | Vitali | | |
| true | 12139373442 | QSTA | IT | B0GMYGR5Z9 | Restricted Products Appeal | Resolved | Reinstatement process started | 2026-02-16 | 22 | 2026-03-10 | 2026-02-16 | 2 | Vitali | | |
| true | 12122998082 | QSTA | IT | B0BC4FT3XP | Restricted Products Appeal | Resolved | ASIN reinstatement rejected - new appeal required | 2026-02-17 | 21 | 2026-03-10 | 2026-02-17 | 1 | Vitali | | |
| true | 11756757402 | TCU | UK | | Country of Origin Compliance | Resolved | Action required - provide COO information for listings | 2026-02-19 | 19 | 2026-03-10 | 2026-02-19 | 1 | Tom | | |
| true | 12150140992 | QSTA | ES | B0BC4FT3XP | Image Compliance - Escalation | Resolved | Premium Support reviewing non-compliant image removal | 2026-02-20 | 18 | 2026-03-10 | 2026-02-27 | 6 | Vitali | | |
| true | 12160163052 | Vegan Vitality | ES | B0DJTJ11PG | FBA Stock Investigation | Resolved | FBA inspection complete - no defects found, review requested | 2026-02-23 | 15 | 2026-03-10 | 2026-02-23 | 1 | Tom | | |
| true | 12160765972 | QSTA | IT | B0GKPPG3P6 | Restricted Products Appeal | Resolved | Appeal rejected - unable to reactivate ASIN | 2026-02-24 | 14 | 2026-03-10 | 2026-02-26 | 2 | Vitali | | |
| true | 12196144212 | QSTA | ES | B0B6GHYP1V | Product Suppressed - Safety | Resolved | Manufacturer contact info requirement under review | 2026-03-01 | 9 | 2026-03-10 | 2026-03-07 | 6 | Vitali | | |
| true | 12189296792 | QSTA | IT | B0BC4FT3XP | Restricted Products Appeal | Resolved | Appeal rejected - unable to reactivate ASIN | 2026-03-03 | 7 | 2026-03-10 | 2026-03-04 | 2 | Vitali | | |
| true | 12193136902 | QSTA | IT | B0GKPPG3P6 | Restricted Products Appeal | Resolved | Reinstatement process started | 2026-03-03 | 7 | 2026-03-10 | 2026-03-03 | 2 | Vitali | | |
| true | 12196786792 | QSTA | ES | B0B6GHYP1V | Food and Product Safety | Resolved | Reinstatement request under review (ES safety) | 2026-03-04 | 6 | 2026-03-10 | 2026-03-04 | 1 | Vitali | | |
| true | 12199208622 | QSTA | DE | B0G8JPG7FF | Escalation Review | Resolved | Premium team confirms updates impacted ASIN listing | 2026-03-04 | 6 | 2026-03-10 | 2026-03-09 | 4 | Vitali | | |
| true | 12206260832 | QSTA | ES | | Feed Upload Errors | Resolved | Reminder - more information needed to resolve case | 2026-03-06 | 4 | 2026-03-10 | 2026-03-09 | 2 | Vitali | | |
| true | 10195287522 | TCU | UK | | General Product Safety Regulation | Resolved | Listings removed - GPSR compliance action needed | 2026-03-09 | 1 | 2026-03-10 | 2026-03-09 | 1 | Tom | | |
| true | 12159445672 | QSTA | DE | B0BM1WPXC5 | Escalation Review | Resolved | No restrictions found on listings | 2026-02-23 | 11 | 2026-03-06 | 2026-02-26 | 3 | Vitali | | |
| true | 19599539061 | QSTA | US | | Queue Misassignment | Resolved | Incorrectly assigned queue - Amazon apologized | 2026-03-05 | 1 | 2026-03-06 | 2026-03-09 | 3 | Vitali | | |
| true | 12053445982 | QSTA | IT | B0BC4FT3XP | Restricted Products Appeal | Resolved | Auto-closed - no response received | 2026-02-21 | 4 | 2026-02-25 | 2026-02-25 | 4 | Vitali | | |
| true | 12014653392 | QSTA | UK | | VAT Invoice Reissue | Resolved | Amazon still investigating (case manually closed) | 2026-02-15 | 2 | 2026-02-17 | 2026-03-08 | 5 | Vitali | | |
