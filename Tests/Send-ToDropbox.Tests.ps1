#Remove-Module -Name $Env:BHProjectName -Force -ErrorAction "SilentlyContinue"
#Import-Module -Name $Env:BHModulePath -Force

InModuleScope PSDropbox {

	Describe "PSDropbox Module - Send-ToDropbox" -Tag "Low" {
        Mock Invoke-RestMethod { }
        Function Invoke-RestMethod {  }
    }

    $Params = @{
        'SourceFilePath'        = "C:\Users\mosmith\OneDrive - cspire.com\Code\PowershellModules\PSDropbox\Tests\Send-ToDropbox.Tests.ps1"
        'TargetFilePath'        = "\Test.txt"
        'DropBoxAccessToken'    = "XXXXXXXXXXXXXXXXXXXXXX"
    }

    Context "Verifying the function succeeds" {

        Mock Invoke-RestMethod { Write-Output $true }
        It "The function succeeds" {
            Send-ToDropbox @Params | Should Be $true
        }

    }

    Context "Verifying the function fails" {

        Mock Invoke-RestMethod { Write-Output $false }
        It "The function fails" {
            Send-ToDropbox @Params | Should Be $false
        }

    }

    Context "Verifying the function fails - bad file path" {
        $Params = @{
            'SourceFilePath'        = "C:\abcdef456.txt"
            'TargetFilePath'        = "\Test.txt"
            'DropBoxAccessToken'    = "XXXXXXXXXXXXXXXXXXXXXX"
        }
        Mock Invoke-RestMethod { Write-Output $false }
        It "The function fails" {
            Send-ToDropbox @Params | Should Be $false
        }

    }

    Context "Verifying the function fails - bad target file path" {
        $Params = @{
            'SourceFilePath'        = "C:\Users\mosmith\OneDrive - cspire.com\Code\PowershellModules\PSDropbox\Tests\Send-ToDropbox.Tests.ps1"
            'TargetFilePath'        = "bad path"
            'DropBoxAccessToken'    = "XXXXXXXXXXXXXXXXXXXXXX"
        }
        Mock Invoke-RestMethod { Write-Output $false }
        It "The function fails" {
            Send-ToDropbox @Params | Should Be $false
        }

    }
}