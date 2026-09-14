# SharePoint list: `Training Requests`

Single, region-wide list where anyone submits a training request. The Power
App reads/writes to this list; the dashboard aggregates it to show demand.

| Column (internal name) | Display name | Type | Notes |
| --- | --- | --- | --- |
| `Title` | Training Topic | Single line of text | Built-in column, reused as the topic/course name, e.g. "Advanced Excel" |
| `Country` | Country | Choice | Edit the choice list to your region's countries, e.g. `Colombia`, `Mexico`, `Peru`, `Chile` |
| `Office` | Office / Site | Single line of text | Optional, free text (city or office name) |
| `Department` | Department | Choice | e.g. `Sales`, `Operations`, `Finance`, `HR`, `IT`, `Other` |
| `RequestedBy0` | Requested By | Person or group | Internal name avoids clashing with a hidden system field |
| `TrainingCategory` | Training Category | Choice | `Technical`, `Leadership`, `Compliance`, `Soft Skills`, `Onboarding`, `Other` |
| `DeliveryMode` | Delivery Mode | Choice | `In-Person`, `Virtual`, `Hybrid` |
| `Participants` | # Participants | Number | Head count requested — this is your core "demand" measure |
| `Priority` | Priority | Choice | `Low`, `Medium`, `High`, `Urgent` |
| `Status` | Status | Choice | `Submitted`, `Under Review`, `Approved`, `Scheduled`, `Completed`, `Rejected`, `Cancelled` |
| `RequestedDate` | Requested Date | Date and time | Date only; set automatically at submission |
| `PreferredStartDate` | Preferred Start Date | Date and time | Date only |
| `EstimatedCost` | Estimated Cost | Currency | Optional, leave blank if unknown |
| `Justification` | Business Justification | Multiple lines of text | Why this training is needed |
| `ApproverComments` | Approver Comments | Multiple lines of text | Filled in by whoever reviews/approves |

## Suggested views

- **All Requests** (default)
- **Pending My Review**: `Status` in `Submitted, Under Review`
- **This Quarter**: `RequestedDate` within current quarter

These SharePoint views are optional — the app does its own filtering in
Power Fx — but they're handy for browsing the raw list directly.
