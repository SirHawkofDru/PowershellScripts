#ERASE ALL THIS AND PUT XAML BELOW between the @" "@
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Set-Location $dir

$inputXML = Get-Content -path '.\resources\SMP.txt'   
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window' -replace 'ScriptDirectory', $dir
$inputXML
 
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

$arrSMP = Get-Service 'Sostenuto Mail Processor 4.4'

IF ($arrSMP.status -eq 'Running') {
    $WPFButton1.Opacity = 0.5
    $WPFbutton2.Add_Click({<#Stop service#>
        $form.Close()
        SMP -action Stop
        .\SMPMenu.ps1
        })
    $WPFbutton3.Add_Click({<#Restart service#>
        $form.Close()
        SMP -action Restart
        .\SMPMenu.ps1
        })
    }

IF ($arrSMP.Status -eq 'Stopped') {
    $WPFbutton2.Opacity = 0.5
    $WPFbutton3.Opacity = 0.5
    $WPFbutton4.Opacity = 0.5
    $WPFButton1.Add_Click({<#Start service#>
        $form.Close()
        SMP -action Start
        .\SMPMenu.ps1
        })
    }

$WPFtextBox.Text = $arrSMP.Status <#get current state of service#>
$WPFbutton.Add_Click({$form.Close()
    exit(0)
    }) <#close#>
$WPFbutton5.Add_Click({<#Go to Main Menu#>
    $form.Close()
    .\MainMenu.ps1
    }) 
 
#===========================================================================
# Shows the form
#===========================================================================
#write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null

