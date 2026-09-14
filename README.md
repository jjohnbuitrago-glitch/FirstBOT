# FirstBOT — Team Dashboard (Power Apps + SharePoint)

A Power Platform canvas app that gives a team a single dashboard over a
SharePoint list of work items: KPI tiles, a status/category breakdown, and a
filterable, editable list.

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
| `sharepoint/list-schema.md` | Column definitions for the `Dashboard Items` list |
| `sharepoint/Provision-DashboardList.ps1` | PnP PowerShell script that creates the list and columns for you |
| `powerapps/build-guide.md` | Step-by-step: create the environment/solution, build the app, wire up Git integration |
| `powerapps/powerfx-snippets.md` | Copy-paste Power Fx formulas for every control (KPIs, charts, filters, forms) |

## Quick start

1. **Provision the data**: run `sharepoint/Provision-DashboardList.ps1` against your SharePoint site (see comments in the script for prerequisites).
2. **Build the app**: follow `powerapps/build-guide.md` to create a solution-aware canvas app in Power Apps Studio bound to that list.
3. **Paste the formulas**: use `powerapps/powerfx-snippets.md` for the KPI tiles, charts, and gallery.
4. **Connect Git integration**: last section of the build guide — after this, every save in Studio pushes updated YAML source into this repo, so future changes show up as normal PRs/diffs.

## Prerequisites

- A Microsoft 365 account with a Power Apps license (per-user or per-app; SharePoint is a *standard* connector, so no premium license is required for this app).
- A SharePoint Online site you can create lists in.
- A Dataverse environment for the solution + Git integration (a free Developer environment works: https://make.powerapps.com → Environments → New → Developer).
