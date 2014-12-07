$HERE = Split-Path -Parent $MyInvocation.MyCommand.Definition
$TOP_LEVEL = Split-Path -Parent $HERE

$VERSION = "2.3.0"
$TIMESTAMP = (Get-Date -Format "yyyyMMdHHmm")
$BUILD = "$VERSION.$TIMESTAMP"

cd $TOP_LEVEL

#
# Clean
#

Remove-Item -Force just-install.000 | Out-Null
Remove-Item -Force just-install.exe | Out-Null
Remove-Item -Force just-install.msi | Out-Null
Remove-Item -Recurse -Force deploy/just-install-cache | Out-Null

#
# Build
#

go build just-install.go

#
# Deploy
#

deploy\upx.exe --best just-install.exe

pushd deploy
    AdvancedInstaller.com /edit just-install.aip /SetVersion "$BUILD"
    AdvancedInstaller.com /rebuild just-install.aip
popd