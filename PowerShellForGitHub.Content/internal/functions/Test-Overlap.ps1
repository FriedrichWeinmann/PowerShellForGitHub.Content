function Test-Overlap {
	<#
	.SYNOPSIS
		Tests a value against muiltiple filter conditions, accepting any single fit.
	
	.DESCRIPTION
		Tests a value against muiltiple filter conditions, accepting any single fit.
		The comparison operator used is the "-like"

		This command will return $true if at least a single filter condition applies to the tested value.
		Is not case sensitive.
	
	.PARAMETER Value
		The value to test against the conditions.
	
	.PARAMETER Filter
		One or multiple filter conditions using wildcard comparison.
		E.g.: A*,B*,*Z would accept any input that starts with A or B or - irrespective of th starting letter - ends with z
	
	.PARAMETER Not
		Reverses the output - a $true result becomes $false and vice versa.
	
	.EXAMPLE
		PC C:\> Test-Overlap -Value Fred -Filter A*,B*,*D

		Tests whether "Fred" starts with "A" or "B" or ands with "D" (which it does)
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Value,

		[Parameter(Mandatory = $true)]
		[string[]]
		$Filter,

		[switch]
		$Not
	)

	foreach ($filterString in $Filter) {
		if ($Value -like $filterString) { return $Not -eq $false }
	}
	$Not -eq $true
}