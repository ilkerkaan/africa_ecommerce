# PostgreSQL Database Tools Script
# This script provides functions for common database operations

# Database credentials
$PG_USER = "postgres"
$PG_PASSWORD = "postgres"
$PG_HOST = "localhost"
$PG_PORT = "5432"
$PG_DB = "dukkadee_dev"
$PG_TEST_DB = "dukkadee_test"

# Add PostgreSQL bin directory to PATH
$env:Path += ";C:\Program Files\PostgreSQL\15\bin"
$env:PGPASSWORD = $PG_PASSWORD
$env:PAGER = "more"

# Function to run a SQL query
function Run-Query {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Query,
        
        [Parameter(Mandatory=$false)]
        [string]$Database = $PG_DB
    )
    
    Write-Host "Running query on $Database..." -ForegroundColor Yellow
    $result = psql -U $PG_USER -h $PG_HOST -p $PG_PORT -d $Database -c $Query
    return $result
}

# Function to run a SQL file
function Run-SqlFile {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$false)]
        [string]$Database = $PG_DB
    )
    
    Write-Host "Running SQL file $FilePath on $Database..." -ForegroundColor Yellow
    $result = psql -U $PG_USER -h $PG_HOST -p $PG_PORT -d $Database -f $FilePath
    return $result
}

# Function to list all tables in the database
function List-Tables {
    param (
        [Parameter(Mandatory=$false)]
        [string]$Database = $PG_DB
    )
    
    Write-Host "Listing tables in $Database..." -ForegroundColor Yellow
    $query = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;"
    $result = Run-Query -Query $query -Database $Database
    return $result
}

# Function to describe a table
function Describe-Table {
    param (
        [Parameter(Mandatory=$true)]
        [string]$TableName,
        
        [Parameter(Mandatory=$false)]
        [string]$Database = $PG_DB
    )
    
    Write-Host "Describing table $TableName in $Database..." -ForegroundColor Yellow
    $query = "SELECT column_name, data_type, is_nullable, column_default FROM information_schema.columns WHERE table_name = '$TableName' ORDER BY ordinal_position;"
    $result = Run-Query -Query $query -Database $Database
    return $result
}

# Function to count records in a table
function Count-Records {
    param (
        [Parameter(Mandatory=$true)]
        [string]$TableName,
        
        [Parameter(Mandatory=$false)]
        [string]$Database = $PG_DB
    )
    
    Write-Host "Counting records in $TableName in $Database..." -ForegroundColor Yellow
    $query = "SELECT COUNT(*) FROM $TableName;"
    $result = Run-Query -Query $query -Database $Database
    return $result
}

# Function to view records in a table
function View-Records {
    param (
        [Parameter(Mandatory=$true)]
        [string]$TableName,
        
        [Parameter(Mandatory=$false)]
        [int]$Limit = 10,
        
        [Parameter(Mandatory=$false)]
        [string]$Database = $PG_DB
    )
    
    Write-Host "Viewing records in $TableName in $Database..." -ForegroundColor Yellow
    $query = "SELECT * FROM $TableName LIMIT $Limit;"
    $result = Run-Query -Query $query -Database $Database
    return $result
}

# Display available commands
Write-Host "PostgreSQL Database Tools" -ForegroundColor Green
Write-Host "------------------------" -ForegroundColor Green
Write-Host "Available commands:" -ForegroundColor Yellow
Write-Host "  Run-Query -Query 'SELECT * FROM users;'" -ForegroundColor Cyan
Write-Host "  Run-SqlFile -FilePath './my_script.sql'" -ForegroundColor Cyan
Write-Host "  List-Tables" -ForegroundColor Cyan
Write-Host "  Describe-Table -TableName 'users'" -ForegroundColor Cyan
Write-Host "  Count-Records -TableName 'users'" -ForegroundColor Cyan
Write-Host "  View-Records -TableName 'users' -Limit 5" -ForegroundColor Cyan
Write-Host ""
Write-Host "Example usage:" -ForegroundColor Yellow
Write-Host "  . .\db_tools.ps1" -ForegroundColor Cyan
Write-Host "  List-Tables" -ForegroundColor Cyan
Write-Host ""

# Test connection
Write-Host "Testing database connection..." -ForegroundColor Yellow
try {
    $testResult = psql -U $PG_USER -h $PG_HOST -p $PG_PORT -d $PG_DB -c "SELECT 1 as connection_test;"
    Write-Host "Database connection successful!" -ForegroundColor Green
} catch {
    Write-Host "Database connection failed: $_" -ForegroundColor Red
}
