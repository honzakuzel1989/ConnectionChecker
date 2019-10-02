[CmdletBinding()]
Param(
  [Parameter(HelpMessage="The request's address.")]
  [string]$Address="www.honzakuzel.eu",
  
  [Parameter(HelpMessage="The Icon filename for connected status.")]
  [string]$ConnectedIconPath="connected.1.png",
  
  [Parameter(HelpMessage="The Icon filename for disconnected status.")]
  [string]$DisconnectedIconPath="disconnected.1.png",

  [Parameter(HelpMessage="The number of second between requests.")]
  [int]$Period=5,
  
  [Parameter(HelpMessage="The number of seconds to display the message (0 = stay hide).")]
  [int]$NotificationDuration=0
)

try{
  # Set up from scriptts directory and required functions
  $scriptsloc = "."
  $reqfiles = @("Invoke-BalloonTip.ps1", "Create-Icon.ps1")
  
  # Load required functions from scriptts directory
  foreach($reqfile in $reqfiles){
    Write-Verbose "Loading file $scriptsloc\$reqfile"
    . ("$scriptsloc\$reqfile")
  }

  # --
  Write-Host "$(Get-Date): Enter"

  # Ping last state and baloon data
  $lastping = $null
  $btitle = "Connection checker"
  $bduration = $NotificationDuration * 1000
  
  # Do it forever
  while($true){
    # ...
    Write-Verbose "Pinging address $Address"
  
    # Try to ping required address
    $ping = test-connection -comp $Address -count 1 -quiet -ea silentlycontinue
    
    # ...
    Write-Verbose "State: ping is $ping, lastping is $lastping"
    
    # Make a decision
    if(!($ping -eq $lastping)){
      # Success
      if($ping) { 
        # --
        Write-Host "$(Get-Date): Connected"
        Invoke-BalloonTip -Title $btitle -Duration $bduration -MessageType "Info"  -Message "You have required connectivity" -SysTrayIconPath $ConnectedIconPath 
      }
      # Failure
      else { 
        # --
        Write-Host "$(Get-Date): Disconnected"
        Invoke-BalloonTip -Title $btitle -Duration $bduration -MessageType "Error" -Message "You have NOT required connectivity"  -SysTrayIconPath $DisconnectedIconPath  
      }
    }
    
    # Save last state
    $lastping = $ping
    
    # Wait for next round
    sleep $Period
  }
}
finally{
  # Close and dispose icon
  Close-BalloonTip
  #Dispose-BalloonTip
  
  # --
  Write-Host "$(Get-Date): Exit"
}