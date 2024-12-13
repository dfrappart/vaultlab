# Enable rdp

Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Enable openssh

# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

#Get-NetFirewallRule -DisplayName ssh
#Stop-Service -Name OpenSSHd
#Start-Service -Name sshd
#Set-Service -Name OpenSSHd -StartupType Disabled  # (or Manual)
Set-Service -Name sshd -StartupType Automatic

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

# Install chocolatey & package
#

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install notepadplusplus openssl bat vim -y

#Install AD DS
#Add-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -IncludeAllSubFeature
#Add-WindowsFeature -Name DNS -IncludeManagementTools -IncludeAllSubFeature
#Add-WindowsFeature -Name RSAT-AD-Tools -IncludeManagementTools -IncludeAllSubFeature -Restart
#$CreateDnsDelegation = $false
#$DomainName = "vaultdemo.infra"
#$NetbiosName = "VAULT"
#$NTDSPath = "C:\Windows\NTDS"
#$LogPath = "C:\Windows\NTDS"
#$SysvolPath = "C:\Windows\SYSVOL"
#$DomainMode = "Default"
#$InstallDNS = $true
#$ForestMode = "Default"
#$NoRebootOnCompletion = $false
#$SafeModeClearPassword = "5d!fkyHRxn#o"
#$SafeModeAdministratorPassword = ConvertTo-SecureString $SafeModeClearPassword -AsPlaintext -Force
#Install-ADDSForest -CreateDnsDelegation:$CreateDnsDelegation -DomainName $DomainName -DatabasePath $NTDSPath -DomainMode $DomainMode -DomainNetbiosName $NetbiosName -ForestMode $ForestMode -InstallDNS:$InstallDNS -LogPath $LogPath -NoRebootOnCompletion:$NoRebootOnCompletion -SysvolPath $SysvolPath -SafeModeAdministratorPassword $SafeModeAdministratorPassword -Force:$true
