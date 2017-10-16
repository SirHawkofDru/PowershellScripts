#ERASE ALL THIS AND PUT XAML BELOW between the @" "@
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Set-Location $dir

$inputXML = Get-Content -path '.\resources\Status.txt'   
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
    $reader=(New-Object System.Xml.XmlNodeReader $xaml)
  try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
 
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
#Get-FormVariables
 
#===========================================================================
# Actually make the objects work
#===========================================================================
 
#Sample entry of how to add data to a field

.".\resources\Functions.ps1" 

ServiceStatus

$WPFtextboxT7.Text = $arrSeven.Status
$WPFtextboxT8.Text = $arrEight.Status
$WPFtextboxSMP.Text = $arrEight.Status

If ($arrSeven.Status -eq 'Running'){
    $WPFbutton1.Content = 'Stop Tomcat 7'
    $WPFbutton1.Add_click({<#Stop Tomcat 7#>
        $Form.Close()
        Tomcat7 -action Stop
        .\StatusPage.ps1
        })
    }

If ($arrSeven.Status -eq 'Stopped'){
    $WPFbutton1.Content = 'Start Tomcat 7'
    $WPFbutton1.Add_click({<#Start Tomcat 7#>
        $Form.Close()
        Tomcat7 -action Start
        .\StatusPage.ps1
        })
    }

If ($arrEight.Status -eq 'Running'){
    $WPFbutton2.Content = 'Stop Tomcat 8'
    $WPFbutton2.Add_click({<#Stop Tomcat 8#>
        $Form.Close()
        Tomcat8 -action Stop
        .\StatusPage.ps1
        })
    }

If ($arrEight.Status -eq 'Stopped'){
    $WPFbutton2.Content = 'Start Tomcat 8'
    $WPFbutton2.Add_click({<#Start Tomcat 8#>
        $Form.Close()
        Tomcat8 -action Start
        .\StatusPage.ps1
        })
    }

If ($arrSMP.Status -eq 'Running'){
    $WPFbutton3.Content = 'Stop SMP'
    $WPFbutton3.Add_click({<#Stop SMP#>
        $Form.Close()
        SMP -action Stop
        .\StatusPage.ps1
        })
    }

If ($arrSMP.Status -eq 'Stopped'){
    $WPFbutton3.Content = 'Start SMP'
    $WPFbutton3.Add_click({<#Start SMP#>
        $Form.Close()
        SMP -action Start
        .\StatusPage.ps1
        })
    }

$WPFbutton4.Add_Click({<#Refresh#>
    $Form.Close()
    .\StatusPage.ps1
    })
$WPFbutton5.Add_Click({<#Main Menu#>
    $form.Close()
    .\MainMenu.ps1
    })
$WPFbutton.Add_Click({<#Exit#>
    $form.Close()
    exit(0)
    })

 
#===========================================================================
# Shows the form
#===========================================================================
#write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null