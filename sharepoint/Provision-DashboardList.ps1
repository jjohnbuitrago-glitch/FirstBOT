<#
.SYNOPSIS
    Creates the "Dashboard Items" SharePoint list used by the Team Dashboard Power App.

.DESCRIPTION
    Idempotent: safe to re-run. Creates the list (if missing) and adds any
    columns that don't already exist.

.PREREQUISITES
    Install-Module -Name PnP.PowerShell -Scope CurrentUser
    You need at least "Manage Lists" permission on the target site.

.EXAMPLE
    ./Provision-DashboardList.ps1 -SiteUrl "https://contoso.sharepoint.com/sites/TeamSite"
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$SiteUrl,

    [string]$ListName = "Dashboard Items"
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

Ensure-Field -List $list -InternalName "Category" -DisplayName "Category" -Type Choice `
    -ExtraArgs @{ Choices = @("Sales", "Support", "Operations", "Other") }

Ensure-Field -List $list -InternalName "Status" -DisplayName "Status" -Type Choice `
    -ExtraArgs @{ Choices = @("Not Started", "In Progress", "Completed", "Blocked") }

Ensure-Field -List $list -InternalName "Priority" -DisplayName "Priority" -Type Choice `
    -ExtraArgs @{ Choices = @("Low", "Medium", "High") }

Ensure-Field -List $list -InternalName "Owner0" -DisplayName "Owner" -Type User

Ensure-Field -List $list -InternalName "DueDate" -DisplayName "Due Date" -Type DateTime `
    -ExtraArgs @{ DateTimeDisplayFormat = "DateOnly" }

Ensure-Field -List $list -InternalName "Value" -DisplayName "Value" -Type Number

Ensure-Field -List $list -InternalName "Notes" -DisplayName "Notes" -Type Note

Write-Host "Done. List URL: $SiteUrl/Lists/$($ListName -replace ' ', '')"
