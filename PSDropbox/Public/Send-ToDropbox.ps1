<#
    .SYNOPSIS
    Upload a file to Dropbox

    .DESCRIPTION
    Create an app associated with your account here: https://www.dropbox.com/developers/apps
    Generate an access key and create an environment variable

    .EXAMPLE
    Send-ToDropbox -SourceFilePath "/files/README.txt" -TargetFilePath "/README.txt"

    .PARAMETER $SourceFilePath
    Path to file to upload.

    .PARAMETER $TargetFilePath
    Target filepath including name, must begin with /

    .OUTPUTS
    $True on success, $False on error

    .LINK
    https://laurentkempe.com/2016/04/07/Upload-files-to-DropBox-from-PowerShell/
#>
Function Send-ToDropbox{
	[CmdletBinding()]
	Param([Parameter(Mandatory=$true)]
          [string]$SourceFilePath,
          [Parameter(Mandatory=$true)]
          [string]$TargetFilePath,
          [Parameter(Mandatory=$false)]
          $DropBoxAccessToken = $env:DropBoxAccessToken)
	
	begin{}
	process{
		try{
            if($env:DropBoxAccessToken){
                $arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
                $authorization = "Bearer " + $DropBoxAccessToken

                $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
                $headers.Add("Authorization", $authorization)
                $headers.Add("Dropbox-API-Arg", $arg)
                $headers.Add("Content-Type", 'application/octet-stream')
                
                if(Invoke-RestMethod -Uri "https://content.dropboxapi.com/2/files/upload" -Method Post -InFile $SourceFilePath -Headers $headers){
                    Write-Output $true
                }
                else {
                    Write-Output $false
                }
            }
            else {
                Write-Error 'Please create the $env:DropBoxAccessToken environment variable.'
                Write-Output $false
            }
        }
		catch{
			$ErrorMessage = $_.Exception.Message
			$FailedItem = $_.Exception.ItemName
			
			Write-Error "$FailedItem - $ErrorMessage"
			Write-Output $false
		}
		finally{}
	}
	end{}
}

