# SharePoint list: `Dashboard Items`

Backing data source for the Team Dashboard canvas app. Generic enough to
track requests, tasks, sales records, or issues — rename the list and
adjust choice values to fit your scenario.

| Column (internal name) | Display name | Type | Notes |
| --- | --- | --- | --- |
| `Title` | Title | Single line of text | Built-in; used as the item name |
| `Category` | Category | Choice | e.g. `Sales`, `Support`, `Operations`, `Other` |
| `Status` | Status | Choice | `Not Started`, `In Progress`, `Completed`, `Blocked` |
| `Priority` | Priority | Choice | `Low`, `Medium`, `High` |
| `Owner0` | Owner | Person or group | Single value. Internal name is `Owner0` — `Owner` collides with a hidden system field on some SharePoint list templates. |
| `DueDate` | Due Date | Date and time | Date only |
| `Value` | Value | Number | Dollar amount, hours, or any numeric KPI you want to sum |
| `Notes` | Notes | Multiple lines of text | Plain text |

## Sample views

- **All Items** (default)
- **Overdue**: filter `DueDate < [Today]` and `Status ne 'Completed'`
- **My Items**: filter `Owner = [Me]`

These aren't required by the app (the app filters in Power Fx instead), but
they're useful for browsing the list directly in SharePoint.
