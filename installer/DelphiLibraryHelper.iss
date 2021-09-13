; ----------------------------------------------------------------------------
; Delphi Library Helper - Installation Script
; Author: Tristan Marlow
; Purpose: Install application
;
; ----------------------------------------------------------------------------
; Copyright (c) 2016 Tristan David Marlow
; Copyright (c) 2016 Little Earth Solutions
; All Rights Reserved
;
; This product is protected by copyright and distributed under
; licenses restricting copying, distribution and decompilation
;
; ----------------------------------------------------------------------------
;
; History: 14/02/2011 - First Release.
;
;-----------------------------------------------------------------------------
#define ConstAppVersion GetFileVersion("..\windows\bin\win32\release\DelphiLibraryHelper.exe") ; define variable
#define ConstAppName "Delphi Library Helper"
#define ConstAppMutex "Delphi Library Helper"
#define ConstAppDescription "Delphi Library Helper"
#define ConstAppPublisher "Little Earth Solutions"
#define ConstAppCopyright "Copyright (C) 2017 Little Earth Solutions"
#define ConstAppURL "http://www.littleearthsolutions.net/"
#define ConstAppExeName "DelphiLibraryHelper.exe"

[Setup]
AppId={{A74907F6-9360-4932-9504-2A7A12437B9F}
AppMutex={#ConstAppMutex}
AppName={#ConstAppName}
AppVersion={#ConstAppName} {#ConstAppVersion}
AppPublisher={#ConstAppPublisher}
AppPublisherURL={#ConstAppURL}
AppSupportURL={#ConstAppURL}
AppUpdatesURL={#ConstAppURL}
AppCopyright={#ConstAppCopyright}
VersionInfoCompany={#ConstAppPublisher}
VersionInfoDescription={#ConstAppName}
VersionInfoCopyright={#ConstAppCopyright}
VersionInfoVersion={#ConstAppVersion}
VersionInfoTextVersion={#ConstAppVersion}
OutputDir=output
OutputBaseFilename=DelphiLibraryHelper-Setup-{#ConstAppVersion}
UninstallDisplayName={#ConstAppName}
DefaultDirName={pf}\{#ConstAppPublisher}\{#ConstAppName}
DefaultGroupName={#ConstAppPublisher}\{#ConstAppName}
AllowNoIcons=true
;MinVersion=0,5.0.2195sp3
MinVersion=0,6.0
InfoBeforeFile=..\docs\{#ConstAppName} - Release Notes.rtf
LicenseFile=..\docs\{#ConstAppName} - License.rtf
UninstallDisplayIcon={app}\{#ConstAppExeName}
InternalCompressLevel=ultra
Compression=lzma/ultra
ChangesAssociations=yes

[Types]
Name: typical; Description: Typical Installation
Name: custom; Description: Custom Installation; Flags: iscustom

[Components]
Name: code; Description: Source Code; Types: custom
Name: program; Description: Program Files; Types: typical custom

[Tasks]
Name: "delphitoolsR"; Description: "Add to delphi tools menu (Rio)"; Components: program
Name: "delphitoolsS"; Description: "Add to delphi tools menu (Sydney)"; Components: program
Name: "delphitoolsA"; Description: "Add to delphi tools menu (Alexandria)"; Components: program

[Files]
Source: "..\windows\bin\win32\release\{#ConstAppExeName}"; DestDir: "{app}"; Flags: promptifolder replacesameversion; Components: program
Source: "..\docs\templates\*.dlht"; DestDir: "{app}\templates";  Components: program
Source: "..\images\DelphiLibraryHelper.ico"; DestDir: "{app}"; DestName: "DelphiLibraryHelper.ico"
; Source Code Components
Source: "..\docs\*.*"; DestDir: "{app}\source\docs\"; Flags: recursesubdirs; Components: code
Source: "..\installer\*.*"; DestDir: "{app}\source\installer\"; Components: code
Source: "..\images\*.*"; DestDir: "{app}\source\images\"; Flags: recursesubdirs; Components: code
Source: "..\windows\*.pas"; DestDir: "{app}\source\windows\"; Flags: recursesubdirs; Components: code
Source: "..\windows\*.dfm"; DestDir: "{app}\source\windows\"; Flags: recursesubdirs; Components: code
Source: "..\windows\*.dpr"; DestDir: "{app}\source\windows\"; Flags: recursesubdirs; Components: code
Source: "..\windows\*.res"; DestDir: "{app}\source\windows\"; Flags: recursesubdirs; Components: code
Source: "..\windows\*.dproj"; DestDir: "{app}\source\windows\"; Flags: recursesubdirs; Components: code

[Icons]
; Program Components
Name: {group}\{#ConstAppName}; Filename: {app}\{#ConstAppExeName}; WorkingDir: {app}; Components: program
; Source Code Components
Name: {group}\{#ConstAppName} Source Code; Filename: {app}\Source; Flags: foldershortcut; Components: code; Tasks: 

[Run]
Filename: "{app}\{#ConstAppExeName}"; WorkingDir: "{app}"; Flags: nowait postinstall runasoriginaluser; Description: "Launch {#ConstAppName}"

[Registry]
; Add Delphi Library Helper (Rio)
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\20.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "Params"; Tasks: delphitoolsR
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\20.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "Path"; ValueData: "{app}\DelphiLibraryHelper.exe"; Tasks: delphitoolsR
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\20.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "Title"; ValueData: "Delphi Library Helper"; Tasks: delphitoolsR
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\20.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "WorkingDir"; ValueData: "{app}\"; Tasks: delphitoolsR
; Add Delphi Library Helper (Sydney)
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\21.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "Params"; Tasks: delphitoolsS
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\21.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "Path"; ValueData: "{app}\DelphiLibraryHelper.exe"; Tasks: delphitoolsS
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\21.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "Title"; ValueData: "Delphi Library Helper"; Tasks: delphitoolsS
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\21.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "WorkingDir"; ValueData: "{app}\"; Tasks: delphitoolsS
; Add Delphi Library Helper (Alexandria)
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\22.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "Params"; Tasks: delphitoolsA
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\22.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "Path"; ValueData: "{app}\DelphiLibraryHelper.exe"; Tasks: delphitoolsA
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\22.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "Title"; ValueData: "Delphi Library Helper"; Tasks: delphitoolsA
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\22.0\Transfer\Delphi Library Helper"; ValueType: string; ValueName: "WorkingDir"; ValueData: "{app}\"; Tasks: delphitoolsA
; File association
Root: HKCR; Subkey: ".dlht"; ValueData: "{#ConstAppName}";Flags: uninsdeletevalue; ValueType: string; ValueName: ""
Root: HKCR; Subkey: "{#ConstAppName}"; ValueData: "Program {#ConstAppName}";Flags: uninsdeletekey; ValueType: string; ValueName: ""
Root: HKCR; Subkey: "{#ConstAppName}\DefaultIcon"; ValueData: "{app}\{#ConstAppExeName},0"; ValueType: string; ValueName: ""   
Root: HKCR; Subkey: "{#ConstAppName}\shell\open\command";ValueData: """{app}\{#ConstAppExeName}"" ""%1""";ValueType: string;ValueName: ""