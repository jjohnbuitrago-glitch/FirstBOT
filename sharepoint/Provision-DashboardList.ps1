<#
.SYNOPSIS
    Creates the "Training Requests" SharePoint list used by the Regional
    Training Request Tracker Power App.

.DESCRIPTION
    Idempotent: safe to re-run. Creates the list (if missing) and adds any
    columns that don't already exist.

.PREREQUISITES
    Install-Module -Name PnP.PowerShell -Scope CurrentUser
    You need at least "Manage Lists" permission on the target site.

.EXAMPLE
    ./Provision-DashboardList.ps1 -SiteUrl "https://contoso.sharepoint.com/sites/RegionalTraining" `
        -Countries "Colombia","Mexico","Peru","Chile"
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$SiteUrl,

    [string]$ListName = "Training Requests",

    [string[]]$Countries = @("Colombia", "Mexico", "Peru", "Chile", "Other")
)

Connect-PnPOnline -Url $SiteUrl -Interactive

$list = Get-PnPList -Identity $ListName -ErrorAction SilentlyContinue
if (-not $list) {
    Write-Host "Creating list '$ListName'..."
    $list = New-PnPList -Title $ListName -Template GenericList
}
else {
    Write-Host "List '$ListName' already exists, checking columns..."
}

function Ensure-Field {
    param($List, $InternalName, $DisplayName, $Type, [hashtable]$ExtraArgs = @{})

    $existing = Get-PnPField -List $List -Identity $InternalName -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "  Column '$DisplayName' already exists, skipping."
        return
    }

    Write-Host "  Adding column '$DisplayName' ($Type)..."
    Add-PnPField -List $List -InternalName $InternalName -DisplayName $DisplayName `
        -Type $Type -AddToDefaultView @ExtraArgs | Out-Null
}

Ensure-Field -List $list -InternalName "Country" -DisplayName "Country" -Type Choice `
    -ExtraArgs @{ Choices = $Countries }

Ensure-Field -List $list -InternalName "Office" -DisplayName "Office / Site" -Type Text

Ensure-Field -List $list -InternalName "Department" -DisplayName "Department" -Type Choice `
    -ExtraArgs @{ Choices = @("Sales", "Operations", "Finance", "HR", "IT", "Other") }

Ensure-Field -List $list -InternalName "RequestedBy0" -DisplayName "Requested By" -Type User

Ensure-Field -List $list -InternalName "TrainingCategory" -DisplayName "Training Category" -Type Choice `
    -ExtraArgs @{ Choices = @("Technical", "Leadership", "Compliance", "Soft Skills", "Onboarding", "Other") }

Ensure-Field -List $list -InternalName "DeliveryMode" -DisplayName "Delivery Mode" -Type Choice `
    -ExtraArgs @{ Choices = @("In-Person", "Virtual", "Hybrid") }

Ensure-Field -List $list -InternalName "Participants" -DisplayName "# Participants" -Type Number

Ensure-Field -List $list -InternalName "Priority" -DisplayName "Priority" -Type Choice `
    -ExtraArgs @{ Choices = @("Low", "Medium", "High", "Urgent") }

Ensure-Field -List $list -InternalName "Status" -DisplayName "Status" -Type Choice `
    -ExtraArgs @{ Choices = @("Submitted", "Under Review", "Approved", "Scheduled", "Completed", "Rejected", "Cancelled") }

Ensure-Field -List $list -InternalName "RequestedDate" -DisplayName "Requested Date" -Type DateTime `
    -ExtraArgs @{ DateTimeDisplayFormat = "DateOnly" }

Ensure-Field -List $list -InternalName "PreferredStartDate" -DisplayName "Preferred Start Date" -Type DateTime `
    -ExtraArgs @{ DateTimeDisplayFormat = "DateOnly" }

Ensure-Field -List $list -InternalName "EstimatedCost" -DisplayName "Estimated Cost" -Type Currency

Ensure-Field -List $list -InternalName "Justification" -DisplayName "Business Justification" -Type Note

Ensure-Field -List $list -InternalName "ApproverComments" -DisplayName "Approver Comments" -Type Note

Write-Host "Done. List URL: $SiteUrl/Lists/$($ListName -replace ' ', '')"
