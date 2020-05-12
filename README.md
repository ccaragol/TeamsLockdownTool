Microsoft Teams  and Office 365 Creation Lockdown Tool
======================================================

This tool locks down the creation of Microsoft Teams and Office 365 Groups in general to a specific security group, or simply to global and other admins.  It's based upon this article: https://docs.microsoft.com/en-us/office365/admin/create-groups/manage-creation-of-groups?view=o365-worldwide

I found my clients asking for this repeatedly enough, and myself constantly going back to the same article to walk through it, that I got tired and decided to just make a simple GUI so I never have to think about it again.  I'm putting it here as I imagine others out there will find it useful.

To run it, ensure the AzureADPreview module is installed as per the article above.   Or, just simply run the following in PowerShell: Uninstall-Module AzureAD;Uninstall-Module AzureADPreview;Install-Module AzureADPreview.