
function addUser {
Write-host 'input password'
$Password = Read-Host -AsSecureString
Write-host 'input user name'
$User = Read-Host
New-LocalUser $User -Password $Password
Add-LocalGroupMember -Group "Users" -Member $User
}
adduser