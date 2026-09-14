# Build guide: Regional Training Request Tracker

An app with three screens:

1. **Submit Request** — anyone in the region logs a training request.
2. **Dashboard** — you monitor demand: volume, by country, by category, by status, trend over time.
3. **Manage Requests** (optional, for you/reviewers) — approve, reject, update status.

All three read/write the same `Training Requests` SharePoint list.

## 1. Create the SharePoint list

Pick one:
- **Manual**: create a list named `Training Requests` in your SharePoint site and add the columns in `sharepoint/list-schema.md`.
- **Scripted**: `Install-Module PnP.PowerShell` then run `sharepoint/Provision-DashboardList.ps1 -SiteUrl "https://<tenant>.sharepoint.com/sites/<site>"` — edit the `-Countries` parameter to match your region.

## 2. Create a Power Platform environment

1. `admin.powerplatform.microsoft.com` → **Environments** → **+ New**.
2. Type **Developer** (free) or **Sandbox**. Enable Dataverse if you want Git integration later (optional — skip if you just want the app).

## 3. Create a solution and the app

1. `make.powerapps.com` → switch to your environment → **Solutions** → **+ New solution** → name it `TrainingDemandTracker`.
2. Inside it: **+ New** → **App** → **Canvas app** → name `Training Request Tracker`, format **Tablet**.
3. **Insert → Data → SharePoint** → your site → select `Training Requests`.

## 4. Screen 1 — Submit Request

1. Add screen, rename to `scrSubmit`.
2. Insert a **Form** control → **Edit form** → set `DataSource` to `'Training Requests'`.
3. In the form's **Fields** pane, include: Training Topic, Country, Office, Department, Training Category, Delivery Mode, # Participants, Priority, Preferred Start Date, Business Justification. Remove Status, Requested Date, Approver Comments, Estimated Cost — those aren't set by the requester.
4. Add a **Submit** button. Formulas for this screen are in `powerapps/powerfx-snippets.md` under "Submit Request screen" — they auto-stamp `Status = "Submitted"` and `RequestedDate = Today()` on save.

## 5. Screen 2 — Dashboard (the demand monitor)

Add screen `scrDashboard`, then add, in order — full formulas in the snippets file:

1. **Date range filter**: two date pickers (`dtFrom`, `dtTo`), defaulted to the last 12 months.
2. **KPI cards**: Total Requests, Total Participants Requested, Pending Approvals, Avg. Requests/Month.
3. **Column chart**: requests by `Country` — this is your regional breakdown.
4. **Column or bar chart**: requests by `TrainingCategory` — shows what topics are most in demand.
5. **Donut chart**: requests by `Status` — pipeline health at a glance.
6. **Line/column chart**: requests by month (`RequestedDate`) — demand trend over time.
7. **Gallery**: "Top requested topics" — `Title` grouped and counted, sorted descending, top 10.

## 6. Screen 3 — Manage Requests (optional but recommended)

1. Add screen `scrManage`, gallery of all requests with Status filter dropdown.
2. Selecting an item opens a **View/Edit form** with **Approve** and **Reject** buttons that just update `Status` (and optionally `ApproverComments`) — formulas in the snippets file.
3. This is what turns "consolidate requests" into an actual workflow instead of a read-only list.

## 7. Publish and share

**File → Save → Publish this version**, then **Share** with the region (give at least **User** access; give reviewers/yourself **Co-owner** if they need to edit the app itself). Everyone needs a Power Apps license covering standard connectors — SharePoint qualifies under most Microsoft 365 plans.

## 8. Optional — Git integration

Same as any other solution: solution → gear icon → **Git integration** → point at this repo/branch → **Sync with Git → Commit and sync** after each Studio save, so the real `*.pa.yaml` source lands here for review.
