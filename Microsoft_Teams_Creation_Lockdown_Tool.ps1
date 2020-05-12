
<# 
.Synopsis 
 	The purpose of this tool is to give you an easy graphical method of locking down Office 365 
	(and therefore Teams) creation to only Global Admins or a single group. By default, members 
	of the Global Administrators and other administraive groups will always have the ability to
	create groups.  For any other security group chosen, an Active Directory P1 license will be 
	required for the functionality.
 
.DESCRIPTION 
   PowerShell GUI script which allows for GUI management of Office 365 Group creation lockdown
 
.Notes 
 NAME:  Microsoft_Teams_Creation_Lockdown_Tool.ps1
 VERSION:   1.0
 AUTHOR:C. Anthony Caragol 
 LASTEDIT:  03/14/2019 
  
   V 1.0 - March 15th 2019 - Initial release 
	
.Link 
   Website: http://www.teamsadmin.com
   Twitter: http://www.twitter.com/canthonycaragol
   LinkedIn: http://www.linkedin.com/in/canthonycaragol
 
.EXAMPLE 
   .\Microsoft_Teams_Creation_Lockdown_Tool.ps1

.TODO

.APOLOGY
  Please excuse the sloppy coding, I don't use a development environment, IDE or ISE.  I use notepad, 
  not even Notepad++, just notepad.  I am not a developer, just an enthusiast so some code may be redundant or
  inefficient.
#>

