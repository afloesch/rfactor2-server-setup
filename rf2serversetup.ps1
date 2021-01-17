$workDir="C:\"
$steamcmdURL="https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"

# install steamcmd
cd $workDir
Invoke-WebRequest -Uri "$steamcmdURL" -OutFile ".\steamcmd.zip"
Expand-Archive .\steamcmd.zip -DestinationPath .\steamcmd
rm ./steamcmd.zip

# fetch rFactor2 dedicated server and a couple test assets
cd .\steamcmd
./steamcmd +login anonymous +force_install_dir ..\rfactor2-dedicated +app_update 400300 +quit
./steamcmd +login anonymous +workshop_download_item 365960 951986312 +quit
./steamcmd +login anonymous +workshop_download_item 365960 1782911839 +quit
cp .\steamapps\workshop\content\365960\*\*.rfcmp $workDir\rfactor2-dedicated\Packages\

# copy executables into root
cd ..\rfactor2-dedicated
cp .\Support\Tools\MAS2.exe .\MAS2.exe
cp .\Bin64\ModMgr.exe .\ModMgr.exe
cp ".\Bin64\rFactor2 Dedicated.exe" ".\rFactor2 Dedicated.exe"

# setup firewall rules
New-NetFirewallRule -Program "C:\rfactor2-dedicated\rFactor2 Dedicated.exe" -Action Allow -Profile Public,Private -Direction Inbound -DisplayName "rFactor2 Server" -Description "Allow rFactor2 Server connections"
New-NetFirewallRule -Program "C:\rfactor2-dedicated\rFactor2 Dedicated.exe" -Action Allow -Profile Public,Private -Direction Outbound -DisplayName "rFactor2 Server" -Description "Allow rFactor2 Server outbound connections"

Write-Output "Success! rFactor2 dedicated server is available in " + $workDir + "rfactor2-dedicated\"
Start-Sleep -s 3