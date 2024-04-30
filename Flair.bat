@echo off
cls
echo Checking permissions... (Flair must be started as administrator)

:: Elevation
net file 1>NUL 2>NUL
if not '%errorlevel%' == '0' (
    powershell Start-Process -FilePath "%0" -ArgumentList "%cd%" -verb runas >NUL 2>&1
    exit /b
)

:MENU
cls
echo -----------------------------------------------------------
echo Welcome to Flair, your all in one Flow Administrative Tool.
echo Version 1.0
echo Please select an action.
echo -----------------------------------------------------------
echo 1) Patch Accounts
echo 2) Remove Spyware (Experimental)
echo 3) Install Windows Sandbox
echo 4) Install/Upgrade flowd Persistence Agent
echo 5) Patch Microsoft Edge
echo 6) Patch Test Account
echo 7) Patch Microsoft Store
echo 8) Apply All Patches
echo 9) Quit
CHOICE /C:123456789
IF ERRORLEVEL 1 SET M=1
IF ERRORLEVEL 2 SET M=2
IF ERRORLEVEL 3 SET M=3
IF ERRORLEVEL 4 SET M=4
IF ERRORLEVEL 5 SET M=5
IF ERRORLEVEL 6 SET M=6
IF ERRORLEVEL 7 SET M=7
IF ERRORLEVEL 8 SET M=8
IF ERRORLEVEL 9 SET M=9
IF %M%==1 GOTO 1
IF %M%==2 GOTO 2
IF %M%==3 GOTO 3
IF %M%==4 GOTO 4
IF %M%==5 GOTO 5
IF %M%==6 GOTO 6
IF %M%==7 GOTO 7
IF %M%==8 GOTO 8
IF %M%==9 GOTO QUIT

:1
cls
echo Modifying Users, please wait...
net user "INTUNEadmin" password
net user "IntuneAdmin" password
net user "WDAGUtilityAccount" /active:yes
net user "WDAGUtilityAccount" password
net user "compassAuth" /active:yes
net user "compassAuth" password
net user "void" /active:yes
net user "void" password
net localgroup Administrators test /add
net localgroup Administrators WDAGUtilityAccount /add
net localgroup Administrators DefaultAccount /add
net user Administrator /active:yes
net user Administrator password
echo Users modified successfully, all accounts have either no password or have a password of "password"
timeout /t -1
GOTO MENU

:2
cls
echo Removing Spyware...
taskkill /f /im CW_Svc_Service.exe
taskkill /f /im ClassroomWindows.exe
taskkill /f /im LSAirStudentService.exe
taskkill /f /im LSAirClient.exe
rd /s /q "C:\Program Files\Lightspeed Systems\Classroom Agent"
rd /s /q "C:\Program Files (x86)\LenovoSoftware\LanSchoolAir"
echo Successfully removed (system-level) spyware, this is an experimental feature and may not function completely.
timeout /t -1
GOTO MENU

:3
cls
echo Checking Internet Connection...
:ping
set target=www.google.com
ping %target% -n 1 | find "Reply"
if errorlevel==1 goto ping
echo Connected!
echo Installing Sandbox...
dism /online /NoRestart /Enable-Feature /FeatureName:"Containers-DisposableClientVM" -All
echo Windows Sandbox installed successfully.
timeout /t -1
GOTO MENU

