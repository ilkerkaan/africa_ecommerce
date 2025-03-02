Write-Host "Starting Phoenix server with verbose output..." -ForegroundColor Cyan

try {
    # Update dependencies if needed
    Write-Host "Updating dependencies..." -ForegroundColor Yellow
    mix deps.get
    
    # Clean the build and recompile
    Write-Host "Cleaning build and recompiling..." -ForegroundColor Yellow
    Remove-Item -Path "./_build" -Recurse -Force -ErrorAction SilentlyContinue
    
    # Create and migrate the database if needed
    Write-Host "Setting up database..." -ForegroundColor Yellow
    mix ecto.setup
    
    # Start Phoenix server with output redirection to capture any error
    Write-Host "Starting Phoenix server on port 4000..." -ForegroundColor Green
    Write-Host "Visit http://localhost:4000 in your browser once server is ready" -ForegroundColor Green
    
    $output = mix phx.server 2>&1
    Write-Host $output
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
