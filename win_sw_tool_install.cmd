@echo off
title Install tools
::set encoding format to UTF-8
chcp 65001 

set SW_INSTALL_PATH="C:\choco"


echo Get administrator rights ...
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%ERRORLEVEL%' NEQ '0' (
	goto UACPrompt
) else (
	goto UACAdmin
)

:UACPrompt
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
exit /B
:UACAdmin
cd /d "%~dp0"
echo Get administrator rights success


echo Current path: %cd%
::打印空行
echo=  

:install_choco
echo Install choco

choco --version >nul 2>nul
if %ERRORLEVEL% EQU 0 (
	echo [choco] installed success
	goto choco_use
)

@powershell -NoProfile -ExecutionPolicy unrestricted -Command ^
"iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"
if %ERRORLEVEL% NEQ 0 (
	echo choco install failed
	exit /B
)
:choco_use
for /F %%i in ('choco --version') do set version=%%i
echo You can use the [choco] command，version=%version%
echo=

:install_tools
echo Install window software tools ...
choco install -y ^
	git vim 7zip notepadplusplus typora beyondcompare microsoft-windows-terminal vscode ^
	traffic-monitor wechat tim firefox atom vlc
if %ERRORLEVEL% NEQ 0 （
	echo Install failed
	goto install_tools
）

pause