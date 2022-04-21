function Get-GithubFileData {
	<#
	.SYNOPSIS
		Retrieves the data of a textfile from github.
	
	.DESCRIPTION
		Retrieves the data of a textfile from github.
	
	.PARAMETER Owner
		Owner of the Repository the file is from.
		Optional, decorative parameter used to enrich the output object.
	
	.PARAMETER Repository
		The name of the Repository the file is from.
		Optional, decorative parameter used to enrich the output object.
	
	.PARAMETER BranchName
		The Branch the file is a paart of.
		Optional, decorative parameter used to enrich the output object.
	
	.PARAMETER Path
		The relative Path of the file within its branch.
		Optional, decorative parameter used to enrich the output object.
	
	.PARAMETER Name
		The name of the file.
		Optional, decorative parameter used to enrich the output object.
	
	.PARAMETER Url
		Url to the file toretrieve
	
	.EXAMPLE
		PS C:\> Get-GithubTree -Owner FriedrichWeinmann -Repository PowerShellForGithub.Content -BranchName master | Get-GithubFileData
	
		Download all files from the master branch of the repository PowerShellForGithub.Content
	#>
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]
		$Owner,

		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]
		$Repository,

		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]
		$BranchName,

		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]
		$Path,

		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]
		$Name,

		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[string]
		$Url
	)

	process {
		if ($Url -notlike '*/blobs/*') { return }

		$fileData = Invoke-GHRestMethod -Method Get -UriFragment ($Url -replace '^https://api.github.com')
		$contentB64 = $fileData.content -replace "\n"
		$contentBytes = [convert]::FromBase64String($contentB64)
		$contentText = [System.Text.Encoding]::UTF8.GetString($contentBytes)
		
		[PSCustomObject]@{
			Name       = "$Owner/$Repository/$Path [$BranchName]"
			Content    = $contentText

			Owner      = $Owner
			Repository = $Repository
			Branch     = $BranchName
			FileName   = $Name
		}
	}
}