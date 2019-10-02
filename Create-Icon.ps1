function Create-Icon
{
    <#
    .Synopsis
        Create image from icon
    .Description
        Create an image from an icon
    .Example
        Create-Icon -File .\Logo.png
    #>
    [CmdletBinding()]
    param(
    # The file
    [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
    [Alias('Fullname')]
    [string]$File)
    
    begin {
        Add-Type -AssemblyName System.Windows.Forms, System.Drawing
    }
    
    process {
        #region Load Icon
        $resolvedFile = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($file)
        if (-not $resolvedFile) { return }
        $loadedImage = [Drawing.Image]::FromFile($resolvedFile)
        $intPtr = New-Object IntPtr
        $thumbnail = $loadedImage.GetThumbnailImage(512, 512, $null, $intPtr)
        $bitmap = New-Object Drawing.Bitmap $thumbnail 
        $bitmap.SetResolution(128, 128); 
        $icon = [System.Drawing.Icon]::FromHandle($bitmap.GetHicon());         
        #endregion Load Icon

        #region Cleanup
        $bitmap.Dispose()
        #endregion Cleanup

        $icon
    }
}