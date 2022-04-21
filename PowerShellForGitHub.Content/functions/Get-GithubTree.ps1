function Get-GithubTree {
	<#
	.SYNOPSIS
		Returns a list of all files and folders in the selected branch.
	
	.DESCRIPTION
		Returns a list of all files and folders in the selected branch.
	
	.PARAMETER Owner
		The owner of the repository.
		Can be an organization or a personal account name.
	
	.PARAMETER Repository
		The name of the repository to scan.
	
	.PARAMETER RepositoryUrl
		The full link to the repository to scan
	
	.PARAMETER BranchName
		The name of the branch to scan.
	
	.EXAMPLE
		PS C:\> Get-GithubTree -Owner FriedrichWeinmann -Repository PowerShellForGithub.Content -BranchName master

		Returns all files and folders in the master branch of the PowerShellForGithub.Content repository of FriedrichWeinmann
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'property')]
		[string]
		$Owner,

		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'property')]
		[string]
		$Repository,

		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'url')]
		[string]
		$RepositoryUrl,

		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[string]
		$BranchName
	)

	process {
		if ($RepositoryUrl) {
			$parts = $RepositoryUrl -split "/"
			$Owner = $parts[-2]
			$Repository = $parts[-1]
		}
		$result = Invoke-GHRestMethod -Method Get -UriFragment "/repos/$Owner/$Repository/git/trees/$($BranchName)?recursive=1"
		foreach ($item in $result.tree) {
			[PSCustomObject]@{
				Name       = ($item.Path -split "/")[-1]
				Path       = $item.Path
				Mode       = $item.mode
				Type       = $item.type
				Hash       = $item.sha
				Size       = $item.size
				Url        = $item.url
				Owner      = $Owner
				Repository = $Repository
				BranchName = $BranchName
			}
		}
	}
}