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
    2 = @{ Name = "Installation par défaut"; Scripts = @(
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
            $url = Read-Host "Veuillez entrer l'URL de téléchargement de Bitdefender"
            if (-not $url) {
                Write-Error "Aucune URL fournie. Annulation de l'installation de Bitdefender."
                return
            }

            # Extract installation ID from URL if needed
            $idInstall = ($url -split { $_ -eq '[' -or $_ -eq ']' })[1]
            Write-Host "ID D'installation : $idInstall"

            # Téléchargement install BitDefender
            Write-Host "Téléchargement de BitDefender..."
            Invoke-WebRequest -Uri $url -OutFile "$env:PUBLIC\Downloads\setup_bd.msi"

            # Installation BitDefender
            Start-Process -FilePath "c:\windows\system32\msiexec.exe" -ArgumentList "/i $env:PUBLIC\Downloads\setup_bd.msi /qn GZ_PACKAGE_ID=$idInstall REBOOT_IF_NEEDED=0" -Wait
            Write-Host "Installation de BitDefender terminée."
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
                Write-Host "Installation d'Atera terminée."

            } catch {
                Write-Host "An error occurred during the download or installation." -ForegroundColor Red
            }
        }
    ) };
    5 = @{ Name = "Office 365"; Scripts = @(
        { Invoke-WebRequest -Uri "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365BusinessRetail&platform=x64&language=fr-fr&version=O16GA" -OutFile "$env:TEMP\Office365Setup.exe" },
        { Start-Process "$env:TEMP\Office365Setup.exe" -Wait }
    ) };
    6 = @{ Name = "Office 2021"; Scripts = @(
        { Invoke-WebRequest -Uri "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=ProPlus2021Retail&platform=x64&language=fr-fr&version=O16GA" -OutFile "$env:TEMP\Office2021Setup.exe" },
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
    8 = @{ Name = "Tweaks par défaut"; Scripts = @(
        {
            # Remove GameDVR registry entry
            New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InprocServer32" -force -value ""
            Write-Host Restarting explorer.exe ...
            $process = Get-Process -Name "explorer"
            Stop-Process -InputObject $process
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
            Write-Host "Restarting explorer.exe ..."
            $process = Get-Process -Name "explorer"
            Stop-Process -InputObject $process
        }
    ) };
    9 = @{ Name = "Exit"; Scripts = @() };
}

# Display menu options
Write-Host "Sélectionnez une option d'installation :"
foreach ($key in $installationChoices.Keys) {
    Write-Host "[$key] $($installationChoices[$key].Name)"
}

# Get user selection
$selections = Read-Host "Entrez vos choix séparés par des virgules (ex: 1,3,5,8)"
$selectedKeys = $selections -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $installationChoices.ContainsKey([int]$_) }
if (-not $selectedKeys) {
    Write-Error "Aucun choix valide. Fin du script."
    exit
}

# Execute the selected scripts one by one
foreach ($key in $selectedKeys) {
    if ($key -eq 9) {
        Write-Host "Exiting script..."
        exit
    }
    Write-Host "Exécution de l'installation pour $($installationChoices[[int]$key].Name) ..."
    foreach ($script in $installationChoices[[int]$key].Scripts) {
        try {
            $script.Invoke()
            Write-Host "Étape terminée avec succès." -ForegroundColor Green
        } catch {
            Write-Error "Erreur lors de l'exécution d'une étape : $_"
        }
    }
}

Write-Host "Toutes les opérations sont terminées."