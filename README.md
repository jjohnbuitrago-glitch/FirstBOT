# FirstBOT — Regional Training Request Tracker (Power Apps + SharePoint)

A Power Platform canvas app that consolidates training requests from across
a region into one SharePoint list, and gives you an interactive dashboard
to monitor demand: volume, by country, by training category, by status,
and trend over time.

Three screens: **Submit Request** (anyone in the region logs a request),
**Dashboard** (you monitor demand), **Manage Requests** (approve/reject and
track status).

Canvas apps are built visually in Power Apps Studio — there's no way to
generate a working `.msapp` by hand outside the tool (Microsoft's own
`pac canvas pack`/`unpack` commands are deprecated for this reason). So this
repo holds everything *around* the app — the SharePoint schema, the exact
Power Fx formulas to paste in, and the Git setup — and once you connect this
repo to your environment via **Dataverse Git integration**, the app's real
source (`*.pa.yaml`) will sync here automatically after every save.

## What's in this repo

| Path | Purpose |
| --- | --- |
| `sharepoint/list-schema.md` | Column definitions for the `Training Requests` list |
| `sharepoint/Provision-DashboardList.ps1` | PnP PowerShell script that creates the list and columns for you |
| `powerapps/build-guide.md` | Step-by-step: create the environment/solution, build all 3 screens, wire up Git integration |
| `powerapps/powerfx-snippets.md` | Copy-paste Power Fx formulas for the submit form, every dashboard chart/KPI, and the approve/reject actions |

## Quick start

1. **Provision the data**: run `sharepoint/Provision-DashboardList.ps1` against your SharePoint site — edit the `-Countries` parameter to match your region.
2. **Build the app**: follow `powerapps/build-guide.md` for the Submit, Dashboard, and Manage screens.
3. **Paste the formulas**: `powerapps/powerfx-snippets.md` has the exact formula for every control, section by section.
4. **Connect Git integration** (optional): last section of the build guide — after this, every save in Studio pushes updated YAML source into this repo.

## Prerequisites

- A Microsoft 365 account with a Power Apps license (per-user or per-app; SharePoint is a *standard* connector, so no premium license is required for this app).
- A SharePoint Online site you can create lists in.
- A Power Platform environment (a free Developer environment works: `make.powerapps.com` → Environments → New → Developer). Dataverse is only needed if you want Git integration.
