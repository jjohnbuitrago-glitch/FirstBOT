# Build guide: Team Dashboard canvas app

Follow these steps in order. Steps 1–4 happen in your browser (Power Apps /
Power Platform admin center); step 5 is what wires this repo up to receive
every future change automatically.

## 1. Create (or pick) a Dataverse environment

Git integration for canvas apps requires the app to live inside a
**solution** in a Dataverse-enabled environment.

1. Go to https://admin.powerplatform.microsoft.com → **Environments** → **New**.
2. Type: **Developer** (free, one per user) or **Sandbox** if your org provides one.
3. Enable a Dataverse database when prompted.

## 2. Create a solution

1. Go to https://make.powerapps.com, switch to the environment from step 1.
2. **Solutions** → **New solution**. Name it `TeamDashboard`, pick a publisher (create one with a short prefix, e.g. `contoso`/`con_`).

## 3. Add the canvas app inside the solution

1. Open the `TeamDashboard` solution → **New** → **App** → **Canvas app**.
2. Name it `Team Dashboard`, choose **Tablet** format.
3. **Insert** → **Data** → connect to **SharePoint** → your site URL → select the `Dashboard Items` list (create it first with `sharepoint/Provision-DashboardList.ps1` if you haven't).

## 4. Build the two screens

### Screen 1 — Overview

Add, in this order, then use `powerapps/powerfx-snippets.md` for each control's formula:

1. Four **KPI cards** (rectangle + label): Total Items, Completed %, Overdue, Total Value.
2. A **column chart** control: count of items by `Category`.
3. A **pie/donut chart** control: count of items by `Status`.
4. Two **dropdown** controls for filtering by Category and Status.
5. A **gallery** (vertical, blank) bound to the filtered items, showing Title, Owner, Status, DueDate.

### Screen 2 — Details

1. Duplicate the gallery from Screen 1, add a **Search** input box above it.
2. Add an **Edit form** control bound to `'Dashboard Items'`, hidden by default.
3. Gallery `OnSelect`: `NewForm(Form1); Navigate(Screen2, ScreenTransition.None)` pattern, or simply show/hide the form panel — see snippets file.

## 5. Connect Git integration (so this repo mirrors the app going forward)

1. In https://make.powerapps.com, open the `TeamDashboard` solution.
2. **Solution settings** (gear icon) → **Solution history** / **Settings** → look for **Configure Git integration** (also reachable from the environment's **Settings → Git integration** in some tenants).
3. Point it at this GitHub repository (`jjohnbuitrago-glitch/firstbot`) and the `claude/power-app-office-365-jg4zg2` branch (or `main` once merged).
4. Authorize the connection (GitHub OAuth / PAT, per the wizard).
5. Back in the solution, use **Sync with Git** → **Commit and sync** whenever you want to push your Studio changes here. Reference: https://learn.microsoft.com/power-platform/alm/git-integration/overview

After the first sync you'll see a new `solutions/TeamDashboard/` folder appear
in this repo with the solution manifest and, under a `canvasapps/` folder,
the app's real `*.pa.yaml` source — that's the file to review in future PRs.

## Notes

- `pac canvas pack`/`unpack` are deprecated for authoring; Git integration is
  the supported path for keeping a canvas app's source in a repo.
- Keep control names meaningful and unique as you build — Git integration
  diffs are per-control, and duplicate auto-generated names (`Button1`,
  `Button2`) make future diffs harder to read.
