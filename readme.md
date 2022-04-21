# PowerShellForGitHub.Content

Lightweight addon to the [PowerShellForGitHub](https://github.com/microsoft/PowerShellForGitHub) module.
It is designed to enable easy access to repository content in a format useful to the [PSAzureMigrationAdvisor](https://github.com/FriedrichWeinmann/PSAzureMigrationAdvisor) module.

## Installation

```powershell
Install-Module 'PowerShellForGitHub.Content' -Scope CurrentUser
```

## Use

Retrieve all PowerShell script files from _all_ repositories under FriedrichWeinmann

```powershell
Get-GithubRepositoryFile -Organization FriedrichWeinmann -Name *.ps1,*psm1
```

## Note

In order to avoid throttling issues, make sure to authenticate first following the guidance on [PowerShellForGitHub](https://github.com/microsoft/PowerShellForGitHub).
