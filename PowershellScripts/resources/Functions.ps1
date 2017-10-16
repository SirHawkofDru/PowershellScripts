Function Tomcat7 ([Parameter()][string]$action) {
	if ($action -eq 'Start') {
		Start-Service $arrSeven -WarningAction SilentlyContinue
        $arrSeven.WaitForStatus('Running')
		Write-Host "Tomcat 7 Running."
	}												
	if ($action -eq 'Restart'){
	    Restart-Service $arrSeven -WarningAction SilentlyContinue
        $arrSeven.WaitForStatus('Running')
		Write-Host "Tomcat 7 Running."
	}
	if ($action -eq 'Stop') {
        Stop-Service $arrSeven -WarningAction SilentlyContinue
        $arrSeven.WaitForStatus('Stopped')
		Write-Host 'Tomcat7 Stopped'
	}	
}

Function Tomcat8 ([Parameter()][string]$action) {
	if ($action -eq 'Start') {
		Start-Service $arrEight -WarningAction SilentlyContinue
        $arrEight.WaitForStatus('Running')
		Write-Host "Tomcat 8 Running."
	}												
	if ($action -eq 'Restart'){
	    Restart-Service $arrEight -WarningAction SilentlyContinue
        $arrEight.WaitForStatus('Running')
		Write-Host "Tomcat 8 Running."
	}
	if ($action -eq 'Stop') {
        Stop-Service $arrEight -WarningAction SilentlyContinue
        $arrEight.WaitForStatus('Stopped')
		Write-Host 'Tomcat8 Stopped'
	}
}

Function SMP ([Parameter()][string]$action ) {
	if ($action -eq 'Stop'){
		Stop-Service $arrSMP -WarningAction SilentlyContinue
		$arrSMP.WaitForStatus('Stopped')
		Write-Host 'SMP Stopped'
		}
	if ($action -eq 'Start'){
		Start-Service $arrSMP -WarningAction SilentlyContinue
		$arrSMP.WaitForStatus('Running')
		Write-Host 'SMP Started'
		}
	if ($action -eq 'Restart'){
		Stop-Service $arrSMP -WarningAction SilentlyContinue
		$arrSMP.WaitForStatus('Stopped')
		Write-Host 'SMP Stopped'
		Start-Service $arrSMP -WarningAction SilentlyContinue
		$arrSMP.WaitForStatus('Running')
		Write-Host 'SMP Started'
		}
}

Function ServiceStatus {
    $global:arrSeven = Get-Service Tomcat7
    $global:arrEight = Get-Service Tomcat8
    $global:arrSMP = Get-Service 'Sostenuto Mail Processor 4.4'
    }