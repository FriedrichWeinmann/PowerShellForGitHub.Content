function Get-GithubRepositoryFile {
	<#
	.SYNOPSIS
		Search an organization's repositories for files.
	
	.DESCRIPTION
		Search an organization's repositories for files.
		Includes file-content.
	
	.PARAMETER Organization
		The Organization or private account to search.
	
	.PARAMETER Repository
		Filter by repository name.
		Defaults to '*'
	
	.PARAMETER Branch
		Filter by branch name.
		Defaults to '*'
	
	.PARAMETER Name
		Filter by filename.
		Defaults to '*'
	
	.EXAMPLE
		PS C:\> Get-GithubRepositoryFile -Organization FriedrichWeinmann -Name *.ps1,*psm1

		Search all github projects maintained directly by Friedrich Weinmann and download all ps1 and psm1 files from all branches of them all.
		Hint: This may take a while and will return loooots of data ;)
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Organization,

		[string[]]
		$Repository = '*',

		[string[]]
		$Branch = '*',

		[string[]]
		$Name = '*'
	)

	process {
		Get-GitHubRepository -OwnerName $Organization | Where-Object {
			Test-Overlap -Value $_.Name -Filter $Repository
		} | Get-GitHubRepositoryBranch | Where-Object {
			Test-Overlap -Value $_.Name -Filter $Branch
		} | Get-GithubTree | Where-Object {
			Test-Overlap -Value $_.Name -Filter $Name
		} | Get-GithubFileData
	}
}