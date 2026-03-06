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
  "In Progress"      — Active, no clear party waiting
  "Escalated"        — Specialist/internal team involved
  "Resolved"         — Case closed/reinstated/no further action

Updated automatically by Claude via missive-reader skill.
Last updated: 2026-03-06
-->

| close | case_id | brand | marketplace | asin_summary | issue_type | status_bucket | status_current | opened_date | days_open | closed_date | last_update_date | amazon_msgs_count | owner | next_action_due | next_action |
|-------|---------|-------|-------------|--------------|------------|---------------|----------------|-------------|-----------|-------------|------------------|-------------------|-------|-----------------|-------------|
| false | 12139919272 | QSTA | FR | B0BH37FCZQ | FBA Stock Investigation | Waiting on Amazon | Investigation complete, corrective measures taken | 2026-02-16 | 18 | | 2026-02-26 | 6 | Vitali | 2026-02-19 | Provide correct ASIN for mislabeled units |
| false | 12122795542 | QSTA | IT | B0BC4FT3XP | Restricted Products Appeal | Escalated | Internal team removing non-compliant images before escalation | 2026-02-12 | 22 | | 2026-03-05 | 9 | Vitali | | |
| false | 12139373442 | QSTA | IT | B0GMYGR5Z9 | Restricted Products Appeal | In Progress | Reinstatement process started | 2026-02-16 | 18 | | 2026-02-16 | 2 | Vitali | | |
| false | 12122998082 | QSTA | IT | B0BC4FT3XP | Restricted Products Appeal | Waiting on Us | ASIN reinstatement rejected - new appeal required | 2026-02-17 | 17 | | 2026-02-17 | 1 | Unassigned | | |
| false | 10995838672 | QSTA | UK | B0BM1WPXC5 | VIP Seller Relations | Waiting on Amazon | VIP team investigating multiple issues (manufacturer info, suppressed ASINs) | 2026-02-18 | 16 | | 2026-03-06 | 24 | Unassigned | | |
| false | 11756757402 | TCU | UK | | Country of Origin Compliance | Waiting on Us | Action required - provide COO information for listings | 2026-02-19 | 15 | | 2026-02-19 | 1 | Unassigned | | |
| false | 12150140992 | QSTA | ES | B0BC4FT3XP | Image Compliance - Escalation | In Progress | Premium Support reviewing non-compliant image removal | 2026-02-20 | 14 | | 2026-02-27 | 6 | Unassigned | | |
| false | 12160163052 | Vegan Vitality | ES | B0DJTJ11PG | FBA Stock Investigation | In Progress | FBA inspection complete - no defects found, review requested | 2026-02-23 | 11 | | 2026-02-23 | 1 | Unassigned | | |
| false | 12160765972 | QSTA | IT | B0GKPPG3P6 | Restricted Products Appeal | Waiting on Us | Appeal rejected - unable to reactivate ASIN | 2026-02-24 | 10 | | 2026-02-26 | 2 | Unassigned | | |
| false | 12196144212 | QSTA | ES | B0B6GHYP1V | Product Suppressed - Safety | In Progress | Updated safety documentation under review | 2026-03-01 | 5 | | 2026-03-06 | 4 | Unassigned | | |
| false | 12189296792 | QSTA | IT | B0BC4FT3XP | Restricted Products Appeal | Waiting on Us | Appeal rejected - unable to reactivate ASIN | 2026-03-03 | 3 | | 2026-03-04 | 2 | Unassigned | | |
| false | 12193136902 | QSTA | IT | B0GKPPG3P6 | Restricted Products Appeal | In Progress | Reinstatement process started | 2026-03-03 | 3 | | 2026-03-03 | 2 | Unassigned | | |
| false | 12196786792 | QSTA | ES | B0B6GHYP1V | Food and Product Safety | In Progress | Reinstatement request under review (ES safety) | 2026-03-04 | 2 | | 2026-03-04 | 1 | Unassigned | | |
| false | 12199208622 | QSTA | DE | B0G8JPG7FF | Escalation Review | Escalated | Premium team reviewing suppressed ASINs | 2026-03-04 | 2 | | 2026-03-05 | 2 | Unassigned | | |
| false | 12202348262 | Hudson Chase | ES | | VAT Number Issue | In Progress | Spanish VAT number issue under investigation | 2026-03-05 | 1 | | 2026-03-05 | 1 | Unassigned | | |
| true | 12159445672 | QSTA | DE | B0BM1WPXC5 | Escalation Review | Resolved | No restrictions found on listings | 2026-02-23 | 11 | 2026-03-06 | 2026-02-26 | 3 | Unassigned | | |
| true | 19599539061 | QSTA | US | | Queue Misassignment | Resolved | Incorrectly assigned queue - Amazon apologized | 2026-03-05 | 1 | 2026-03-06 | 2026-03-05 | 1 | Unassigned | | |
| true | 12053445982 | QSTA | IT | B0BC4FT3XP | Restricted Products Appeal | Resolved | Auto-closed - no response received | 2026-02-21 | 4 | 2026-02-25 | 2026-02-25 | 4 | Unassigned | | |
| true | 12014653392 | QSTA | UK | | VAT Invoice Reissue | Resolved | Amazon still investigating (case manually closed) | 2026-02-15 | 2 | 2026-02-17 | 2026-03-02 | 4 | Vitali | | |
