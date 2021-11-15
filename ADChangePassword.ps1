$oldpw = "existingoldpassword"
$newpw = "somenewpassword"
$user = $env:username
$domain = $env:userdomain
$user = [adsi]"WinNT://$domain/$user"
$user.ChangePassword($oldpw, $newpw)

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
