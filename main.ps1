# Bypass PowerShell Execution Policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# ASCII Art Stored in a Variable
$asciiArt = @"
             _             
            | |            
            | |===( )   ////// 
            |_|   |||  | o o| 
                   ||| ( c  )                  ____ 
                    ||| \= /                  ||   \_
                     ||||||                   ||     |
                     ||||||                ...||__/|-"
                     ||||||             __|________|__ 
                       |||             |______________| 
                       |||             || ||      || || 
                       |||             || ||      || || Made by @jibay442
-----------------------|||-------------||-||------||-||-------
                       |__>            || ||      || || 

"@

# Display the ASCII Art
Write-Host $asciiArt

# Define installation choices
$installationChoices = @{
    1 = @{ Name = "Install Choco"; Scripts = @(
        { Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) }
    ) };
    2 = @{ Name = "Default Installation"; Scripts = @(
        { choco install adobereader -y },
        { choco install googlechrome -y },
        { choco install firefox -y },
        { choco install vcredist140 -y },
        { choco install zoom -y },
        { choco install microsoft-teams.install -y },
        { choco install 7zip.install -y },
        { choco install notepadplusplus.install -y },
        { choco install teamviewer -y },
        { choco install vlc -y },
        { choco install foxitreader -y }
    ) };
    3 = @{ Name = "Bitdefender"; Scripts = @(
        {
            # Prompt user for Bitdefender URL
            $url = Read-Host "Please enter the Bitdefender download URL"
            if (-not $url) {
                Write-Error "No URL provided. Canceling Bitdefender installation."
                return
            }

            # Extract installation ID from URL if needed
            $idInstall = ($url -split { $_ -eq '[' -or $_ -eq ']' })[1]
            Write-Host "Installation ID: $idInstall"

            # Download BitDefender
            Write-Host "Downloading BitDefender..."
            Invoke-WebRequest -Uri $url -OutFile "$env:PUBLIC\Downloads\setup_bd.msi"

            # Install BitDefender
            Start-Process -FilePath "c:\windows\system32\msiexec.exe" -ArgumentList "/i $env:PUBLIC\Downloads\setup_bd.msi /qn GZ_PACKAGE_ID=$idInstall REBOOT_IF_NEEDED=0" -Wait
            Write-Host "BitDefender installation complete."
        }
    ) };
    4 = @{ Name = "Atera"; Scripts = @(
        {
            # Atera installation
            $ftpUrl = "ftp://ftp.aveliis.fr/@veliis/images/setup_aveliis_jb.msi"
            $publicDownloadsPath = Join-Path -Path "C:\Users\Public\Downloads" -ChildPath "setup_aveliis_jb.msi"

            try {
                Write-Host "Downloading the file from $ftpUrl to $publicDownloadsPath..." -ForegroundColor Yellow
                $webClient = New-Object System.Net.WebClient
                $webClient.DownloadFile($ftpUrl, $publicDownloadsPath)
                Write-Host "File downloaded successfully to $publicDownloadsPath" -ForegroundColor Green

                # Execute the MSI installer silently
                Write-Host "Launching the installer silently..." -ForegroundColor Yellow
                Start-Process -FilePath $publicDownloadsPath -Wait
                Write-Host "Atera installation complete."

            } catch {
                Write-Host "An error occurred during the download or installation." -ForegroundColor Red
            }
        }
    ) };
    5 = @{ Name = "Office 365"; Scripts = @(
        { Invoke-WebRequest -Uri "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365BusinessRetail&platform=x64&language=en-us&version=O16GA" -OutFile "$env:TEMP\Office365Setup.exe" },
        { Start-Process "$env:TEMP\Office365Setup.exe" -Wait }
    ) };
    6 = @{ Name = "Office 2021"; Scripts = @(
        { Invoke-WebRequest -Uri "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=ProPlus2021Retail&platform=x64&language=en-us&version=O16GA" -OutFile "$env:TEMP\Office2021Setup.exe" },
        { Start-Process "$env:TEMP\Office2021Setup.exe" -Wait }
    ) };
    7 = @{ Name = "Cely Installation"; Scripts = @(
        {
            # Define the FTP address of the file
            $ftpUrl = "ftp://ftp.aveliis.fr/@veliis/images/cely.exe"

            # Define the Public Downloads folder path for the file
            $publicDownloadsPath = Join-Path -Path "C:\Users\Public\Downloads" -ChildPath "cely.exe"

            # Download the file from the FTP address to the Public Downloads folder
            try {
                Write-Host "Downloading the file from $ftpUrl to $publicDownloadsPath..." -ForegroundColor Yellow
                $webClient = New-Object System.Net.WebClient
                $webClient.DownloadFile($ftpUrl, $publicDownloadsPath)
                Write-Host "File downloaded successfully to $publicDownloadsPath" -ForegroundColor Green

                # Execute the file silently in the background
                Write-Host "Launching the installer silently..." -ForegroundColor Yellow
                $process = Start-Process -FilePath $publicDownloadsPath -ArgumentList " /norestart"
                $process.WaitForExit()
            } catch {
                Write-Host "An error occurred during the download or installation." -ForegroundColor Red
            }
        }
    ) };
