# Changing-your-AD-Password-Using-the-Clipboard
Let me know if this scenario is familiar?

You are working in a customer's AD domain
You only have access to a member workstation
Your account doesn't have Domain Admin rights
Your account does not have Local Admin rights on the workstation you are connected to.
You want to use a long, complex password
... aaand Microsoft won't allow you to paste a password into their GUI "password change".  Apparantly Microsoft wants us to continue to use passwords like "Passw0rd1!" and "Winter2021!" forever, until all AD domains are "passwordless"
If you are in this boat, you might think - great, I can't paste into the GUI, but how about "net user"?  Sadly, you need local or domain admin to change passwords using this command (see the list above).  If you try to change your own password using "net user", you'll end up with an "access denied" error.

OK, we still have PowerShell though, I can use the AD module there!  Except, sadly, you don't have local Admin rights so you can't install a new Powershell module.

What to do?  Happily you can still use PowerShell to get the job done, but we'll use ADSI to rescue the situation.  This script will do the job:

$oldpw = "existingoldpassword"
$newpw = "somenewpassword"
$user = $env:username
$domain = $env:userdomain
$user = [adsi]"WinNT://$domain/$user"
$user.ChangePassword($oldpw, $newpw)

If you use this approach, for goodness sake please don't save this script with your old and passwords in it!  

This second script will at least ask you for the passwords - and you can paste them into the input fields.  This still isn't great as the passwords are still in clear text as variables, but at least when you exit PowerShell they'll cease to be easily retrievable (unless someone collects a memory image of your workstation that is).  As a nice bonus, I cleared the clipboard in this one (from my diary last year https://isc.sans.edu/forums/diary/Whats+in+Your+Clipboard+Pillaging+and+Protecting+the+Clipboard/26556/ )

happl
$oldpw = read-host -prompt "Enter your existing password"
$newpw = read-host -prompt "Enter your new password"
$user = $env:username
$domain = $env:userdomain
$user = [adsi]"WinNT://$domain/$user"
$user.ChangePassword($oldpw, $newpw)

# Overwrite the password variables (I know that this doesn't really over-write)
# also clear the clipboard
$oldpw = "*" * 50
$newpw = "*" * 50
Set-Clipboard $null

This script has done the job for me so far - I can use a long, complex (AKA un-type-able) password, paste into the input fields, and still have my password change intervals match my clients' policies.  If you have a more elegant solution by all means post to our comment section below, this is a common enough situation that improving this would be a welcome thing for lots of us!

Or if you are reading this Microsoft (whichever manager that thought "disabling paste will make this waaay more secure"), letting us paste into the password change fields would make this detour unneccessary, and it would improve account security for lots (and lots) of us!  I use Windows Hello (using my fingerprint) to login to my laptop, but sadly, even though AD has started the "passwordless" journey, realistically AD passwords aren't going anywhere anytime soon - even "passwordless" shops are going to need some passwords for some situations for years to come.
