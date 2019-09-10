<#
    .SYNOPSIS
    Gets a list from files/folders from Dropbox

    .DESCRIPTION
    Create an app associated with your account here: https://www.dropbox.com/developers/apps
    Generate an access key and create an environment variable

    .EXAMPLE
    Get-DropboxFolders -Path "/files/""

    .PARAMETER $Path
    Path to get directory listing. Can be blank.

    .OUTPUTS
    Returns file/folders on success, $False on error
#>
Function Get-DropboxFolders{
	[CmdletBinding()]
	Param([Parameter(Mandatory=$false)]
          [string]$Path,
          [Parameter(Mandatory=$false)]
          $DropBoxAccessToken = $env:DropBoxAccessToken)
	
	begin{}
	process{
		try{
            if($DropBoxAccessToken){
                #$arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
                $authorization = "Bearer " + $DropBoxAccessToken

                $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
                $headers.Add("Authorization", $authorization)
                #$headers.Add("Dropbox-API-Arg", $arg)
                $headers.Add("Content-Type", 'application/json')

                $body = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
                $body.Add("path", $Path)
                
                $null = Invoke-RestMethod -Uri "https://api.dropboxapi.com/2/files/list_folder" -Method Post -InFile $SourceFilePath -Headers $headers -Body $body
            }
            else {
                Write-Verbose 'Please create the $env:DropBoxAccessToken environment variable or pass the token in the DropBoxAccessToken parameter.'
            }
        }
		catch{
			$ErrorMessage = $_.Exception.Message
			Write-Warning "$ErrorMessage"
		}
		finally{}
	}
	end{}
}