8 = @{
    Name = "Default Tweaks"
    Scripts = @(
        {
            # Remove GameDVR registry entry
            New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InprocServer32" -force -value ""
            Write-Host "Restarting explorer.exe ..."
            
            # Stop explorer.exe
            $process = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
            if ($process) {
                Stop-Process -InputObject $process
                Write-Host "Explorer stopped."
            } else {
                Write-Host "Explorer was not running."
            }

            # Wait for a moment to ensure explorer has been stopped
            Start-Sleep -Seconds 2

            # Restart explorer.exe
            Start-Process "explorer.exe"
            Write-Host "Explorer restarted."
        },
        {
            # Disable GameDVR
            $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Gaming"
            if (Test-Path $regPath) {
                $key = "AllowGameDVR"
                if (Test-Path "$regPath\$key") {
                    Remove-Item "$regPath\$key" -Force
                    Write-Host "GameDVR disabled."
                } else {
                    Write-Host "GameDVR key not found."
                }
            } else {
                Write-Host "Gaming registry path not found."
            }
        },
        {
            # Restore Windows 10 right-click menu
            $regPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
            $defaultContextMenu = @{
                "System.IsPinnedToTaskbar" = ""
                "System.HasOverlayIcon" = ""
                "System.IsShared" = ""
                "System.IsShortcut" = ""
                "System.Document" = ""
            }

            foreach ($key in $defaultContextMenu.Keys) {
                if (Test-Path "$regPath\$key") {
                    Remove-Item "$regPath\$key" -Force
                    Write-Host "Restored $key in Windows 10 right-click menu."
                } else {
                    Write-Host "$key not found in Windows 10 context menu."
                }
            }

            # Restart explorer.exe after changes
            Write-Host "Restarting explorer.exe ..."
            $process = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
            if ($process) {
                Stop-Process -InputObject $process
                Write-Host "Explorer stopped."
            } else {
                Write-Host "Explorer was not running."
            }

            # Wait for a moment to ensure explorer has been stopped
            Start-Sleep -Seconds 2

            # Restart explorer.exe
            Start-Process "explorer.exe"
            Write-Host "Explorer restarted."
        }
    )
}

9 = @{ Name = "Exit"; Scripts = @() };

10 = @{ Name = "Microsoft Activation Scripts (MAS)"; Scripts = @(
    {
        Write-Host "Downloading and running activation script..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex (irm "https://get.activated.win")
    }
) };

11 = @{ Name = "Chris Titus Tech's Windows Utility"; Scripts = @(
    {
        Write-Host "Downloading and running Winituls..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex (irm "https://christitus.com/win")
    }
) };
}

# Display menu options
Write-Host "Select an installation option:"
foreach ($key in $installationChoices.Keys) {
    Write-Host "[$key] $($installationChoices[$key].Name)"
}

# Get user selection
$selections = Read-Host "Enter your choices separated by commas (e.g., 1,3,5,8)"
$selectedKeys = $selections -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $installationChoices.ContainsKey([int]$_) }
if (-not $selectedKeys) {
    Write-Error "No valid choice. Exiting script."
    exit
}

# Execute the selected scripts one by one
foreach ($key in $selectedKeys) {
    if ($key -eq 9) {
        Write-Host "Exiting script..."
        exit
    }
    Write-Host "Executing installation for $($installationChoices[[int]$key].Name) ..."
    foreach ($script in $installationChoices[[int]$key].Scripts) {
        try {
            $script.Invoke()
            Write-Host "Step completed successfully." -ForegroundColor Green
        } catch {
            Write-Error "Error executing a step: $_"
        }
    }
}

Write-Host "All operations are complete."
