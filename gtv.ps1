param (
    [Parameter()][switch]$r = $false
)

$gifs = @()
if ($r) {
    $gifs = Get-ChildItem -Path .\*.gif -Recurse -Force
}
else {
    $gifs = Get-ChildItem -Path .\*.gif -Force
}
if ($null -eq $gifs -or $gifs.Count -eq 0) {
    Write-Host "No .gif files in the current directory."
    exit 1
}
$count = $gifs.Length
Write-Host "Converting $count GIFs."
foreach ($gif in $gifs) {
    Write-Host "Converting $gif"
    $output_name = [System.IO.Path]::GetFileNameWithoutExtension($gif)
    if ($null -eq $output_name) {
        Write-Host "Empty file-name for output of $gif"
        exit 1
    }
    else {
        ffmpeg -i "$gif" -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$output_name.mp4"
    }
}
