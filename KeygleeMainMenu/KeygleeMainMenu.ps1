
# Get-NetAdapter -Name '*' | Format-Table -Property Name, Status
# $adapters = Get-NetAdapter -Name '*' | Where-Object { ($_.Status -eq 'Disconnected') -or ($_.Status -eq '*Present') }
# Write-Host $adapters.Name
# Write-Host $adapters.Status
# update-help -Module $module

function MainMenu {
    Clear-Host
    Write-Color "===================== Choose your Menu =====================" -Color Green
    Write-Color "1: Press '1' for Menu 1" -Color Green
    Write-Color "2: Press '2' for Menu 2" -Color Green
    Write-Color "3: Press '3' for Windows Update" -Color Green
    Write-Color "4: Press '4' for Run Choco update & Clean Chocolatey Files" -Color Green
    Write-Color "Q: Press 'Q' to quit." -Color Green
}       
function NetworkMenu {
    Clear-Host
    Write-Color "=============== Choose your Network Settings ===============" -Color Green
    Write-Color "1: Press '1' to set Ethernet ON" -Color Green
    Write-Color "2: Press '2' to set Wi-Fi ON" -Color Green
    Write-Color "3: Press '3' to set VPN ON" -Color Green
    Write-Color "4: Press '4' to set All OFF" -Color Green
    Write-Color "5: Press '5' to check internet connection" -Color Green
    Write-Color "Q: Press 'Q' to quit." -Color Green
}       
function TurnEthernetON {
    Write-Host `n
    Write-Host "Turning Ehternet ON ..."
    Get-NetAdapter -Name '*' | Restart-NetAdapter -Confirm:$false
    Get-NetAdapter -Name '*' | Disable-NetAdapter -Confirm:$false
    Get-NetAdapter -Name 'Ethernet' | Enable-NetAdapter -Confirm:$false
}
function TurnWiFiON {
    Write-Host `n
    Write-Host "Turning Wi-Fi ON ..."
    Get-NetAdapter -Name '*' | Restart-NetAdapter -Confirm:$false
    Get-NetAdapter -Name '*' | Disable-NetAdapter -Confirm:$false
    Get-NetAdapter -Name 'Wi-Fi' | Enable-NetAdapter -Confirm:$false
} 
function TurnVPNON {
    Write-Host `n
    Write-Host "Turning VPN ON ..."
    Get-NetAdapter -Name '*' | Restart-NetAdapter -Confirm:$false
    Get-NetAdapter -Name '*' | Disable-NetAdapter -Confirm:$false
    Get-NetAdapter -Name 'Ethernet' | Enable-NetAdapter -Confirm:$false
    Get-NetAdapter -Name 'Mullvad' | Enable-NetAdapter -Confirm:$false
} 
function TurnAllOff {
    Write-Host `n
    Write-Host "Turning All OFF ..."
    Get-NetAdapter -Name '*' | Disable-NetAdapter -Confirm:$false
}

function CheckInternetConnection {
    Write-Host `n
    Write-Host 'Checking Internet Conectivity ...'
    ping 77.70.93.1
}

function ShowWindowsVersion {
    Write-Host `n
    Write-Color "Showing Windows Version ..." -Color Blue
    Write-Host `n
    Write-Color 'Windows Edition' -Color Blue
    Write-Color '---------------' -Color Blue
    $productName = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
    Write-Color $productName -Color Red
    Write-Host `n
    Write-Color 'Windows Version' -Color Blue
    Write-Color '---------------' -Color Blue
    $releaseId = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId).ReleaseId
    Write-Color $releaseId -Color Red
    Write-Host `n
    Write-Color 'Current Build' -Color Blue
    Write-Color '-------------' -Color Blue
    $currentBuild = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild
    Write-Color $currentBuild -Color Red
}

function RunCupAllAndCleanChocoFiles {
    Write-Host `n
    cup all -y
    powershell -File C:\tools\BCURRAN3\choco-cleaner.ps1 
}

function WinUpdate {
    Write-Host `n
    Install-WindowsUpdate -MicrosoftUpdate -Verbose
    # Hide-WindowsUpdate -Title "Microsoft Silverlight*" -Hide -Verbose
    # Hide-WindowsUpdate -KBArticleID (put KB ID here) -Verbose
    Get-WUHistory -MaxDate (Get-Date).AddDays(-7) | Format-Table Result, Title, Date
}

do {
    MainMenu
    Write-Host `n
    $selection = Read-Host "What do you want to do?"
    If ($selection -eq 1) {
        do {
            NetworkMenu
            Write-Host `n
            $selectionSubMenu = Read-Host "What do you want to do?"
            if ($selectionSubMenu -eq 1) {
                TurnEthernetON
                Pause
            }
            if ($selectionSubMenu -eq 2) {
                TurnWiFiON
                Pause
            }
            if ($selectionSubMenu -eq 3) {
                TurnVPNON
                Pause
            }
            if ($selectionSubMenu -eq 4) {
                TurnAllOff
                Pause
            }
            if ($selectionSubMenu -eq 5) {
                CheckInternetConnection
                Write-Host `n
                Pause
            }
            Write-Host `n
        }
        until ($selectionSubMenu -eq 'q')

    }
    If ($selection -eq 2) {
        ShowWindowsVersion
        Write-Host `n
        Pause
    }
    If ($selection -eq 3) {
        WinUpdate
        Pause
    }
    If ($selection -eq 4) {
        RunCupAllAndCleanChocoFiles
        Write-Host `n
        Pause
    }
    Write-Host `n
}
until ($selection -eq 'q')
[Environment]::Exit(1)


