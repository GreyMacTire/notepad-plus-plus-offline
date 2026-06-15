echo off
rem This file is part of Notepad++ project
rem Copyright (C)2025 Don HO <don.h@free.fr>
rem
rem This program is free software: you can redistribute it and/or modify
rem it under the terms of the GNU General Public License as published by
rem the Free Software Foundation, either version 3 of the License, or
rem at your option any later version.
rem
rem This program is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
rem GNU General Public License for more details.
rem
rem You should have received a copy of the GNU General Public License
rem along with this program.  If not, see <https://www.gnu.org/licenses/>.

echo on

set SIGN=0
if "%SIGN%" == "0" goto NoSign

REM commands to sign

set signtoolWin11="C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64\signtool.exe"

set Sign_by_GlobalSignCert=%signtoolWin11% sign /n "NOTEPAD++" /d "Notepad++" /du "https://notepad-plus-plus.org" /tr http://timestamp.globalsign.com/tsa/r6advanced1 /td SHA256 /fd SHA256

set DOUBLE_SIGNING=/as

REM files to be signed

set nppBinaries=..\bin64\notepad++.exe

set componentsBinaries=..\bin64\plugins\Config\nppPluginList.dll ..\bin64\updater\GUP.exe

set pluginBinaries=..\bin64\plugins\NppExport\NppExport.dll ..\bin64\plugins\mimeTools\mimeTools.dll ..\bin64\plugins\NppConverter\NppConverter.dll


REM macro is used to sign NppShell.dll & NppShell.msix with hash algorithm SHA256, due to signtool.exe bug:
REM "error 0x8007000B: The signature hash method specified (SHA512) must match the hash method used in the app package block map (SHA256)."
REM "The hashAlgorithm specified in the /fd parameter is incorrect. Rerun SignTool using hashAlgorithm that matches the app package block map (used to create the app package)"
REM Note that Publisher in Packaging/AppxManifest.xml‎ should match with the Subject of certificate.
REM https://learn.microsoft.com/en-us/windows/msix/package/signing-known-issues
set nppShellBinaries=..\bin64\NppShell.msix  ..\bin64\NppShell.x64.dll


%Sign_by_GlobalSignCert% %nppBinaries% %componentsBinaries% %pluginBinaries% %nppShellBinaries%
If ErrorLevel 1 goto End



:NoSign


rmdir /S /Q .\build
mkdir .\build

rem Notepad++ minimalist package
rmdir /S /Q .\minimalist64
mkdir .\minimalist64
mkdir .\minimalist64\userDefineLangs
mkdir .\minimalist64\themes

copy /Y ..\..\LICENSE .\minimalist64\license.txt
If ErrorLevel 1 goto End
copy /Y ..\bin\readme.txt .\minimalist64\
If ErrorLevel 1 goto End
copy /Y ..\bin\change.log .\minimalist64\
If ErrorLevel 1 goto End
copy /Y "..\bin\userDefineLangs\markdown._preinstalled.udl.xml" .\minimalist64\userDefineLangs\
If ErrorLevel 1 goto End
copy /Y ..\src\langs.model.xml .\minimalist64\
If ErrorLevel 1 goto End
copy /Y ..\src\stylers.model.xml .\minimalist64\
If ErrorLevel 1 goto End
copy /Y ..\src\tabContextMenu_example.xml .\minimalist64\
If ErrorLevel 1 goto End
copy /Y ..\src\toolbarButtonsConf_example.xml .\minimalist64\
If ErrorLevel 1 goto End
copy /Y .\xml4Config\doLocalConf.xml .\minimalist64\
If ErrorLevel 1 goto End
copy /Y ..\bin64\"notepad++.exe" .\minimalist64\
If ErrorLevel 1 goto End
copy /Y ".\themes\DarkModeDefault.xml" .\minimalist64\themes\
If ErrorLevel 1 goto End


rem Remove old built Notepad++ 64-bit package
rmdir /S /Q .\zipped.package.release64

rem Re-build Notepad++ 64-bit package folders
mkdir .\zipped.package.release64
mkdir .\zipped.package.release64\updater
mkdir .\zipped.package.release64\localization
mkdir .\zipped.package.release64\themes
mkdir .\zipped.package.release64\autoCompletion
mkdir .\zipped.package.release64\functionList
mkdir .\zipped.package.release64\userDefineLangs
mkdir .\zipped.package.release64\plugins
mkdir .\zipped.package.release64\plugins\NppExport
mkdir .\zipped.package.release64\plugins\mimeTools
mkdir .\zipped.package.release64\plugins\NppConverter
mkdir .\zipped.package.release64\plugins\Config
mkdir .\zipped.package.release64\plugins\doc


rem Basic Copy needed files into Notepad++ 64-bit package folders
copy /Y ..\..\LICENSE .\zipped.package.release64\license.txt
If ErrorLevel 1 goto End
copy /Y ..\bin\readme.txt .\zipped.package.release64\
If ErrorLevel 1 goto End
copy /Y ..\bin\change.log .\zipped.package.release64\
If ErrorLevel 1 goto End
copy /Y ..\src\langs.model.xml .\zipped.package.release64\
If ErrorLevel 1 goto End
copy /Y ..\src\stylers.model.xml .\zipped.package.release64\
If ErrorLevel 1 goto End
copy /Y ..\src\tabContextMenu_example.xml .\zipped.package.release64\
If ErrorLevel 1 goto End
copy /Y ..\src\toolbarButtonsConf_example.xml .\zipped.package.release64\
If ErrorLevel 1 goto End
copy /Y .\xml4Config\doLocalConf.xml .\zipped.package.release64\
If ErrorLevel 1 goto End
copy /Y ..\bin64\"notepad++.exe" .\zipped.package.release64\
If ErrorLevel 1 goto End


