# Firebase Integration Roadmap — Amazon Cases Tracker

> Reference doc for future implementation. Created 2026-03-06.

---

## Why Firebase?

The tracker is a **static HTML file on GitHub Pages** with no backend. Currently, owner assignments, close states, and close dates are stored in **localStorage** — meaning they're browser-local and not shared between users.

Firebase adds **shared persistence** and **real-time sync** with zero server management, all on the **free Spark plan**.

---

## Implementation Layers

### Layer 1 — Shared State + Google Auth (replaces localStorage)

**Goal:** Everything currently in localStorage becomes shared across all users in real-time. Access restricted to authorized Google accounts only.

| Feature | Current | With Firebase |
|---------|---------|---------------|
| Notes/comments per case | Not available | Shared, real-time |
| Owner assignments | localStorage (browser-only) | Synced across all viewers |
| Close/reopen state | localStorage (browser-only) | Synced across all viewers |
| Close dates | localStorage (browser-only) | Synced across all viewers |
| Authentication | None (public page) | Google login required |

**Tech:** Firebase Realtime Database + Firebase Authentication (Google provider).
**Auth:** Google sign-in required. Only authenticated users can read/write. Optionally restrict to specific email addresses.
**Effort:** ~2-3 hours.

**Database rules (authenticated users only):**
```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```

**To restrict to specific emails** (optional, can add later):
```json
{
  "rules": {
    ".read": "auth.token.email == 'user1@gmail.com' || auth.token.email == 'user2@gmail.com'",
    ".write": "auth.token.email == 'user1@gmail.com' || auth.token.email == 'user2@gmail.com'"
  }
}
```

---

### Layer 2 — Enhanced User Features

**Goal:** Build on Layer 1 auth to add richer user-aware features.

| Feature | Details |
|---------|---------|
| Notes show author | "Vitali: waiting for docs" (auto-tagged from Google login) |
| Role-based access | Only certain people can close cases |
| Personal filters | "Show me only MY cases" |
| Email whitelist | Restrict access to specific team members |

**Tech:** Firebase Auth already in Layer 1; extend with user metadata + rules.
**Effort:** ~2-3 hours on top of Layer 1.

---

### Layer 3 — Rich Features

**Goal:** Turn the tracker into a lightweight case management tool.

| Feature | Details |
|---------|---------|
| Comment threads | Multiple notes per case, not just one field |
| Activity log / audit trail | Every status change logged with timestamp + user |
| File attachments | Link supporting documents to cases |
| Search across notes | Find which case mentioned a specific topic |
| Case history | Full timeline of changes per case |

**Tech:** Firestore (structured document database, also free tier).
**Effort:** ~4-6 hours on top of Layer 2.

---

### Layer 4 — Notifications and Analytics

**Goal:** Proactive alerts and operational insights.

| Feature | Details |
|---------|---------|
| Push notifications | Alert when a case status changes |
| Email triggers | Auto-notify team when "Waiting on Us" for 3+ days |
| Dashboard analytics | Avg resolution time, cases by marketplace, cases by brand |
| Offline support | Firebase SDK caches locally, syncs when back online |

**Tech:** Firebase Cloud Messaging + Cloud Functions.
**Note:** Cloud Functions require Blaze (pay-as-you-go) plan, but usage this low would remain free.
**Effort:** ~6-8 hours on top of Layer 3.

---

## What Stays the Same

- **Static HTML on GitHub Pages** — no server to manage
- **Free** — Firebase Spark plan covers Layers 1-3 for this volume
- **Claude refresh process** — missive-reader keeps updating `cases_core.md` and rebuilding HTML as before
- **GitHub deployment** — push to `main` triggers auto-deploy, unchanged

---

## Setup Steps (Layer 1)

### Firebase Console (you do this manually, ~5 min)
1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Click "Add project" → name it (e.g., `amazon-cases-tracker`)
3. **Enable Authentication:**
   - Left sidebar → Authentication → Get started
   - Sign-in method tab → Enable "Google" provider
   - Set support email → Save
4. **Enable Realtime Database:**
   - Left sidebar → Realtime Database → Create Database
   - Choose region: `europe-west1` (Belgium)
   - Start in **locked mode**
   - Go to Rules tab → paste:
     ```json
     {
       "rules": {
         ".read": "auth != null",
         ".write": "auth != null"
       }
     }
     ```
   - Click Publish
5. **Get your config:**
   - Project Settings (gear icon) → General → scroll to "Your apps"
   - Click web icon (`</>`) → register app (name: `tracker`)
   - Copy the `firebaseConfig` object — you'll need it

### Code Changes (Claude does this)
6. Add Firebase SDK scripts + Google Auth + Realtime DB sync to `amazon-cases-tracker.html`
7. Replace all localStorage logic with Firebase read/write
8. Add login screen (shows before tracker loads)
9. Test locally, then push to GitHub Pages

---

## Data Structure (Realtime Database)

```
amazon-cases/
  notes/
    {case_id}: "note text"
  owners/
    {case_id}: "owner name"
  closed/
    {case_id}:
      is_closed: true
      closed_date: "2026-03-06"
```
