# Power Fx snippets: Regional Training Request Tracker

`'Training Requests'` is the SharePoint data source. Paste each formula into
the named property of the control (select the control, pick the property in
the formula-bar dropdown top-left, paste).

## App.OnStart

```powerfx
ClearCollect(colRequests, 'Training Requests');
```

Add a refresh icon anywhere with `OnSelect`:

```powerfx
Refresh('Training Requests');
ClearCollect(colRequests, 'Training Requests');
```

---

## Screen 1 — Submit Request

`Form1.DataSource` = `'Training Requests'`, `Form1.DefaultMode` = `FormMode.New`.

`btnSubmit.OnSelect`:

```powerfx
SubmitForm(Form1);
```

`Form1.OnSuccess` (auto-stamps fields the requester shouldn't set themselves):

```powerfx
Patch(
    'Training Requests',
    Form1.LastSubmit,
    { Status: { Value: "Submitted" }, RequestedDate: Today() }
);
Notify("Request submitted!", NotificationType.Success);
ResetForm(Form1);
Refresh('Training Requests');
ClearCollect(colRequests, 'Training Requests');
```

---

## Screen 2 — Dashboard

### Date range pickers

`dtFrom.DefaultDate`:

```powerfx
DateAdd(Today(), -12, TimeUnit.Months)
```

`dtTo.DefaultDate`:

```powerfx
Today()
```

### Filtered source (named formula, App.Formulas — or a `Set` in each picker's `OnChange`)

```powerfx
FilteredRequests = Filter(
    colRequests,
    RequestedDate >= dtFrom.SelectedDate,
    RequestedDate <= dtTo.SelectedDate
);
```

If your version doesn't support named formulas, use `Set(varFiltered, Filter(...))` in each date picker's `OnChange` and replace `FilteredRequests` below with `varFiltered`.

### KPI cards

**Total Requests**:

```powerfx
Text(CountRows(FilteredRequests))
```

**Total Participants Requested** (your core demand number):

```powerfx
Text(Sum(FilteredRequests, Participants), "#,##0")
```

**Pending Approvals**:

```powerfx
Text(CountRows(Filter(FilteredRequests, Status.Value in ["Submitted", "Under Review"])))
```

**Avg. Requests / Month**:

```powerfx
Text(
    CountRows(FilteredRequests) /
    Max(DateDiff(dtFrom.SelectedDate, dtTo.SelectedDate, TimeUnit.Months), 1),
    "0.0"
)
```

### Column chart — requests by Country

Chart `Items`:

```powerfx
AddColumns(
    GroupBy(FilteredRequests, "Country", "Grp"),
    "RequestCount", CountRows(Grp),
    "ParticipantCount", Sum(Grp, Participants)
)
```

Category field: `Country.Value`. Value field: `RequestCount` (or `ParticipantCount` if you want headcount demand instead of request count).

### Bar/column chart — requests by Training Category

```powerfx
AddColumns(
    GroupBy(FilteredRequests, "TrainingCategory", "Grp"),
    "RequestCount", CountRows(Grp)
)
```

Category field: `TrainingCategory.Value`. Value field: `RequestCount`.

### Donut chart — requests by Status

```powerfx
AddColumns(
    GroupBy(FilteredRequests, "Status", "Grp"),
    "RequestCount", CountRows(Grp)
)
```

### Trend chart — requests by month

```powerfx
AddColumns(
    GroupBy(
        AddColumns(FilteredRequests, "MonthKey", Text(RequestedDate, "yyyy-mm")),
        "MonthKey", "Grp"
    ),
    "RequestCount", CountRows(Grp)
)
```

Sort it before binding if your chart doesn't sort automatically:

```powerfx
Sort(
    AddColumns(
        GroupBy(
            AddColumns(FilteredRequests, "MonthKey", Text(RequestedDate, "yyyy-mm")),
            "MonthKey", "Grp"
        ),
        "RequestCount", CountRows(Grp)
    ),
    MonthKey,
    SortOrder.Ascending
)
```

### Top requested topics (gallery)

`galTopTopics.Items`:

```powerfx
FirstN(
    Sort(
        AddColumns(
            GroupBy(FilteredRequests, "Title", "Grp"),
            "RequestCount", CountRows(Grp)
        ),
        RequestCount,
        SortOrder.Descending
    ),
    10
)
```

Bind the gallery's title label to `ThisItem.Title` and a count label to `ThisItem.RequestCount`.

---

## Screen 3 — Manage Requests

`galManage.Items`:

```powerfx
Sort(
    Filter(colRequests, IsBlank(ddStatusFilter.Selected) || Status.Value = ddStatusFilter.Selected.Result),
    RequestedDate,
    SortOrder.Descending
)
```

`btnApprove.OnSelect` (with `galManage.Selected` as the current item):

```powerfx
Patch('Training Requests', galManage.Selected, { Status: { Value: "Approved" } });
Refresh('Training Requests');
ClearCollect(colRequests, 'Training Requests');
```

`btnReject.OnSelect`:

```powerfx
Patch(
    'Training Requests',
    galManage.Selected,
    { Status: { Value: "Rejected" }, ApproverComments: txtComments.Text }
);
Refresh('Training Requests');
ClearCollect(colRequests, 'Training Requests');
```
