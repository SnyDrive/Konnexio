# PowerShell script to generate/update secrets in .env
# Usage: powershell.exe -File internal.ps1

$envFile = Join-Path $PSScriptRoot ".env"

function Update-EnvVar {
    param(
        [string]$Key,
        [string]$Value
    )
    if (Test-Path $envFile) {
        $lines = Get-Content $envFile
        $found = $false
        $newLines = $lines | ForEach-Object {
            if ($_ -match "^$Key=") {
                $found = $true
                "$Key=$Value"
            } else {
                $_
            }
        }
        if (-not $found) {
            $newLines += "$Key=$Value"
        }
        $newLines | Set-Content $envFile
    } else {
        "$Key=$Value" | Set-Content $envFile
    }
}

function Get-EnvVar {
    param([string]$Key)
    if (Test-Path $envFile) {
        $lines = Get-Content $envFile
        foreach ($line in $lines) {
            if ($line -match "^$Key=(.*)") {
                return $Matches[1]
            }
        }
    }
    return ""
}

# LOCKBOX_MASTER_KEY
$LOCKBOX_MASTER_KEY = Get-EnvVar "LOCKBOX_MASTER_KEY"
if ([string]::IsNullOrEmpty($LOCKBOX_MASTER_KEY)) {
    $LOCKBOX_MASTER_KEY = (New-Guid).Guid.Replace("-","") + (New-Guid).Guid.Substring(0,16)
    Update-EnvVar "LOCKBOX_MASTER_KEY" $LOCKBOX_MASTER_KEY
    Write-Host "Generated a secure master key for the lockbox"
} else {
    Write-Host "The lockbox master key already exists."
}

# SECRET_KEY_BASE
$SECRET_KEY_BASE = Get-EnvVar "SECRET_KEY_BASE"
if ([string]::IsNullOrEmpty($SECRET_KEY_BASE)) {
    $SECRET_KEY_BASE = (New-Guid).Guid.Replace("-","") + (New-Guid).Guid.Replace("-","")
    Update-EnvVar "SECRET_KEY_BASE" $SECRET_KEY_BASE
    Write-Host "Generated a secret key for secure operations."
} else {
    Write-Host "The secret key base is already in place."
}

# PGRST_JWT_SECRET
$PGRST_JWT_SECRET = Get-EnvVar "PGRST_JWT_SECRET"
if ([string]::IsNullOrEmpty($PGRST_JWT_SECRET)) {
    $PGRST_JWT_SECRET = (New-Guid).Guid.Replace("-","") + (New-Guid).Guid.Substring(0,16)
    Update-EnvVar "PGRST_JWT_SECRET" $PGRST_JWT_SECRET
    Write-Host "Generated a unique secret for PGRST JWT secret authentication."
} else {
    Write-Host "The PGRST JWT secret is already generated and in place."
}

# PG_PASS and TOOLJET_DB_PASS
$PG_PASS = Get-EnvVar "PG_PASS"
$TOOLJET_DB_PASS = Get-EnvVar "TOOLJET_DB_PASS"
if ([string]::IsNullOrEmpty($PG_PASS) -and [string]::IsNullOrEmpty($TOOLJET_DB_PASS)) {
    $user_input = Read-Host "Enter password for Postgresql database (Press Enter to generate a random password)"
    if ([string]::IsNullOrEmpty($user_input)) {
        $PASSWORD = [System.Web.Security.Membership]::GeneratePassword(16,2)
        Write-Host "Auto-generated password for Postgresql database: $PASSWORD"
    } else {
        $PASSWORD = $user_input
        Write-Host "Password for Postgresql database successfully added"
    }
    Update-EnvVar "PG_PASS" $PASSWORD
    Update-EnvVar "TOOLJET_DB_PASS" $PASSWORD
} else {
    Write-Host "Postgres password already exists"
    $PASSWORD = $PG_PASS
}

# PGRST_DB_URI
$PGRST_DB_URI = Get-EnvVar "PGRST_DB_URI"
if ([string]::IsNullOrEmpty($PGRST_DB_URI)) {
    $PGRST_DB_URI = "postgres://postgres:$PASSWORD@postgresql/tooljet_db"
    Update-EnvVar "PGRST_DB_URI" $PGRST_DB_URI
    Write-Host "Successfully updated PGRST database URI"
} else {
    Write-Host "The PGRST DB URI is already configured and in use."
}
