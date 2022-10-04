function Install-TextEditor {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true,
        Position=0
        )]$SetupFileLocation
    )
    <#
    .Description
    This is a cmdlet that installs a text editor
    #>
    process {
        $logFile = "$env:USERPROFILE\Documents\Logs\InstallTextEditor.txt"
        if(!(Test-Path -Path $logFile)){
            
            New-Item -ItemType File -Path $logFile -Force | Out-Null
        }

        # The function Write-Log is responsible for writing the logs to the log file
        # The log file is stored in user's Documents/Logs folder named InstallTextEditor.txt (see line 13)
        function Write-Log([string]$Log) {
            $logTime = (Get-Date -Format yyyy-MM-dd-HHmm)
            "[$logTime] : $Log" | Out-File -FilePath $logFile -Append
        }

        $retryInstallCount = 10
        $output = $false
        $retries = 0

        # The while loop below will handle the installation retry if the installation failed
        # The loop will not stop until the $output variable is equal to TRUE and the retry count is reached
        while($output -ne $true -and $retries -lt $retryInstallCount) {
            # The try-catch block below will handle the installation process
            # If it enounters an error, the catch block will get triggered and will display the reason of the error
            try {
                Write-Host "========================================================="
                Write-Host "Installing Text Editor"
                Write-Host "========================================================="

                #---Installer validation---#
                # The script uses Test-Path cmdlet to validate the installer path
                # If the installer is existing, it will proceed with the installation
                if(Test-Path -Path $SetupFileLocation) {
                    Write-Host "Installation beginning..."
                    Write-Host ""
                    Start-Process -FilePath $SetupFileLocation -ArgumentList '/S' -Verb runas -Wait -ErrorAction Stop
                    
                    #---Confirms the installation---#
                    # The if-else block below checks of the installation is successful
                    # Installation can be validated by querying the registry for software installations. This time, query for notepad++
                    # If either of the bit64 and bit32 exists, then it confirms that installation is success and the $output variable will be set to TRUE
                    $bit64=Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | where-Object DisplayName -like 'NotePad++*'
                    $bit32=Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*  | where-Object DisplayName -like 'NotePad++*'
                    if($bit64 -or $bit32) {
                        $output = $true
                        Write-Host "Installation completed"
                        Write-Host ""
                        Write-Log "Installation completed"
                        $retries = $retryInstallCount
                    } else {
                        Write-Error "Notepadplus installation failed. Retry installation."
                        Write-Log "Notepadplus installation failed. Retry installation."
                    }
                } else {
                    Write-Error "Path $SetupFileLocation is invalid"
                    Write-Log "Path $SetupFileLocation is invalid"
                    $retries = $retryInstallCount
                }
            }
            catch {
                Write-Error "Notepadplus installation failed. Retry installation. $PSItem"
                Write-Log "Notepadplus installation failed. Retry installation. $PSItem"
                $output = $false
            }

            $retries++
        }

        return $output
    }
}