:4
cls
echo Please make sure you have a copy of flowd in an expected location (Downloads, flash drive root, etc.)
timeout /t -1
echo Copying flowd (don't worry about copy failures!)...
xcopy "%~dp0\flowd.bat" C:\Windows\system32\flowd.bat /y
xcopy "D:\Programs\Tools for flowd\flowd.bat" C:\Windows\system32\flowd.bat /y
xcopy %USERPROFILE%\Downloads\flowd.bat C:\Windows\system32\flowd.bat /y
xcopy D:\flowd.bat C:\Windows\system32\flowd.bat /y
icacls "C:\Windows\system32\flowd.bat" /grant Users:F
echo Scheduling flowd task...
schtasks /delete /tn "Persistence Agent" /f
schtasks /create /tn "Persistence Agent" /tr C:\Windows\system32\flowd.bat /sc onstart /ru "SYSTEM" /np /rl highest
echo Preparing Logs folder...
rd /s /q C:\Windows\system32\Logs
mkdir C:\Windows\system32\Logs
echo flowd has successfully installed and should run upon next restart connected to power
timeout /t -1
GOTO MENU

:5
cls
echo Killing Edge if running...
taskkill /f /im msedge.exe

echo Patching Edge Tracking Enforcement...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\AllowTrackingForUrls" /f

echo Patching Edge Extension Enforcement (Removal of Browser Spyware)...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallBlocklist" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallAllowlist" /f

echo Patching InPrivate Mode...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge" /v "InPrivateModeAvailability" /t REG_DWORD /d 0 /f

echo Removing Sign-In Requirement...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge" /v "BrowserSignin" /t REG_DWORD /d 0 /f

echo Forcing Browser Data Clearing on Exit...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge" /v "ClearBrowsingDataOnExit" /t REG_DWORD /d 1 /f

echo Patching Test User's Edge Allowlist...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\URLAllowlist" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist" /f

echo Patching Inspect Element...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge" /v "DeveloperToolsAvailability" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Edge" /v "DeveloperToolsAvailability" /t REG_DWORD /d 1 /f

echo Removing Edge Data...
rd /s /q "C:\Users\%username%\AppData\Local\Microsoft\Edge\User Data"

echo Microsoft Edge has successfully been patched!
timeout /t -1
GOTO MENU

:6
cls
echo Patching Ctrl+Alt+Delete Menu for Test User...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Policies\System" /v "HideFastUserSwitching" /t REG_DWORD /d 0 /f

echo Patching MS Edge Allowlist...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\URLAllowlist" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist" /f
echo Successfully patched Test Account
timeout /t -1
GOTO MENU

:7 
cls
echo Patching Microsoft Store...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RequirePrivateStore" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RequirePrivateStore" /t REG_DWORD /d 0 /f
echo Successfully patched Microsoft Store
timeout /t -1
GOTO MENU

:8
cls
echo Installing All Patches...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RequirePrivateStore" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RequirePrivateStore" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Policies\System" /v "HideFastUserSwitching" /t REG_DWORD /d 0 /f
explorer.exe
taskkill /f /im msedge.exe
rd /s /q "C:\Users\%username%\AppData\Local\Microsoft\Edge\User Data"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge" /v "DeveloperToolsAvailability" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Edge" /v "DeveloperToolsAvailability" /t REG_DWORD /d 1 /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\URLAllowlist" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge" /v "ClearBrowsingDataOnExit" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge" /v "BrowserSignin" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge" /v "InPrivateModeAvailability" /t REG_DWORD /d 0 /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallBlocklist" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallAllowlist" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\AllowTrackingForUrls" /f
taskkill /f /im CW_Svc_Service.exe
taskkill /f /im ClassroomWindows.exe
taskkill /f /im LSAirStudentService.exe
taskkill /f /im LSAirClient.exe
rd /s /q "C:\Program Files\Lightspeed Systems\Classroom Agent"
rd /s /q "C:\Program Files (x86)\LenovoSoftware\LanSchoolAir"
net user "INTUNEadmin" password
net user "IntuneAdmin" password
net user "WDAGUtilityAccount" /active:yes
net user "WDAGUtilityAccount" password
net user "compassAuth" /active:yes
net user "compassAuth" password
net user "void" /active:yes
net user "void" password
net localgroup Administrators test /add
net localgroup Administrators WDAGUtilityAccount /add
net localgroup Administrators DefaultAccount /add
net user Administrator /active:yes
net user Administrator password
:ping
set target=www.google.com
ping %target% -n 1 | find "Reply"
if errorlevel==1 goto ping
dism /online /NoRestart /Enable-Feature /FeatureName:"Containers-DisposableClientVM" -All
echo All patches (excluding flowd installation) have been performed, please restart to apply changes.
timeout /t -1
GOTO MENU

:QUIT
cls
set /P c=Do you want to restart now to apply any changes? (Y/N) 
if /I "%c%" EQU "Y" goto :yes
if /I "%c%" EQU "y" goto :yes
if /I "%c%" EQU "yes" goto :yes
if /I "%c%" EQU "Yes" goto :yes
if /I "%c%" EQU "N" goto :no
if /I "%c%" EQU "n" goto :no
if /I "%c%" EQU "no" goto :no
if /I "%c%" EQU "No" goto :no
goto :QUIT

:yes
cls
echo Restarting now...
shutdown /r /t 0
timeout /t 5
exit

:no
cls
exit