$Global:TeamsAdminIcon = [System.Convert]::FromBase64String('
AAABAAEAJiEAAAEACABYCgAAFgAAACgAAAAmAAAAQgAAAAEACAAAAAAAKAUAAAAAAAAAAAAAAAEAAAAB
AAAAAAAAMwAAAGYAAACZAAAAzAAAAP8AAAAAKwAAMysAAGYrAACZKwAAzCsAAP8rAAAAVQAAM1UAAGZV
AACZVQAAzFUAAP9VAAAAgAAAM4AAAGaAAACZgAAAzIAAAP+AAAAAqgAAM6oAAGaqAACZqgAAzKoAAP+q
AAAA1QAAM9UAAGbVAACZ1QAAzNUAAP/VAAAA/wAAM/8AAGb/AACZ/wAAzP8AAP//AAAAADMAMwAzAGYA
MwCZADMAzAAzAP8AMwAAKzMAMyszAGYrMwCZKzMAzCszAP8rMwAAVTMAM1UzAGZVMwCZVTMAzFUzAP9V
MwAAgDMAM4AzAGaAMwCZgDMAzIAzAP+AMwAAqjMAM6ozAGaqMwCZqjMAzKozAP+qMwAA1TMAM9UzAGbV
MwCZ1TMAzNUzAP/VMwAA/zMAM/8zAGb/MwCZ/zMAzP8zAP//MwAAAGYAMwBmAGYAZgCZAGYAzABmAP8A
ZgAAK2YAMytmAGYrZgCZK2YAzCtmAP8rZgAAVWYAM1VmAGZVZgCZVWYAzFVmAP9VZgAAgGYAM4BmAGaA
ZgCZgGYAzIBmAP+AZgAAqmYAM6pmAGaqZgCZqmYAzKpmAP+qZgAA1WYAM9VmAGbVZgCZ1WYAzNVmAP/V
ZgAA/2YAM/9mAGb/ZgCZ/2YAzP9mAP//ZgAAAJkAMwCZAGYAmQCZAJkAzACZAP8AmQAAK5kAMyuZAGYr
mQCZK5kAzCuZAP8rmQAAVZkAM1WZAGZVmQCZVZkAzFWZAP9VmQAAgJkAM4CZAGaAmQCZgJkAzICZAP+A
mQAAqpkAM6qZAGaqmQCZqpkAzKqZAP+qmQAA1ZkAM9WZAGbVmQCZ1ZkAzNWZAP/VmQAA/5kAM/+ZAGb/
mQCZ/5kAzP+ZAP//mQAAAMwAMwDMAGYAzACZAMwAzADMAP8AzAAAK8wAMyvMAGYrzACZK8wAzCvMAP8r
zAAAVcwAM1XMAGZVzACZVcwAzFXMAP9VzAAAgMwAM4DMAGaAzACZgMwAzIDMAP+AzAAAqswAM6rMAGaq
zACZqswAzKrMAP+qzAAA1cwAM9XMAGbVzACZ1cwAzNXMAP/VzAAA/8wAM//MAGb/zACZ/8wAzP/MAP//
zAAAAP8AMwD/AGYA/wCZAP8AzAD/AP8A/wAAK/8AMyv/AGYr/wCZK/8AzCv/AP8r/wAAVf8AM1X/AGZV
/wCZVf8AzFX/AP9V/wAAgP8AM4D/AGaA/wCZgP8AzID/AP+A/wAAqv8AM6r/AGaq/wCZqv8AzKr/AP+q
/wAA1f8AM9X/AGbV/wCZ1f8AzNX/AP/V/wAA//8AM///AGb//wCZ//8AzP//AP///wAAAAAAAAAAAAAA
AAAAAAAAHB0WHRwdHRwXHRwdHRwdHB0cFx0cHRwXHRwdHRwdHB0dFh0dHB0AAB0cHRwXHB0WHRwXHB0W
HRYdHB0cFxwXHB0WHRwXHBccHRwdFh0cAAAcHRYdHB0cHRwdHB0cHRwdHB0WHRwdHB0cHRwdHB0cHRwX
HB0cHQAAHRwdHBcdFh0cFxwdFh0XHB0dHB0WHRwXHBccFxwdFh0cHRwXHB0AAB0cFxwdHB0cHR0cHR0c
HRwdHBccHR0cHR0cHR0cHR0cHRccHRwdAAAdHB0dFh0cFxwXHBccFxwdFh0cHRYdFh0cFxwdFh0WHRwd
HBccHQAAHRwXHB0cHRwdHB0cHRwdHB0WHRwdHB0cHRwdHB0cHRwdFh0dHB0AAB0cHRwXHBccHRwXHB0c
Fx0cHRwXHB0cFxwXHRYdHBccHRwdFh0cAAAdHBccHRwdHBccHRwXHB0cHRYdHB0WHRwdHB0cHRwdHRwX
HB0cHQAAHRwdd/v7+/v7+/v7+/v7mh3R+/v7+/v1HBccHRYdHB0cHRwXHB0AAB0WHSL7+/v7+/v7+/v7
+/UcTfv7+/v7+3AdHB0dFh0WHRccHRwdAAAdHB0X0fv7+/v7+/v7+/v7mh3R+/v7+/uaHRYdHB0cHRwd
HBccHQAAFh0cHU37+/v7+/v7+/v7+/Udp/v7+/v7yxwdHB0cFxwdFh0dFh0AAB0cFxwd0fv7+/v7+/v7
+/v7cB37+/v7+/tAHRYdHB0dHB0cHRwdAAAdHB0cF6f7+/v7+8oXHB0cHR0c0fv7+/v7+/v7+/vEHRwd
Fh0cHQAAHRYdHRxN+/v7+/v1HB0XHB0WHXf7+/v7+/v7+/v79BccFxwdFxwAAB0cHRwXHNH7+/v7+3Ad
HB0cHRwd+/v7+/v7+/v7+/tHHB0cHRwdAAAdFh0cHR2n+/v7+/ubHB0WHRwdHdH7+/v7+/v7+/v7xB0c
HRYdHAAAHRwdHB0cTfv7+/v79B0cHRwdFh13+/v7+/v7+/v7+/UdFh0dHB0AAB0cHRccFx37+/v7+/tw
HRwXHB0cHfv7+/v7+0YdHB0cHRwcHRwXAAAcFxwdHB0c0fv7+/v7xRYdHRwdHB3R+/v7+/v7+/v7+/vF
HRYdHAAAHRwdFh0cHXf7+/v7+/tHHB0WHRccd/v7+/v7+/v7+/v79B0cHR0AABccHRwdFh0d+/v7+/v7
mhccHRwdHE37+/v7+/v7+/v7+/UdHBccAAAdHBcdHB0cHdH7+/v7+8scHRYdHB0d0fv7+/v7+/v7+/v7
cB0cHQAAHB0cHRwdFh13+/v7+/v7ah0dHB0WHaH7+/v7+/v7+/v7+8UcHR0AAB0cFxwXHB0cHRwdFh0c
HRwdHBccHRwdHB0WHRwXHB0cHRwXHBccAAAWHRwdHB0dHB0WHRwdHRwdFh0cHRwdHRYdHB0cHR0WHRYd
HB0cHQAAHRwXHB0cFxwXHB0WHRYdFh0cFxwXHBccHRYdFh0cHRwdHBccHRwAAB0cHR0WHRwdHRwdHRwd
HB0dHB0dHB0cHR0cHR0cHRwdFxwdFxwdAAAdFh0cHRwXHB0WHRwdFh0cFxwdHBccHRYdHB0WHRwXHB0c
HRwdHAAAHB0cHRYdHB0cHRwXHB0cHRwdFh0cHRwdHBccHRwdHB0WHRwdFh0AAB0cFxwdHBccHRYdHB0W
HRwXHB0cFxwdFh0cHRYdHBccHRwXHB0cAAAcHR0cHR0cHR0cHR0cHR0cHR0cHR0cHR0cHR0cHR0cHR0c
HR0cHQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
')

Function CheckForInstalledModules
{
	$azureadpreviewmodule=Get-Module -ListAvailable -Name AzureADPreview
	if ($azureadpreviewmodule) 
	{
	} 
	else 
	{
	[Microsoft.VisualBasic.Interaction]::MsgBox("AzureADPreview module not installed, to continue, please ensure the module is installed. `r`n `r`n  Uninstall-Module AzureADPreview `r`n `r`n  Uninstall-Module AzureAD `r`n `r`n  Install-Module AzureADPreview" ,'Information', "Please install the current AzureADPreview module.")
	}
}

Function MainForm()
{
	$mainForm = New-Object System.Windows.Forms.Form 
	$mainForm.Text = "Microsoft Teams Creation Lock Down Tool"
	$mainForm.Size = New-Object System.Drawing.Size(660,560) 
	$mainForm.MinimumSize = New-Object System.Drawing.Size(660,560) 
	$mainForm.StartPosition = "CenterScreen"
	$mainForm.Add_SizeChanged($CAC_FormSizeChanged)
	$mainForm.KeyPreview = $True
	$mainForm.Icon = $Global:TeamsAdminIcon

	$LockedUnlockedLabel = New-Object System.Windows.Forms.Label
	$LockedUnlockedLabel.Location = New-Object System.Drawing.Size(10,25) 	
	$LockedUnlockedLabel.Size = New-Object System.Drawing.Size(350,20) 
	$LockedUnlockedLabel.Text = "Tenant Lockdown Status: (Please connect)"
	$LockedUnlockedLabel.Font = New-Object System.Drawing.Font("Arial", 12)
	$mainForm.Controls.Add($LockedUnlockedLabel) 

	$GroupUnlockedLabel = New-Object System.Windows.Forms.Label
	$GroupUnlockedLabel.Location = New-Object System.Drawing.Size(10,55) 
	$GroupUnlockedLabel.Size = New-Object System.Drawing.Size(330,20) 
	$GroupUnlockedLabel.Text = "Security Groups Allowed to Create Groups:"
	$GroupUnlockedLabel.Font = New-Object System.Drawing.Font("Arial", 12)
	$mainForm.Controls.Add($GroupUnlockedLabel) 

	$GroupUnlockedCombo = New-Object System.Windows.Forms.ComboBox
	$GroupUnlockedCombo.Location = New-Object System.Drawing.Size(340,55) 
	$GroupUnlockedCombo.Size = New-Object System.Drawing.Size(250,20) 
	[void]$GroupUnlockedCombo.Items.add("Please connect")
	$GroupUnlockedCombo.selectedindex=0
	$GroupUnlockedCombo.Font = New-Object System.Drawing.Font("Arial", 12)
	$mainForm.Controls.Add($GroupUnlockedCombo) 

	$TitleLabel = New-Object System.Windows.Forms.Label
	$TitleLabel.Location = New-Object System.Drawing.Size(10,100) 
	$TitleLabel.Size = New-Object System.Drawing.Size(600,90) 
	$TitleLabel.Font = New-Object System.Drawing.Font("Arial", 12)
	$TitleLabel.Text = "The purpose of this tool is to give you an easy graphical method of locking down Office 365 (and therefore Teams) creation to only Global Admins or a single group.  By default, members of the Global Administrators and other administraive groups will always have the ability to create groups.  For any other security group chosen, an Active Directory P1 license will be required for the functionality."
	$mainForm.Controls.Add($TitleLabel) 

	#TeamsAdmin LinkLabel
	$MicrosoftLinkLabel = New-Object System.Windows.Forms.LinkLabel
	$MicrosoftLinkLabel.Location = New-Object System.Drawing.Size(10,210) 
	$MicrosoftLinkLabel.Size = New-Object System.Drawing.Size(400,25)
	$MicrosoftLinkLabel.text = "Microsoft Source Documentation"
	$MicrosoftLinkLabel.Font = New-Object System.Drawing.Font("Arial", 12)
	$MicrosoftLinkLabel.add_Click({Start-Process "https://docs.microsoft.com/en-us/office365/admin/create-groups/manage-creation-of-groups?view=o365-worldwide"})
	$mainForm.Controls.Add($MicrosoftLinkLabel)

	$ConnectTenantButton = New-Object System.Windows.Forms.Button
	$ConnectTenantButton.Location = New-Object System.Drawing.Size((10 + (($mainForm.width-50) /7 * 0) ),($mainForm.height - 110))
	$ConnectTenantButton.Size = New-Object System.Drawing.Size(150,45)
	$ConnectTenantButton.Text = "Connect to Tenant"
	$ConnectTenantButton.Font = New-Object System.Drawing.Font("Arial", 12)
	$ConnectTenantButton.Add_Click({
		$global:connected=Connect-AzureAD
		$SecurityGroups=Get-AzureADGroup | where {$_.securityenabled -eq $true}
		$GroupUnlockedCombo.Items.Clear()
		$GroupUnlockedCombo.Items.Add("<Admins Only>")
		foreach ($SecurityGroup in $SecurityGroups) { $GroupUnlockedCombo.Items.Add($SecurityGroup.displayname)}
		$GroupUnlockedCombo.selectedindex=0

		$settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
		if(!$settingsObjectID)
		{
	 		$template = Get-AzureADDirectorySettingTemplate | Where-object {$_.displayname -eq "group.unified"}
			$settingsCopy = $template.CreateDirectorySetting()
	  		New-AzureADDirectorySetting -DirectorySetting $settingsCopy
			$settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
		}

		$Unlocked=(((Get-AzureADDirectorySetting -Id $settingsObjectID).Values)|where {$_.name -like "EnableGroupCreation"}).value
		$AllowedGroupId=(((Get-AzureADDirectorySetting -Id $settingsObjectID).Values)|where {$_.name -like "GroupCreationAllowedGroupId"}).value

		if ($Unlocked -eq $true) 
		{
			$LockedUnlockedLabel.Text = "Tenant Lockdown Status: Unlocked"
			$groupUnlockedCombo.text="<Admins Only>"
		}
		else 
		{
			$LockedUnlockedLabel.Text = "Tenant Lockdown Status: Locked"
			if ($AllowedGroupId -ne $null) 
			{
				$selectedgroupname="<Admins Only>"
				foreach ($SecurityGroup in $SecurityGroups) { if ($SecurityGroup.objectID -eq $AllowedGroupID) {$SelectedGroupName=$SecurityGroup.displayname} }
				$GroupUnlockedCombo.text=$selectedgroupname
			}
		}

		$GroupUnlockedLabel.Text = "Security Groups Allowed to Create Groups: "
		$settingsCopy = Get-AzureADDirectorySetting -Id $settingsObjectID
	})
	$ConnectTenantButton.Anchor = 'Bottom, Left'
	$mainForm.Controls.Add($ConnectTenantButton)

	$UnlockButton = New-Object System.Windows.Forms.Button
	$UnlockButton.Location = New-Object System.Drawing.Size((165 + (($mainForm.width-50) /7 * 0) ),($mainForm.height - 110))
	$UnlockButton.Size = New-Object System.Drawing.Size(150,45)
	$UnlockButton.Text = "Unlock Creation for All"
	$UnlockButton.Font = New-Object System.Drawing.Font("Arial", 12)
	$UnlockButton.Add_Click({
		if ($global:connected)
		{
			$AllowGroupCreation = "True"
			$settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
			if(!$settingsObjectID)
			{
	  			$template = Get-AzureADDirectorySettingTemplate | Where-object {$_.displayname -eq "group.unified"}
   	  			$settingsCopy = $template.CreateDirectorySetting()
				New-AzureADDirectorySetting -DirectorySetting $settingsCopy
				$settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
			}
			$settingsCopy = Get-AzureADDirectorySetting -Id $settingsObjectID
			$settingsCopy["EnableGroupCreation"] = $AllowGroupCreation
			Set-AzureADDirectorySetting -Id $settingsObjectID -DirectorySetting $settingsCopy
			$LockedUnlockedLabel.Text = "Tenant Lockdown Status: Unlocked"
			$groupUnlockedCombo.text="<Admins Only>"
		}
		else
		{
			[Microsoft.VisualBasic.Interaction]::MsgBox("You are not connected to Azure AD.  To continue, please click the Connect to Tenant button." ,'Information', "Please connect to Azure AD.")
		}
	})
	$UnlockButton.Anchor = 'Bottom, Left'
	$mainForm.Controls.Add($UnlockButton)

	$LockButton = New-Object System.Windows.Forms.Button
	$LockButton.Location = New-Object System.Drawing.Size((320 + (($mainForm.width-50) /7 * 0) ),($mainForm.height - 110))
	$LockButton.Size = New-Object System.Drawing.Size(150,45)
	$LockButton.Text = "Lock Creation to Group"
	$LockButton.Font = New-Object System.Drawing.Font("Arial", 12)
	$LockButton.Add_Click({
		if ($global:connected)
		{
			$GroupName = $GroupUnlockedCombo.text
			if ($GroupName -eq "<Admins Only>") { $GroupName = $null}
			$AllowGroupCreation = "False"
			$settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
			if(!$settingsObjectID)
			{
				$template = Get-AzureADDirectorySettingTemplate | Where-object {$_.displayname -eq "group.unified"}
				$settingsCopy = $template.CreateDirectorySetting()
				New-AzureADDirectorySetting -DirectorySetting $settingsCopy
				$settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
			}
			$settingsCopy = Get-AzureADDirectorySetting -Id $settingsObjectID
			$settingsCopy["EnableGroupCreation"] = $AllowGroupCreation
			if($GroupName)
			{
				$settingsCopy["GroupCreationAllowedGroupId"] = (Get-AzureADGroup -SearchString $GroupName).objectid
			}
			else
			{
				$settingsCopy["GroupCreationAllowedGroupId"] = $null
			}
			Set-AzureADDirectorySetting -Id $settingsObjectID -DirectorySetting $settingsCopy
			$LockedUnlockedLabel.Text = "Tenant Lockdown Status: Locked"
		}
		else
		{
			[Microsoft.VisualBasic.Interaction]::MsgBox("You are not connected to Azure AD.  To continue, please click the Connect to Tenant button." ,'Information', "Please connect to Azure AD.")

		}
	})
	$LockButton.Anchor = 'Bottom, Left'
	$mainForm.Controls.Add($LockButton)

	$CancelButton = New-Object System.Windows.Forms.Button
	$CancelButton.Location = New-Object System.Drawing.Size((480 + (($mainForm.width-50) /7 * 0) ),($mainForm.height - 110))
	$CancelButton.Size = New-Object System.Drawing.Size(150,45)
	$CancelButton.Text = "Quit"
	$CancelButton.Font = New-Object System.Drawing.Font("Arial", 12)
	$CancelButton.Add_Click({
		$mainForm.Close()
		Disconnect-AzureAD
	})
	$CancelButton.Anchor = 'Bottom, Left'
	$mainForm.Controls.Add($CancelButton)

	#TeamsAdmin LinkLabel
	$TeamsAdminLinkLabel = New-Object System.Windows.Forms.LinkLabel
	$TeamsAdminLinkLabel.Location = New-Object System.Drawing.Size(10,($mainForm.height - 60)) 
	$TeamsAdminLinkLabel.Size = New-Object System.Drawing.Size(200,20)
	$TeamsAdminLinkLabel.text = "http://www.TeamsAdmin.com"
	$TeamsAdminLinkLabel.add_Click({Start-Process $TeamsAdminLinkLabel.text})
	$TeamsAdminLinkLabel.Anchor = 'Bottom, Left'
	$mainForm.Controls.Add($TeamsAdminLinkLabel)

	[void] $mainForm.ShowDialog()
}

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void] [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$global:connected=$null
CheckForInstalledModules
MainForm
