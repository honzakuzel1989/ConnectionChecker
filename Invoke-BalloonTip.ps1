Function Invoke-BalloonTip {
    <#
    .Synopsis
        Display a balloon tip message in the system tray.

    .Description
        This function displays a user-defined message as a balloon popup in the system tray. This function
        requires Windows Vista or later.
    
    .Parameter ToolTip
        The notifycation's icon tooltip. Keep it short and simple.

    .Parameter Message
        The message text you want to display.  Recommended to keep it short and simple.

    .Parameter Title
        The title for the message balloon.

    .Parameter MessageType
        The type of message. This value determines what type of icon to display. Valid values are

    .Parameter SysTrayIcon
        The path to a file that you will use as the system tray icon. Default is the PowerShell ISE icon.

    .Parameter Duration
        The number of seconds to display the balloon popup. The default is 1000.

    .Inputs
        None

    .Outputs
        None

    .Notes
         NAME:      Invoke-BalloonTip
         VERSION:   1.0
         AUTHOR:    Boe Prox
    #>

    [CmdletBinding()]
    Param (
        [Parameter(HelpMessage="The notifycation's icon tooltip. Keep it short and simple.")]
        [string]$ToolTip,
    
        [Parameter(HelpMessage="The message text to display. Keep it short and simple.")]
        [string]$Message,

        [Parameter(HelpMessage="The message title")]
        [string]$Title="Attention $env:username",

        [Parameter(HelpMessage="The message type: Info,Error,Warning,None")]
        [System.Windows.Forms.ToolTipIcon]$MessageType="Info",
     
        [Parameter(HelpMessage="The path to a file to use its icon in the system tray")]
        [string]$SysTrayIconPath='C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe',     

        [Parameter(HelpMessage="The number of milliseconds to display the message.")]
        [int]$Duration=1000
    )
    

    If (-NOT $global:balloon) {
        $global:balloon = New-Object System.Windows.Forms.NotifyIcon
    }
  
    #Extract the icon from the file
    $balloon.Icon = Create-Icon($SysTrayIconPath)
    $balloon.Visible = $true
    $balloon.Text = $ToolTip
  
    #Display the tip and specify in milliseconds on how long balloon will stay visible
    If ($Duration -gt 0) { 
        #Can only use certain TipIcons: [System.Windows.Forms.ToolTipIcon] | Get-Member -Static -Type Property
        $balloon.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]$MessageType
        $balloon.BalloonTipText  = $Message
        $balloon.BalloonTipTitle = $Title
        $balloon.ShowBalloonTip($Duration) 
    }
  
    Write-Verbose "Ending function Invoke-BalloonTip"
}

Function Close-BalloonTip {
    If ($global:balloon) {
        Write-Verbose 'Closing of balloon'
        $balloon.Visible = $false
    }
    Write-Verbose "Ending function Close-BalloonTip"
}

Function Dispose-BalloonTip {
    If ($global:balloon) {
        Write-Verbose 'Disposing of balloon'
        $balloon.Dispose()
    }
    Write-Verbose "Ending function Dispose-BalloonTip"
}

#Required type
Add-Type -AssemblyName System.Windows.Forms