rem Plugins: Copy needed files into Notepad++ 64-bit package folders
copy /Y "..\bin64\plugins\NppExport\NppExport.dll" .\zipped.package.release64\plugins\NppExport\
If ErrorLevel 1 goto End
copy /Y "..\bin64\plugins\mimeTools\mimeTools.dll" .\zipped.package.release64\plugins\mimeTools\
If ErrorLevel 1 goto End
copy /Y "..\bin64\plugins\NppConverter\NppConverter.dll" .\zipped.package.release64\plugins\NppConverter\
If ErrorLevel 1 goto End


rem localizations: Copy all files into Notepad++ 64-bit package folders
copy /Y ".\nativeLang\*.xml" .\zipped.package.release64\localization\
If ErrorLevel 1 goto End

rem files API: Copy all files into Notepad++ 64-bit package folders
copy /Y ".\APIs\*.xml" .\zipped.package.release64\autoCompletion\
If ErrorLevel 1 goto End

rem FunctionList files: Copy all files into Notepad++ 64-bit package folders
copy /Y ".\functionList\*.xml" .\zipped.package.release64\functionList\
If ErrorLevel 1 goto End

rem Markdown as UserDefineLanguge: Markdown syntax highlighter into Notepad++ 64-bit package folders
copy /Y "..\bin\userDefineLangs\markdown._preinstalled.udl.xml" .\zipped.package.release64\userDefineLangs\
If ErrorLevel 1 goto End
copy /Y "..\bin\userDefineLangs\markdown._preinstalled_DM.udl.xml" .\zipped.package.release64\userDefineLangs\
If ErrorLevel 1 goto End

rem theme: Copy all files into Notepad++ 64-bit package folders
copy /Y ".\themes\*.xml" .\zipped.package.release64\themes\
If ErrorLevel 1 goto End

rem Use Plugins Admin but disable auto-update for x64 portable package
copy /Y .\xml4Config\disableNppAutoUpdate.xml .\zipped.package.release64\
If ErrorLevel 1 goto End
copy /Y ..\bin64\plugins\Config\nppPluginList.dll .\zipped.package.release64\plugins\Config\
copy /Y ..\bin64\updater\GUP.exe .\zipped.package.release64\updater\
copy /Y ..\bin64\updater\gup.xml .\zipped.package.release64\updater\
copy /Y ..\bin64\updater\LICENSE .\zipped.package.release64\updater\
copy /Y ..\bin64\updater\README.md .\zipped.package.release64\updater\
copy /Y ..\bin64\updater\updater.ico .\zipped.package.release64\updater\



"C:\Program Files\7-Zip\7z.exe" a -r .\build\npp.portable.minimalist.x64.7z .\minimalist64\*
If ErrorLevel 1 goto End

"C:\Program Files\7-Zip\7z.exe" a -tzip -r .\build\npp.portable.x64.zip .\zipped.package.release64\*
If ErrorLevel 1 goto End

"C:\Program Files\7-Zip\7z.exe" a -r .\build\npp.portable.x64.7z .\zipped.package.release64\*
If ErrorLevel 1 goto End

IF EXIST "%PROGRAMFILES(X86)%" ("%PROGRAMFILES(x86)%\NSIS\makensis.exe" -DARCH64 nppSetup.nsi) ELSE ("%PROGRAMFILES%\NSIS\makensis.exe" -DARCH64 nppSetup.nsi)

rem Remove old build
rmdir /S /Q .\zipped.package.release64

rem set var locally in this batch file
setlocal 

cd build

:: Get npp.6.9.Installer.exe in %nppInstallerVar%
for %%f in (npp.*.Installer.exe) do set "nppInstallerVar=%%f"


rem get the version string "6.9" in %VERSION%
set "VERSION=%nppInstallerVar:npp.=%"
rem replace "npp." with nothing in "npp.6.9.Installer.exe" - now VERSION is "6.9.Installer.exe"

rem echo %VERSION%

set "VERSION=%VERSION:.Installer.exe=%"
rem replace ".Installer.exe" with nothing in "6.9.Installer.exe" - now VERSION is "6.9"

rem echo %VERSION%

rem cd ..\msi\
rem dotnet build -c release -p:OutputPath=..\build\ -p:DefineConstants=Version=%VERSION%
rem If ErrorLevel 1 goto End

cd ..\build\


ren npp.portable.x64.zip npp.%VERSION%.portable.x64.zip
If ErrorLevel 1 goto End

ren npp.portable.x64.7z npp.%VERSION%.portable.x64.7z
If ErrorLevel 1 goto End

ren npp.portable.minimalist.x64.7z npp.%VERSION%.portable.minimalist.x64.7z
If ErrorLevel 1 goto End

rem ren npp.Installer.x64.msi npp.%VERSION%.Installer.x64.msi
rem If ErrorLevel 1 goto End

if %SIGN% == 0 goto NoSignInstaller

rem %Sign_by_GlobalSignCert% %nppInstallerVar% npp.%VERSION%.Installer.x64.exe npp.%VERSION%.Installer.x64.msi
rem If ErrorLevel 1 goto End

:NoSignInstaller

endlocal

powershell -command "Write-Host 'PACKAGES BUILT SUCCESSFUL!' -ForegroundColor Green"

:End