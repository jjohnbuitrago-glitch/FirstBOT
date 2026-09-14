# Power Fx snippets for the Team Dashboard

Paste these into the named property of each control. `'Dashboard Items'` is
the SharePoint data source added in the build guide.

## App.OnStart

Builds a local collection so charts/KPIs don't re-query SharePoint on every
keystroke, and refreshes it on demand.

```powerfx
ClearCollect(
    colItems,
    'Dashboard Items'
);
```

Add a **Refresh** icon somewhere with `OnSelect`:

```powerfx
Refresh('Dashboard Items');
ClearCollect(colItems, 'Dashboard Items');
```

## Filter dropdowns (Screen 1)

`ddCategory.Items`:

```powerfx
Distinct(colItems, Category.Value)
```

`ddStatus.Items`:

```powerfx
Distinct(colItems, Status.Value)
```

## Filtered source used everywhere else

Put this as a named formula in **App** (Advanced formula bar, top of
App.Formulas) so every control references the same filtered set:

```powerfx
FilteredItems = Filter(
    colItems,
    (IsBlank(ddCategory.Selected) || Category.Value = ddCategory.Selected.Result) &&
    (IsBlank(ddStatus.Selected) || Status.Value = ddStatus.Selected.Result)
);
```

(If your Power Apps version doesn't support named formulas, create a
`Filter1` variable instead: `Set(varFiltered, Filter(colItems, ...))` in each
dropdown's `OnChange`, and reference `varFiltered` below.)

## KPI cards

**Total Items** label `Text`:

```powerfx
Text(CountRows(FilteredItems))
```

**Completed %** label `Text`:

```powerfx
Text(
    CountRows(Filter(FilteredItems, Status.Value = "Completed")) /
    Max(CountRows(FilteredItems), 1),
    "0%"
)
```

**Overdue** label `Text`:

```powerfx
Text(CountRows(Filter(FilteredItems, DueDate < Today(), Status.Value <> "Completed")))
```

**Total Value** label `Text`:

```powerfx
Text(Sum(FilteredItems, Value), "$#,##0")
```

## Column chart — count by Category

`Items` property of the chart control:

```powerfx
AddColumns(
    GroupBy(FilteredItems, "Category", "Grp"),
    "Count", CountRows(Grp)
)
```

Set the chart's category field to `Category.Value` and value field to
`Count`.

## Pie/donut chart — count by Status

```powerfx
AddColumns(
    GroupBy(FilteredItems, "Status", "Grp"),
    "Count", CountRows(Grp)
)
```

## Gallery (both screens)

`galItems.Items`:

```powerfx
Sort(FilteredItems, DueDate, SortOrder.Ascending)
```

Search box (`txtSearch`) — add it to the filter above, or on Screen 2 use:

```powerfx
galItems.Items:
Sort(
    Filter(FilteredItems, StartsWith(Title, txtSearch.Text)),
    DueDate,
    SortOrder.Ascending
)
```

Gallery item template — label `Text` for the due-date label, colored red when overdue:

```powerfx
// Label.Color
If(ThisItem.DueDate < Today() && ThisItem.Status.Value <> "Completed", Red, Black)
```

## Detail form (Screen 2)

Gallery `OnSelect`:

```powerfx
Set(varSelectedItem, ThisItem);
NewForm(EditForm1);
EditForm1.Item = varSelectedItem;
UpdateContext({showForm: true});
```

(Simplest working pattern: bind `EditForm1.Item` directly to
`galItems.Selected`, and toggle the form's `Visible` with a boolean variable
set in the gallery's `OnSelect`.)

Save button `OnSelect`:

```powerfx
SubmitForm(EditForm1);
```

`EditForm1.OnSuccess`:

```powerfx
Refresh('Dashboard Items');
ClearCollect(colItems, 'Dashboard Items');
UpdateContext({showForm: false});
```
