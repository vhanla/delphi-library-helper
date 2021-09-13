{ -----------------------------------------------------------------------------
  Unit Name: LibraryHelperU
  Author: Tristan Marlow
  Purpose: Library Helper

  ----------------------------------------------------------------------------
  Copyright (c) 2016 Tristan David Marlow
  Copyright (c) 2016 Little Earth Solutions
  All Rights Reserved

  This product is protected by copyright and distributed under
  licenses restricting copying, distribution and decompilation

  ----------------------------------------------------------------------------

  History:

  ----------------------------------------------------------------------------- }
unit LibraryHelperU;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  System.Generics.Collections, LibraryPathsU;

type
  TDelphiLibrary = (dlAndroid32, dlIOS32, dlIOS64, dlIOSimulator, dlOSX32,
    dlWin32, dlWin64, dlLinux64);

type
  TEnviromentVariable = class
  private
    FName: string;
    FValue: string;
    procedure SetName(const Value: string);
    procedure SetValue(const Value: string);
  public
    property Name: string read FName write SetName;
    property Value: string read FValue write SetValue;
  end;

type
  TEnviromentVariableList = TObjectList<TEnviromentVariable>;

type
  TEnvironmentVariables = class
  private
    FEnviromentVariableList: TEnviromentVariableList;
    function GetValue(AName: string): string;
    function GetVariable(AIndex: integer): TEnviromentVariable;
    procedure SetValue(AName: string; const Value: string);
  protected
  public
    function FindVariable(AName: string): TEnviromentVariable;
    constructor Create;
    destructor Destroy; override;
    function Count: integer;
    function Add(AName: string; AValue: string): integer;
    procedure Clear;
    property Variable[AIndex: integer]: TEnviromentVariable read GetVariable;
    property Value[AName: string]: string read GetValue write SetValue;
  end;

type
  TDelphiInstallation = class
  private
    FRegistryKey: string;
    FEnvironmentVariables: TEnvironmentVariables;
    FSystemEnvironmentVariables: TEnvironmentVariables;
    FLibraryAndroid32: TLibraryPaths;
    FLibraryIOS32: TLibraryPaths;
    FLibraryIOS64: TLibraryPaths;
    FLibraryIOSSimulator: TLibraryPaths;
    FLibraryOSX32: TLibraryPaths;
    FLibraryWin32: TLibraryPaths;
    FLibraryWin64: TLibraryPaths;
    FLibraryLinux64: TLibraryPaths;
    FLibraryPathType: TLibraryPathType;
    function GetInstalled: boolean;
    function GetProductName: string;
    procedure SaveEnvironmentVariables;
    procedure LoadEnvironmentVariables;
    procedure LoadSystemEnvironmentVariables;
    procedure LoadLibraries;
    procedure SaveLibraries;
    procedure SetLibraryAndroid32(const Value: string);
    procedure SetLibraryIOS32(const Value: string);
    procedure SetLibraryIOS64(const Value: string);
    procedure SetLibraryIOSSimulator(const Value: string);
    procedure SetLibraryOSX32(const Value: string);
    procedure SetLibraryWin32(const Value: string);
    procedure SetLibraryWin64(const Value: string);
    function LoadLibrary(ALibrary: string; APathType: TLibraryPathType): string;
    procedure SaveLibrary(ALibrary: string; AValue: string;
      APathType: TLibraryPathType);
    function GetLibraryAndroid32: string;
    function GetLibraryIOS32: string;
    function GetLibraryIOS64: string;
    function GetLibraryIOSSimulator: string;
    function GetLibraryOSX32: string;
    function GetLibraryWin32: string;
    function GetLibraryWin64: string;
    function GetLibraryLinux64: string;
    procedure SetLibraryLinux64(const Value: string);
    function GetRootPath: string;
    function GetBinPath: string;
    function GetBDSPublicFolder(AFolder: string): string;
    function GetBDSUserFolder(AFolder: string): string;
    function GetLibraryPathAsString(AStrings: TLibraryPaths): string;
    procedure SetLibraryPathFromString(AString: string; AStrings: TLibraryPaths;
      ALibrary: TDelphiLibrary);
    function CreateLibraryPaths: TLibraryPaths;
    function GetProductVersion: integer;
    function GetStudioVersion: integer;
    function ApplyTemplatePaths(ATemplateLibraryPaths: TLibraryPaths;
      ALibraryPaths: TLibraryPaths): integer;
    function GetAllEnvironemntVariables(const Vars: TStrings): integer;
    function GetShellFolderPath(AFolder: integer): string;
    function GetDocumentFolder: string;
    function GetPublicDocumentFolder: string;
    procedure NotifyEnvironmentChanges;
    procedure SetLibraryPathType(const Value: TLibraryPathType);
    procedure RemoveInvalidPaths(ALibraryPaths: TLibraryPaths;
      ALibrary: TDelphiLibrary);
    function RemoveBrowseFromSearchPaths(ALibraryPaths: TLibraryPaths;
      ADelphiLibrary: TDelphiLibrary; ASmartEnabled: boolean): integer;
    procedure FileSearch(const PathName, FileName: string;
      const Recurse: boolean; FileList: TStrings);
    function FolderContainsFiles(const PathName: string;
      FileName: string = '*.*'; const Recurse: boolean = true): boolean;
    function DeduplicatPaths(ALibraryPaths: TLibraryPaths;
      ALibrary: TDelphiLibrary): integer;
    function CopyLibraryPaths(ASourcePaths: TLibraryPaths;
      ASourcePathType: TLibraryPathType; ADestPaths: TLibraryPaths;
      ADestPathType: TLibraryPathType; ASkipBDSPaths: boolean = true): integer;
  public
    constructor Create(ARegistryKey: string);
    destructor Destroy; override;
    procedure Load;
    procedure Save(ADeduplicate: boolean);
    procedure Cleanup;
    procedure CopyBrowseToSearch;
    procedure CopySearchToBrowse;
    procedure DeleteAll(APathType: TLibraryPathType = dlpAll);
    function Deduplicate: integer;
    function RemoveBrowseFromSearch(ASmartEnabled: boolean): integer;
    procedure ExportLibrary(AFileName: TFileName);
    procedure ImportLibrary(AFileName: TFileName);
    function Apply(ALibraryPathTemplate: TLibraryPathTemplate)
      : integer; overload;
    function Apply(AFileName: TFileName): integer; overload;
    function AddPath(APath: string; ALibrary: TDelphiLibrary;
      ALibraryPathType: TLibraryPathType = dlpNone): boolean;
    function OpenFolder(AFolder: string; ALibrary: TDelphiLibrary): boolean;
    function ExecuteFile(const Operation, FileName, Params, DefaultDir: string;
      ShowCmd: word): integer;
    function GetLibraryName(ALibrary: TDelphiLibrary): string;
    function GetLibraryPlatformName(ALibrary: TDelphiLibrary): string;
    procedure CopyToClipBoard(APath: string; ALibrary: TDelphiLibrary;
      AExpand: boolean = true);
    procedure ForceEnvOptionsUpdate;
    function ExpandLibraryPath(APath: string; ALibrary: TDelphiLibrary): string;
    property LibraryPathType: TLibraryPathType read FLibraryPathType
      write SetLibraryPathType;
    property Installed: boolean read GetInstalled;
    property ProductVersion: integer read GetProductVersion;
    property ProductName: string read GetProductName;
    property RootPath: string read GetRootPath;
    property EnvironmentVariables: TEnvironmentVariables
      read FEnvironmentVariables;
    property SystemEnvironmentVariables: TEnvironmentVariables
      read FSystemEnvironmentVariables;
    procedure LibraryAsStrings(AStrings: TStrings;
      ADelphiLibrary: TDelphiLibrary);
    property LibraryWin32: string read GetLibraryWin32 write SetLibraryWin32;
    property LibraryWin64: string read GetLibraryWin64 write SetLibraryWin64;
    property LibraryOSX32: string read GetLibraryOSX32 write SetLibraryOSX32;
    property LibraryAndroid32: string read GetLibraryAndroid32
      write SetLibraryAndroid32;
    property LibraryIOS32: string read GetLibraryIOS32 write SetLibraryIOS32;
    property LibraryIOS64: string read GetLibraryIOS64 write SetLibraryIOS64;
    property LibraryIOSSimulator: string read GetLibraryIOSSimulator
      write SetLibraryIOSSimulator;
    property LibraryLinux64: string read GetLibraryLinux64
      write SetLibraryLinux64;
  end;

type
  TDelphiInstallationList = TObjectList<TDelphiInstallation>;

type
  TLibraryHelper = class(TObject)
  private
    FDelphiInstallationList: TDelphiInstallationList;
    function GetInstallation(AIndex: integer): TDelphiInstallation;
    function IsProcessRunning(AFileName: string): boolean;
  protected
    procedure GetDelphiInstallations;
    function FindInstallation(AProductName: string): TDelphiInstallation;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load;
    function Count: integer;
    function InstalledCount: integer;
    function IsDelphiRunning: boolean;
    function GetLibraryName(ADelphiLibrary: TDelphiLibrary): string;
    function GetLibraryPlatformName(ADelphiLibrary: TDelphiLibrary): string;
    procedure GetLbraryNames(AStrings: TStrings);
    property Installations[AIndex: integer]: TDelphiInstallation
      read GetInstallation;
    property Installation[AProductName: string]: TDelphiInstallation
      read FindInstallation;
  end;

implementation

uses
  System.Win.Registry, Winapi.ShellAPI, Vcl.Forms, Winapi.TlHelp32, Clipbrd,
  Winapi.ShlObj, System.IniFiles, LoggingU, System.StrUtils;

constructor TLibraryHelper.Create;
begin
  FDelphiInstallationList := TDelphiInstallationList.Create;
end;

destructor TLibraryHelper.Destroy;
begin
  try
    FreeAndNil(FDelphiInstallationList);
  finally
    inherited;
  end;
end;

function TLibraryHelper.FindInstallation(AProductName: string)
  : TDelphiInstallation;
var
  LIdx: integer;
begin
  Result := nil;
  LIdx := 0;
  while (LIdx < Count) and (Result = nil) do
  begin
    if SameText(FDelphiInstallationList.Items[LIdx].ProductName, AProductName)
    then
    begin
      Result := FDelphiInstallationList.Items[LIdx];
    end;
    Inc(LIdx);
  end;
end;

procedure TLibraryHelper.GetDelphiInstallations;
const
  BDS_KEY = 'SOFTWARE\Embarcadero\BDS';
var
  LRegistry: TRegistry;
  LKeys: TStringList;
  LKeyIdx: integer;
  LKeyName: string;
begin
  LRegistry := TRegistry.Create;
  LKeys := TStringList.Create;
  try
    LRegistry.RootKey := HKEY_LOCAL_MACHINE;
    if LRegistry.OpenKeyReadOnly(BDS_KEY) then
    begin
      LRegistry.GetKeyNames(LKeys);
      for LKeyIdx := 0 to PreD(LKeys.Count) do
      begin
        LKeyName := IncludeTrailingBackslash(BDS_KEY) + LKeys[LKeyIdx];
        LRegistry.CloseKey;
        if LRegistry.OpenKeyReadOnly(LKeyName) then
        begin
          FDelphiInstallationList.Add(TDelphiInstallation.Create(LKeyName));
          LRegistry.CloseKey;
        end;
      end;
    end;
  finally
    FreeAndNil(LRegistry);
    FreeAndNil(LKeys);
  end;
end;

function TLibraryHelper.GetInstallation(AIndex: integer): TDelphiInstallation;
begin
  Result := FDelphiInstallationList.Items[AIndex];
end;

procedure TLibraryHelper.GetLbraryNames(AStrings: TStrings);
var
  LDelphiLibrary: TDelphiLibrary;
begin
  AStrings.Clear;
  for LDelphiLibrary := Low(TDelphiLibrary) to High(TDelphiLibrary) do
  begin
    AStrings.Add(GetLibraryName(LDelphiLibrary));
  end;

end;

function TLibraryHelper.GetLibraryName(ADelphiLibrary: TDelphiLibrary): string;
begin
  Result := 'Unknown Library (' + IntToStr(integer(ADelphiLibrary)) + ')';
  case ADelphiLibrary of
    dlAndroid32:
      Result := 'Android32';
    dlIOS32:
      Result := 'iOS32';
    dlIOS64:
      Result := 'iOS64';
    dlIOSimulator:
      Result := 'iOSSimulator';
    dlOSX32:
      Result := 'macOS32';
    dlWin32:
      Result := 'Win32';
    dlWin64:
      Result := 'Win64';
    dlLinux64:
      Result := 'Linux64';
  end;
end;

function TLibraryHelper.GetLibraryPlatformName(ADelphiLibrary
  : TDelphiLibrary): string;
begin
  Result := '';
  case ADelphiLibrary of
    dlAndroid32:
      Result := 'android';
    dlIOS32:
      Result := 'iosdevice32';
    dlIOS64:
      Result := 'iosdevice64';
    dlIOSimulator:
      Result := 'iossimulator';
    dlOSX32:
      Result := 'osx32';
    dlWin32:
      Result := 'win32';
    dlWin64:
      Result := 'win64';
    dlLinux64:
      Result := 'linux64';
  end;
end;

function TLibraryHelper.Count: integer;
begin
  Result := FDelphiInstallationList.Count;
end;

function TLibraryHelper.IsProcessRunning(AFileName: string): boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(AFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(AFileName))) then
    begin
      Result := true;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function TLibraryHelper.InstalledCount: integer;
var
  LIdx: integer;
begin
  Result := 0;
  for LIdx := 0 to PreD(Count) do
  begin
    if Installations[LIdx].Installed then
      Inc(Result);
  end;
end;

function TLibraryHelper.IsDelphiRunning: boolean;
begin
  Result := IsProcessRunning('bds.exe');
  Debug('IsDelphiRunning', BoolToStr(Result, true));
end;

procedure TLibraryHelper.Load;
begin
  GetDelphiInstallations;
end;

{ TDelphiVersion }

function TDelphiInstallation.Apply(ALibraryPathTemplate
  : TLibraryPathTemplate): integer;
begin
  Result := 0;
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Common,
    FLibraryAndroid32);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.CommonFMX,
    FLibraryAndroid32);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Android32,
    FLibraryAndroid32);

  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Common,
    FLibraryIOS32);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.CommonFMX,
    FLibraryIOS32);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.IOS32,
    FLibraryIOS32);

  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Common,
    FLibraryIOS64);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.CommonFMX,
    FLibraryIOS64);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.IOS64,
    FLibraryIOS64);

  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Common,
    FLibraryIOSSimulator);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.CommonFMX,
    FLibraryIOSSimulator);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.IOS32,
    FLibraryIOSSimulator);

  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Common,
    FLibraryOSX32);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.CommonFMX,
    FLibraryOSX32);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.OSX32,
    FLibraryOSX32);

  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Common,
    FLibraryWin32);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.CommonFMX,
    FLibraryWin32);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.CommonVCL,
    FLibraryWin32);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Win32,
    FLibraryWin32);

  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Common,
    FLibraryWin64);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.CommonFMX,
    FLibraryWin64);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.CommonVCL,
    FLibraryWin64);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Win64,
    FLibraryWin64);

  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Common,
    FLibraryLinux64);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.CommonFMX,
    FLibraryLinux64);
  Result := Result + ApplyTemplatePaths(ALibraryPathTemplate.Linux64,
    FLibraryLinux64);

  Log('Template applied %d path(s)', [Result]);

end;

function TDelphiInstallation.AddPath(APath: string; ALibrary: TDelphiLibrary;
  ALibraryPathType: TLibraryPathType): boolean;
var
  LPath: string;
  LLibraryPathType: TLibraryPathType;
begin
  LLibraryPathType := ALibraryPathType;
  if LLibraryPathType = dlpNone then
    LLibraryPathType := FLibraryPathType;
  Result := False;
  LPath := APath;
  LPath := ExpandLibraryPath(LPath, ALibrary);
  if (Trim(LPath) <> '') and (DirectoryExists(LPath)) then
  begin
    case ALibrary of
      dlAndroid32:
        FLibraryAndroid32.Add(APath, LLibraryPathType);
      dlIOS32:
        FLibraryIOS32.Add(APath, LLibraryPathType);
      dlIOS64:
        FLibraryIOS64.Add(APath, LLibraryPathType);
      dlIOSimulator:
        FLibraryIOSSimulator.Add(APath, LLibraryPathType);
      dlOSX32:
        FLibraryOSX32.Add(APath, LLibraryPathType);
      dlWin32:
        FLibraryWin32.Add(APath, LLibraryPathType);
      dlWin64:
        FLibraryWin64.Add(APath, LLibraryPathType);
    end;
    Result := true;
  end;
end;

function TDelphiInstallation.Apply(AFileName: TFileName): integer;
var
  LLibraryPathTemplate: TLibraryPathTemplate;
begin
  LLibraryPathTemplate := TLibraryPathTemplate.Create;
  try
    LLibraryPathTemplate.Load(AFileName, GetProductVersion);
    Result := Apply(LLibraryPathTemplate);
  finally
    FreeAndNil(LLibraryPathTemplate);
  end;
end;

function TDelphiInstallation.ApplyTemplatePaths(ATemplateLibraryPaths
  : TLibraryPaths; ALibraryPaths: TLibraryPaths): integer;
var
  LPathIdx: integer;
  LPath: string;
  LPathType: TLibraryPathType;
begin
  Result := 0;
  for LPathIdx := 0 to PreD(ATemplateLibraryPaths.Count) do
  begin
    LPath := ATemplateLibraryPaths.Path[LPathIdx].Path;
    LPathType := ATemplateLibraryPaths.Path[LPathIdx].PathType;
    if ALibraryPaths.Add(LPath, LPathType, true) <> -1 then
    begin
      Log('Template path "%s (%s)" has been added.',
        [LPath, TLibraryPath.PathTypeToString(LPathType)]);
      Inc(Result);
    end;
  end;

end;

procedure TDelphiInstallation.Cleanup;
begin
  RemoveInvalidPaths(FLibraryAndroid32, dlAndroid32);
  RemoveInvalidPaths(FLibraryIOS32, dlIOS32);
  RemoveInvalidPaths(FLibraryIOS64, dlIOS64);
  RemoveInvalidPaths(FLibraryIOSSimulator, dlIOSimulator);
  RemoveInvalidPaths(FLibraryOSX32, dlOSX32);
  RemoveInvalidPaths(FLibraryWin32, dlWin32);
  RemoveInvalidPaths(FLibraryWin64, dlWin64);
  RemoveInvalidPaths(FLibraryLinux64, dlLinux64);
end;

procedure TDelphiInstallation.CopyBrowseToSearch;
begin
  CopyLibraryPaths(FLibraryAndroid32, dlpBrowse, FLibraryAndroid32, dlpSearch);
  CopyLibraryPaths(FLibraryIOS32, dlpBrowse, FLibraryIOS32, dlpSearch);
  CopyLibraryPaths(FLibraryIOS64, dlpBrowse, FLibraryIOS64, dlpSearch);
  CopyLibraryPaths(FLibraryIOSSimulator, dlpBrowse, FLibraryIOSSimulator,
    dlpSearch);
  CopyLibraryPaths(FLibraryOSX32, dlpBrowse, FLibraryOSX32, dlpSearch);
  CopyLibraryPaths(FLibraryWin32, dlpBrowse, FLibraryWin32, dlpSearch);
  CopyLibraryPaths(FLibraryWin64, dlpBrowse, FLibraryWin64, dlpSearch);
  CopyLibraryPaths(FLibraryLinux64, dlpBrowse, FLibraryLinux64, dlpSearch);
end;

function TDelphiInstallation.CopyLibraryPaths(ASourcePaths: TLibraryPaths;
  ASourcePathType: TLibraryPathType; ADestPaths: TLibraryPaths;
  ADestPathType: TLibraryPathType; ASkipBDSPaths: boolean): integer;
var
  LSourcePath, LDestPath: TLibraryPath;
  LAddPath: boolean;
  LTotal, LIdx: integer;
begin
  Result := 0;
  LTotal := ASourcePaths.Count;
  for LIdx := 0 to LTotal do
  begin
    LSourcePath := ASourcePaths.Path[LIdx];
    if LSourcePath.PathType = ASourcePathType then
    begin
      LAddPath := true;
      if ASkipBDSPaths then
      begin
        LAddPath := StartsText('$(BDS', LSourcePath.Path);
      end;

      if LAddPath then
      begin
        ADestPaths.Add(LSourcePath.Path, ADestPathType);
        Inc(Result);
      end;
    end;
  end;
end;

procedure TDelphiInstallation.CopySearchToBrowse;
begin
  CopyLibraryPaths(FLibraryAndroid32, dlpSearch, FLibraryAndroid32, dlpBrowse);
  CopyLibraryPaths(FLibraryIOS32, dlpSearch, FLibraryIOS32, dlpBrowse);
  CopyLibraryPaths(FLibraryIOS64, dlpSearch, FLibraryIOS64, dlpBrowse);
  CopyLibraryPaths(FLibraryIOSSimulator, dlpSearch, FLibraryIOSSimulator,
    dlpBrowse);
  CopyLibraryPaths(FLibraryOSX32, dlpSearch, FLibraryOSX32, dlpBrowse);
  CopyLibraryPaths(FLibraryWin32, dlpSearch, FLibraryWin32, dlpBrowse);
  CopyLibraryPaths(FLibraryWin64, dlpSearch, FLibraryWin64, dlpBrowse);
  CopyLibraryPaths(FLibraryLinux64, dlpSearch, FLibraryLinux64, dlpBrowse);
end;

procedure TDelphiInstallation.CopyToClipBoard(APath: string;
  ALibrary: TDelphiLibrary; AExpand: boolean);
var
  LPath: string;
begin
  LPath := APath;
  if AExpand then
    LPath := ExpandLibraryPath(APath, ALibrary);
  Clipboard.AsText := LPath;
end;

constructor TDelphiInstallation.Create(ARegistryKey: string);
begin
  FLibraryPathType := dlpSearch;
  FRegistryKey := ARegistryKey;
  FEnvironmentVariables := TEnvironmentVariables.Create;
  FSystemEnvironmentVariables := TEnvironmentVariables.Create;
  FLibraryAndroid32 := CreateLibraryPaths;
  FLibraryIOS32 := CreateLibraryPaths;
  FLibraryIOS64 := CreateLibraryPaths;
  FLibraryIOSSimulator := CreateLibraryPaths;
  FLibraryOSX32 := CreateLibraryPaths;
  FLibraryWin32 := CreateLibraryPaths;
  FLibraryWin64 := CreateLibraryPaths;
  FLibraryLinux64 := CreateLibraryPaths;
end;

function TDelphiInstallation.CreateLibraryPaths: TLibraryPaths;
begin
  Result := TLibraryPaths.Create;
end;

function TDelphiInstallation.Deduplicate: integer;
begin
  Result := 0;
  Result := Result + DeduplicatPaths(FLibraryAndroid32, dlAndroid32);
  Result := Result + DeduplicatPaths(FLibraryIOS32, dlIOS32);
  Result := Result + DeduplicatPaths(FLibraryIOS64, dlIOS64);
  Result := Result + DeduplicatPaths(FLibraryIOSSimulator, dlIOSimulator);
  Result := Result + DeduplicatPaths(FLibraryOSX32, dlOSX32);
  Result := Result + DeduplicatPaths(FLibraryWin32, dlWin32);
  Result := Result + DeduplicatPaths(FLibraryWin64, dlWin64);
  Result := Result + DeduplicatPaths(FLibraryLinux64, dlLinux64);
end;

destructor TDelphiInstallation.Destroy;
begin
  try
    FreeAndNil(FEnvironmentVariables);
    FreeAndNil(FSystemEnvironmentVariables);
    FreeAndNil(FLibraryAndroid32);
    FreeAndNil(FLibraryIOS32);
    FreeAndNil(FLibraryIOS64);
    FreeAndNil(FLibraryIOSSimulator);
    FreeAndNil(FLibraryOSX32);
    FreeAndNil(FLibraryWin32);
    FreeAndNil(FLibraryWin64);
    FreeAndNil(FLibraryLinux64);
  finally
    inherited;
  end;
end;

function TDelphiInstallation.GetShellFolderPath(AFolder: integer): string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  Path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, AFolder, 0, SHGFP_TYPE_CURRENT, @Path[0]))
  then
    Result := Path
  else
    Result := '';
end;

function TDelphiInstallation.GetStudioVersion: integer;
var
  LPath: string;
begin
  LPath := GetRootPath;
  LPath := ExcludeTrailingPathDelimiter(LPath);
  LPath := ExtractFileName(LPath);
  LPath := ChangeFileExt(LPath, '');
  Result := StrToIntDef(LPath, 0);
end;

function TDelphiInstallation.GetDocumentFolder: string;
begin
  Result := IncludeTrailingPathDelimiter(GetShellFolderPath(CSIDL_PERSONAL));
end;

function TDelphiInstallation.GetPublicDocumentFolder: string;
begin
  Result := IncludeTrailingPathDelimiter
    (GetShellFolderPath(CSIDL_COMMON_DOCUMENTS));
end;

function TDelphiInstallation.ExpandLibraryPath(APath: string;
  ALibrary: TDelphiLibrary): string;
var
  LVariableIdx: integer;
begin
  Result := APath;

  Result := ExcludeTrailingPathDelimiter(StringReplace(Result, '$(BDSBIN)',
    GetBinPath, [rfReplaceAll, rfIgnoreCase]));

  Result := ExcludeTrailingPathDelimiter(StringReplace(Result,
    '$(BDSCatalogRepositoryAllUsers)', GetBDSPublicFolder('CatalogRepository'),
    [rfReplaceAll, rfIgnoreCase]));

  Result := ExcludeTrailingPathDelimiter(StringReplace(Result,
    '$(BDSCatalogRepository)', GetBDSUserFolder('CatalogRepository'),
    [rfReplaceAll, rfIgnoreCase]));

  Result := ExcludeTrailingPathDelimiter(StringReplace(Result, '$(BDSLIB)',
    GetRootPath + 'lib', [rfReplaceAll, rfIgnoreCase]));

  Result := ExcludeTrailingPathDelimiter(StringReplace(Result, '$(BDSINCLUDE)',
    GetRootPath + 'include', [rfReplaceAll, rfIgnoreCase]));

  Result := ExcludeTrailingPathDelimiter(StringReplace(Result,
    '$(BDSCOMMONDIR)', GetBDSPublicFolder(''), [rfReplaceAll, rfIgnoreCase]));

  Result := ExcludeTrailingPathDelimiter(StringReplace(Result,
    '$(BDSPLATFORMSDKDIR)', GetBDSUserFolder('SDKs'),
    [rfReplaceAll, rfIgnoreCase]));

  Result := ExcludeTrailingPathDelimiter(StringReplace(Result,
    '$(BDSPROFILESDIR)', GetBDSUserFolder('Profiles'),
    [rfReplaceAll, rfIgnoreCase]));

  Result := ExcludeTrailingPathDelimiter(StringReplace(Result,
    '$(BDSPROJECTSDIR)', GetBDSUserFolder('Profiles'),
    [rfReplaceAll, rfIgnoreCase]));

  Result := ExcludeTrailingPathDelimiter(StringReplace(Result, '$(BDSUSERDIR)',
    GetBDSUserFolder(''), [rfReplaceAll, rfIgnoreCase]));

  for LVariableIdx := 0 to PreD(FSystemEnvironmentVariables.Count) do
  begin
    Result := ExcludeTrailingPathDelimiter(StringReplace(Result,
      Format('$(%s)', [FSystemEnvironmentVariables.Variable[LVariableIdx].Name]
      ), FSystemEnvironmentVariables.Variable[LVariableIdx].Value,
      [rfReplaceAll, rfIgnoreCase]));
    Result := ExcludeTrailingPathDelimiter(StringReplace(Result,
      Format('${%s}', [FSystemEnvironmentVariables.Variable[LVariableIdx].Name]
      ), FSystemEnvironmentVariables.Variable[LVariableIdx].Value,
      [rfReplaceAll, rfIgnoreCase]));
  end;

  for LVariableIdx := 0 to PreD(FEnvironmentVariables.Count) do
  begin
    Result := ExcludeTrailingPathDelimiter(StringReplace(Result,
      Format('$(%s)', [FEnvironmentVariables.Variable[LVariableIdx].Name]),
      FEnvironmentVariables.Variable[LVariableIdx].Value,
      [rfReplaceAll, rfIgnoreCase]));
    Result := ExcludeTrailingPathDelimiter(StringReplace(Result,
      Format('${%s}', [FEnvironmentVariables.Variable[LVariableIdx].Name]),
      FEnvironmentVariables.Variable[LVariableIdx].Value,
      [rfReplaceAll, rfIgnoreCase]));
  end;

  Result := ExcludeTrailingPathDelimiter(StringReplace(Result, '$(BDS)',
    GetRootPath, [rfReplaceAll, rfIgnoreCase]));
  Result := ExcludeTrailingPathDelimiter(StringReplace(Result, '$(Platform)',
    GetLibraryPlatformName(ALibrary), [rfReplaceAll, rfIgnoreCase]));
  Debug('ExpandLibraryPath', '%s => %s', [APath, Result]);
end;

procedure TDelphiInstallation.ExportLibrary(AFileName: TFileName);
var
  LINIfile: TMemIniFile;
  LPathType: TLibraryPathType;

  procedure ExportDelphiLibrary(ALibraryPaths: TLibraryPaths;
    ADelphiLibrary: TDelphiLibrary);
  var
    LLibraryPath: TLibraryPath;
    LLibraryName: string;
    LIdx: integer;
  begin
    LLibraryName := GetLibraryPlatformName(ADelphiLibrary);
    for LIdx := 0 to PreD(ALibraryPaths.Count) do
    begin
      LLibraryPath := ALibraryPaths.Path[LIdx];
      LINIfile.WriteString(LLibraryName, LLibraryPath.Path + ';' +
        TLibraryPath.PathTypeToString(LLibraryPath.PathType), '');
    end;

  end;

begin
  if FileExists(AFileName) then
    DeleteFile(AFileName);
  LINIfile := TMemIniFile.Create(AFileName);
  try
    for LPathType := dlpSearch to dlpDebugDCU do
    begin
      ExportDelphiLibrary(FLibraryAndroid32, dlAndroid32);
      ExportDelphiLibrary(FLibraryIOS32, dlIOS32);
      ExportDelphiLibrary(FLibraryIOS64, dlIOS64);
      ExportDelphiLibrary(FLibraryIOSSimulator, dlIOSimulator);
      ExportDelphiLibrary(FLibraryOSX32, dlOSX32);
      ExportDelphiLibrary(FLibraryWin32, dlWin32);
      ExportDelphiLibrary(FLibraryWin64, dlWin64);
      ExportDelphiLibrary(FLibraryLinux64, dlLinux64);
    end;
  finally
    FreeAndNil(LINIfile);
  end;
end;

procedure TDelphiInstallation.ImportLibrary(AFileName: TFileName);
var
  LINIfile: TMemIniFile;

  procedure ImportDelphiLibrary(ALibrary: TDelphiLibrary);
  var
    LLibrary: TStringList;
    LLibraryName: string;
    LPath: string;
    LLibraryPath: TLibraryPathType;
    LSection: string;
  begin
    LLibrary := TStringList.Create;
    try
      LLibraryName := GetLibraryName(ALibrary);
      LINIfile.ReadSection(LLibraryName, LLibrary);

      for LSection in LLibrary do
      begin

        if Pos(';', LSection) > 0 then
        begin
          LPath := Copy(LSection, 1, Pos(';', LSection) - 1);
          LLibraryPath := TLibraryPath.PathTypeFromString
            (Copy(LSection, Pos(';', LSection) + 1, Length(LSection)));
        end
        else
        begin
          LPath := LSection;
          LLibraryPath := dlpNone;
        end;

        AddPath(LPath, ALibrary, LLibraryPath);
      end;
    finally
      FreeAndNil(LLibrary);
    end;
  end;

begin
  if FileExists(AFileName) then
  begin
    LINIfile := TMemIniFile.Create(AFileName);
    try
      ImportDelphiLibrary(dlAndroid32);
      ImportDelphiLibrary(dlIOS32);
      ImportDelphiLibrary(dlIOS64);
      ImportDelphiLibrary(dlIOSimulator);
      ImportDelphiLibrary(dlOSX32);
      ImportDelphiLibrary(dlWin32);
      ImportDelphiLibrary(dlWin64);
      ImportDelphiLibrary(dlLinux64);
    finally
      FreeAndNil(LINIfile);
    end;
  end;
end;

procedure TDelphiInstallation.ForceEnvOptionsUpdate;
var
  LRegistry: TRegistry;
  LRegistryKey: string;
begin
  LRegistry := TRegistry.Create;
  try
    LRegistry.RootKey := HKEY_CURRENT_USER;
    LRegistryKey := IncludeTrailingBackslash(FRegistryKey);
    LRegistryKey := IncludeTrailingBackslash(LRegistryKey + 'Globals');
    if LRegistry.OpenKey(LRegistryKey, False) then
    begin
      LRegistry.WriteInteger('ForceEnvOptionsUpdate', 1);
    end;
  finally
    FreeAndNil(LRegistry);
  end;
end;

procedure TDelphiInstallation.NotifyEnvironmentChanges;
begin
  Log('Notify Environment Changes');
  SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, 0,
    NativeInt(PChar('Environment')), SMTO_ABORTIFHUNG, 5000, nil);
end;

procedure TDelphiInstallation.LibraryAsStrings(AStrings: TStrings;
  ADelphiLibrary: TDelphiLibrary);
begin
  case ADelphiLibrary of
    dlAndroid32:
      AStrings.Text := GetLibraryAndroid32;
    dlIOS32:
      AStrings.Text := GetLibraryIOS32;
    dlIOS64:
      AStrings.Text := GetLibraryIOS64;
    dlIOSimulator:
      AStrings.Text := GetLibraryIOSSimulator;
    dlOSX32:
      AStrings.Text := GetLibraryOSX32;
    dlWin32:
      AStrings.Text := GetLibraryWin32;
    dlWin64:
      AStrings.Text := GetLibraryWin64;
    dlLinux64:
      AStrings.Text := GetLibraryLinux64;
  end;
end;

procedure TDelphiInstallation.Load;
begin
  LoadSystemEnvironmentVariables;
  LoadEnvironmentVariables;
  LoadLibraries;
end;

procedure TDelphiInstallation.LoadEnvironmentVariables;
var
  LRegistry: TRegistry;
  LLibraryKey: string;
  LValues: TStringList;
  LIdx: integer;
  LName: string;
begin
  FEnvironmentVariables.Clear;
  LRegistry := TRegistry.Create;
  LValues := TStringList.Create;
  try
    LRegistry.RootKey := HKEY_CURRENT_USER;
    LLibraryKey := IncludeTrailingBackslash(FRegistryKey);
    LLibraryKey := IncludeTrailingBackslash
      (LLibraryKey + 'Environment Variables');
    if LRegistry.OpenKeyReadOnly(LLibraryKey) then
    begin
      LRegistry.GetValueNames(LValues);
      for LIdx := 0 to PreD(LValues.Count) do
      begin
        LName := LValues[LIdx];
        if Trim(LName) <> '' then
        begin
          FEnvironmentVariables.Add(LName, LRegistry.ReadString(LValues[LIdx]));
        end;
      end;
    end;
  finally
    FreeAndNil(LRegistry);
    FreeAndNil(LValues);
  end;
end;

procedure TDelphiInstallation.LoadLibraries;
var
  LPathType: TLibraryPathType;
begin
  for LPathType := dlpSearch to dlpDebugDCU do
  begin
    FLibraryAndroid32.FromDelimitedString(LoadLibrary('Android32', LPathType),
      LPathType);

    FLibraryIOS64.FromDelimitedString(LoadLibrary('iOSDevice64', LPathType),
      LPathType);

    FLibraryIOS32.FromDelimitedString(LoadLibrary('iOSDevice32', LPathType),
      LPathType);

    FLibraryIOSSimulator.FromDelimitedString(LoadLibrary('iOSSimulator',
      LPathType), LPathType);

    FLibraryOSX32.FromDelimitedString(LoadLibrary('OSX32', LPathType),
      LPathType);

    FLibraryWin32.FromDelimitedString(LoadLibrary('Win32', LPathType),
      LPathType);

    FLibraryWin64.FromDelimitedString(LoadLibrary('Win64', LPathType),
      LPathType);
    FLibraryLinux64.FromDelimitedString(LoadLibrary('Linux64', LPathType),
      LPathType);
  end;

end;

function TDelphiInstallation.GetInstalled: boolean;
var
  LRegistry: TRegistry;
  LApp: string;
begin
  Result := False;
  LRegistry := TRegistry.Create;
  try
    LRegistry.RootKey := HKEY_CURRENT_USER;
    if LRegistry.OpenKeyReadOnly(FRegistryKey) then
    begin
      LApp := LRegistry.ReadString('App');
      Result := FileExists(LApp);
    end;
  finally
    FreeAndNil(LRegistry);
  end;
end;

function TDelphiInstallation.LoadLibrary(ALibrary: string;
  APathType: TLibraryPathType): string;
var
  LRegistry: TRegistry;
  LLibraryKey: string;
  LName: string;
begin
  Result := '';
  LRegistry := TRegistry.Create;
  try
    LRegistry.RootKey := HKEY_CURRENT_USER;
    LLibraryKey := IncludeTrailingBackslash(FRegistryKey);
    LLibraryKey := IncludeTrailingBackslash(LLibraryKey + 'Library');
    LLibraryKey := IncludeTrailingBackslash(LLibraryKey + ALibrary);
    if LRegistry.OpenKeyReadOnly(LLibraryKey) then
    begin
      case APathType of
        dlpSearch:
          LName := 'Search Path';
        dlpBrowse:
          LName := 'Browsing Path';
        dlpDebugDCU:
          LName := 'Debug DCU Path';
      else
        LName := '';
      end;
      if LName <> '' then
      begin
        Result := LRegistry.ReadString(LName);
        Debug('LoadLibrary', 'Loading library %s name: %s, value: %s',
          [LLibraryKey, LName, Result]);
      end;

    end;
  finally
    FreeAndNil(LRegistry);
  end;
end;

function TDelphiInstallation.GetAllEnvironemntVariables
  (const Vars: TStrings): integer;
var
  PEnvVars: PChar;
  // pointer to start of environment block
  PEnvEntry: PChar; // pointer to an env string in block
begin
  // Clear the list
  if Assigned(Vars) then
    Vars.Clear;
  // Get reference to environment block for this process
  PEnvVars := GetEnvironmentStrings;
  if PEnvVars <> nil then
  begin
    // We have a block: extract strings from it
    // Env strings are #0 separated and list ends with #0#0
    PEnvEntry := PEnvVars;
    try
      while PEnvEntry^ <> #0 do
      begin
        if Assigned(Vars) then
          Vars.Add(PEnvEntry);
        Inc(PEnvEntry, StrLen(PEnvEntry) + 1);
      end;
      // Calculate length of block
      Result := (PEnvEntry - PEnvVars) + 1;
    finally
      // Dispose of the memory block
      FreeEnvironmentStrings(PEnvVars);
    end;
  end
  else
    // No block => zero length
    Result := 0;
end;

function TDelphiInstallation.GetBDSPublicFolder(AFolder: string): string;
begin
  Result := GetPublicDocumentFolder;
  Result := IncludeTrailingPathDelimiter(Result + 'Embarcadero\Studio');
  Result := IncludeTrailingPathDelimiter
    (Result + IntToStr(GetStudioVersion) + '.0');
  if Trim(AFolder) <> '' then
    Result := IncludeTrailingPathDelimiter(Result + AFolder);
  Result := ExcludeTrailingPathDelimiter(Result);
end;

function TDelphiInstallation.GetBDSUserFolder(AFolder: string): string;
begin
  Result := GetDocumentFolder;
  Result := IncludeTrailingPathDelimiter(Result + 'Embarcadero\Studio');
  Result := IncludeTrailingPathDelimiter
    (Result + IntToStr(GetStudioVersion) + '.0');
  if Trim(AFolder) <> '' then
    Result := IncludeTrailingPathDelimiter(Result + AFolder);
  Result := ExcludeTrailingPathDelimiter(Result);
end;

function TDelphiInstallation.GetBinPath: string;
var
  LRegistry: TRegistry;
begin
  Result := '';
  LRegistry := TRegistry.Create;
  try
    LRegistry.RootKey := HKEY_CURRENT_USER;
    if LRegistry.OpenKeyReadOnly(FRegistryKey) then
    begin
      Result := IncludeTrailingPathDelimiter
        (ExtractFilePath(LRegistry.ReadString('App')));
    end;
  finally
    FreeAndNil(LRegistry);
  end;
end;

procedure TDelphiInstallation.LoadSystemEnvironmentVariables;
var
  LVars: TStringList;
  LVarIdx: integer;
  LName: string;
begin
  LVars := TStringList.Create;
  try
    FSystemEnvironmentVariables.Clear;
    GetAllEnvironemntVariables(LVars);
    for LVarIdx := 0 to PreD(LVars.Count) do
    begin
      LName := LVars.Names[LVarIdx];
      if Trim(LName) <> '' then
      begin
        FSystemEnvironmentVariables.Add(LName, LVars.ValueFromIndex[LVarIdx]);
      end;
    end;
  finally
    FreeAndNil(LVars);
  end;
end;

function TDelphiInstallation.OpenFolder(AFolder: string;
  ALibrary: TDelphiLibrary): boolean;
var
  LFolder: string;
begin
  Result := False;
  LFolder := AFolder;
  LFolder := ExpandLibraryPath(LFolder, ALibrary);
  if DirectoryExists(LFolder) then
  begin
    Result := ExecuteFile('open', PChar('explorer.exe'), PChar(LFolder), '',
      SW_SHOWNORMAL) > 32;
  end;
end;

function TDelphiInstallation.FolderContainsFiles(const PathName: string;
  FileName: string; const Recurse: boolean): boolean;
var
  LFileList: TStringList;
begin
  LFileList := TStringList.Create;
  try
    FileSearch(PathName, FileName, Recurse, LFileList);
    Result := LFileList.Count > 0;
  finally
    FreeAndNil(LFileList);
  end;
end;

procedure TDelphiInstallation.FileSearch(const PathName, FileName: string;
  const Recurse: boolean; FileList: TStrings);
var
  Rec: TSearchRec;
  Path: string;
  Cancel: boolean;
begin
  Path := IncludeTrailingPathDelimiter(PathName);
  Cancel := False;
  if FindFirst(Path + FileName, faAnyFile, Rec) = 0 then
    try
      repeat
        if (Rec.Name <> '.') and (Rec.Name <> '..') then
        begin
          FileList.Add(Path + Rec.Name);
        end;
      until (FindNext(Rec) <> 0) or (Cancel = true);
    finally
      FindClose(Rec);
    end;

  if (Recurse) and (Cancel = False) then
  begin
    if FindFirst(Path + '*', faDirectory, Rec) = 0 then
      try
        repeat
          if ((Rec.Attr and faDirectory) = faDirectory) and (Rec.Name <> '.')
            and (Rec.Name <> '..') then
          begin
            FileSearch(Path + Rec.Name, FileName, true, FileList);
          end;
        until (FindNext(Rec) <> 0) or (Cancel = true);
      finally
        FindClose(Rec);
      end;
  end;
end;

function TDelphiInstallation.RemoveBrowseFromSearchPaths(ALibraryPaths
  : TLibraryPaths; ADelphiLibrary: TDelphiLibrary;
  ASmartEnabled: boolean): integer;
var
  LSearchFolders, LBrowseFolders: TStringList;
  LSearchFolder, LBrowseFolder: string;
  LBrowseFolderIdx, LSearchFolderIdx: integer;
  LDelete: boolean;
begin
  Result := 0;
  LSearchFolders := TStringList.Create;
  LBrowseFolders := TStringList.Create;
  try
    LBrowseFolders.Sorted := true;
    LBrowseFolders.Duplicates := dupIgnore;
    LSearchFolders.Sorted := true;
    LSearchFolders.Duplicates := dupIgnore;

    ALibraryPaths.AsStrings(LSearchFolders, dlpSearch);
    ALibraryPaths.AsStrings(LBrowseFolders, dlpBrowse);

    for LBrowseFolderIdx := 0 to PreD(LBrowseFolders.Count) do
    begin
      LBrowseFolder := LBrowseFolders[LBrowseFolderIdx];
      LBrowseFolder := ExpandLibraryPath(LBrowseFolder, ADelphiLibrary);
      LSearchFolderIdx := 0;
      While LSearchFolderIdx < LSearchFolders.Count do
      begin
        LSearchFolder := LSearchFolders[LSearchFolderIdx];
        LSearchFolder := ExpandLibraryPath(LSearchFolder, ADelphiLibrary);
        LDelete := False;
        if SameText(LSearchFolder, LBrowseFolder) then
        begin
          Log('Found matching search and browse folder "%s"', [LSearchFolder]);
          LDelete := true;
          if ASmartEnabled then
          begin
            if LDelete then
              LDelete := not FolderContainsFiles(LSearchFolder, '*.dfm', False);
            if LDelete then
              LDelete := not FolderContainsFiles(LSearchFolder, '*.inc', False);
            if LDelete then
              LDelete := not FolderContainsFiles(LSearchFolder, '*.res', False);
            if not LDelete then
            begin
              Log('Skipping folder "%s" as it contains DFM,INC or RES files.',
                [LSearchFolder]);
            end;
          end;
        end;
        if LDelete then
        begin
          Log('Removing matching search and browse folder "%s"',
            [LSearchFolder]);
          Inc(Result);
          LSearchFolders.Delete(LSearchFolderIdx);
        end
        else
        begin
          Inc(LSearchFolderIdx);
        end;
      end;

    end;

    if Result > 0 then
    begin
      ALibraryPaths.FromStrings(LSearchFolders, dlpSearch);
    end;

  finally
    FreeAndNil(LSearchFolders);
  end;
end;

function TDelphiInstallation.RemoveBrowseFromSearch(ASmartEnabled
  : boolean): integer;
begin
  Result := 0;
  Result := Result + RemoveBrowseFromSearchPaths(FLibraryAndroid32, dlAndroid32,
    ASmartEnabled);
  Result := Result + RemoveBrowseFromSearchPaths(FLibraryIOS32, dlIOS32,
    ASmartEnabled);
  Result := Result + RemoveBrowseFromSearchPaths(FLibraryIOS64, dlIOS64,
    ASmartEnabled);
  Result := Result + RemoveBrowseFromSearchPaths(FLibraryIOSSimulator,
    dlIOSimulator, ASmartEnabled);
  Result := Result + RemoveBrowseFromSearchPaths(FLibraryOSX32, dlOSX32,
    ASmartEnabled);
  Result := Result + RemoveBrowseFromSearchPaths(FLibraryWin32, dlWin32,
    ASmartEnabled);
  Result := Result + RemoveBrowseFromSearchPaths(FLibraryWin64, dlWin64,
    ASmartEnabled);
  Result := Result + RemoveBrowseFromSearchPaths(FLibraryLinux64, dlLinux64,
    ASmartEnabled);
end;

procedure TDelphiInstallation.RemoveInvalidPaths(ALibraryPaths: TLibraryPaths;
  ALibrary: TDelphiLibrary);
var
  LIdx: integer;
  LPath: string;
  LExists: boolean;
begin
  LIdx := 0;
  while LIdx < ALibraryPaths.Count do
  begin
    LExists := true;
    LPath := ALibraryPaths.Path[LIdx].Path;
    if not DirectoryExists(LPath) then
    begin
      LPath := (ExpandLibraryPath(LPath, ALibrary));
      if Pos('$', LPath) = 0 then
      begin
        LExists := DirectoryExists(LPath);
      end;
    end;

    if not LExists then
    begin
      Log('Removing invalid path "%s"', [LPath]);
      ALibraryPaths.Delete(LIdx);
    end
    else
    begin
      Inc(LIdx);
    end;
  end;

end;

function TDelphiInstallation.DeduplicatPaths(ALibraryPaths: TLibraryPaths;
  ALibrary: TDelphiLibrary): integer;
var
  LExpandedPaths: TLibraryPaths;
  LIdx: integer;
  LPath: string;
  LPathType: TLibraryPathType;
  LDelete: boolean;
begin
  Result := 0;
  LExpandedPaths := TLibraryPaths.Create;
  try
    LIdx := 0;
    ALibraryPaths.Sort;
    while LIdx < ALibraryPaths.Count do
    begin
      LDelete := False;
      LPath := ALibraryPaths.Path[LIdx].Path;
      LPathType := ALibraryPaths.Path[LIdx].PathType;
      LPath := (ExpandLibraryPath(LPath, ALibrary));
      if Pos('$', LPath) > 0 then
      begin
        // expansion incomplete, return to orginal path
        LPath := ALibraryPaths.Path[LIdx].Path;
      end;

      if LExpandedPaths.FindByIndex(LPath, LPathType) = -1 then
      begin
        LExpandedPaths.Add(LPath, LPathType);
      end
      else
      begin
        LDelete := true;
      end;

      if LDelete then
      begin
        Log('Removing duplicate path: %s, type: %s',
          [ALibraryPaths.Path[LIdx].Path,
          TLibraryPath.PathTypeToString(ALibraryPaths.Path[LIdx].PathType)]);
        ALibraryPaths.Delete(LIdx);
        Inc(Result);
      end
      else
      begin
        Inc(LIdx);
      end;
    end;
  finally
    FreeAndNil(LExpandedPaths);
  end;

end;

procedure TDelphiInstallation.DeleteAll(APathType: TLibraryPathType);
begin
  FLibraryAndroid32.Clear(APathType);
  FLibraryIOS32.Clear(APathType);
  FLibraryIOS64.Clear(APathType);
  FLibraryIOSSimulator.Clear(APathType);
  FLibraryOSX32.Clear(APathType);
  FLibraryWin32.Clear(APathType);
  FLibraryWin64.Clear(APathType);
  FLibraryLinux64.Clear(APathType);
end;

function TDelphiInstallation.ExecuteFile(const Operation, FileName, Params,
  DefaultDir: string; ShowCmd: word): integer;
var
  zFileName, zParams, zDir: array [0 .. 255] of char;
begin
  Result := ShellExecute(Application.Handle, PChar(Operation),
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

function TDelphiInstallation.GetLibraryAndroid32: string;
begin
  Result := GetLibraryPathAsString(FLibraryAndroid32);
end;

function TDelphiInstallation.GetLibraryIOS32: string;
begin
  Result := GetLibraryPathAsString(FLibraryIOS32);
end;

function TDelphiInstallation.GetLibraryIOS64: string;
begin
  Result := GetLibraryPathAsString(FLibraryIOS64);
end;

function TDelphiInstallation.GetLibraryIOSSimulator: string;
begin
  Result := GetLibraryPathAsString(FLibraryIOSSimulator);
end;

function TDelphiInstallation.GetLibraryLinux64: string;
begin
  Result := GetLibraryPathAsString(FLibraryLinux64);
end;

function TDelphiInstallation.GetLibraryName(ALibrary: TDelphiLibrary): string;
var
  LLibraryHelper: TLibraryHelper;
begin
  LLibraryHelper := TLibraryHelper.Create;
  try
    Result := LLibraryHelper.GetLibraryName(ALibrary);
  finally
    FreeAndNil(LLibraryHelper);
  end;
end;

function TDelphiInstallation.GetLibraryOSX32: string;
begin
  Result := GetLibraryPathAsString(FLibraryOSX32);
end;

function TDelphiInstallation.GetLibraryPathAsString
  (AStrings: TLibraryPaths): string;
begin
  Result := AStrings.AsString(FLibraryPathType);
end;

function TDelphiInstallation.GetLibraryWin32: string;
begin
  Result := GetLibraryPathAsString(FLibraryWin32);
end;

function TDelphiInstallation.GetLibraryWin64: string;
begin
  Result := GetLibraryPathAsString(FLibraryWin64);
end;

function TDelphiInstallation.GetProductName: string;
var
  LProductVersion: integer;
begin
  LProductVersion := GetProductVersion;
  case LProductVersion of
    28:
      Result := 'Delphi Alexandria';
    27:
      Result := 'Delphi Sydney';
    26:
      Result := 'Delphi Rio';
    25:
      Result := 'Delphi Tokyo';
    24:
      Result := 'Delphi Berlin';
    23:
      Result := 'Delphi Seattle';
    22:
      Result := 'Delphi XE8';
    21:
      Result := 'Delphi XE7';
    20:
      Result := 'Delphi XE6';
    19:
      Result := 'Delphi XE5';
    18:
      Result := 'Delphi XE4';
    17:
      Result := 'Delphi XE3';
    16:
      Result := 'Delphi XE2';
    15:
      Result := 'Delphi XE';
    14:
      Result := 'Delphi 2010';
    12:
      Result := 'Delphi 2009';
    11:
      Result := 'Delphi 2007';
    10:
      Result := 'Delphi 2006';
    9:
      Result := 'Delphi 2005';
    8:
      Result := 'Delphi 8';
    7:
      Result := 'Delphi 7';
    6:
      Result := 'Delphi 6';
    5:
      Result := 'Delphi 5';
    4:
      Result := 'Delphi 4';
    3:
      Result := 'Delphi 3';
    2:
      Result := 'Delphi 2';
    1:
      Result := 'Delphi 1';

  else
    Result := Format('Unknown Version %d', [LProductVersion]);
  end;
end;

function TDelphiInstallation.GetProductVersion: integer;
var
  LRegistry: TRegistry;
begin
  Result := -1;
  LRegistry := TRegistry.Create;
  try
    LRegistry.RootKey := HKEY_CURRENT_USER;
    if LRegistry.OpenKeyReadOnly(FRegistryKey) then
    begin
      Result := StrToIntDef(LRegistry.ReadString('ProductVersion'), -1);
    end;
  finally
    FreeAndNil(LRegistry);
  end;
end;

function TDelphiInstallation.GetRootPath: string;
var
  LRegistry: TRegistry;
begin
  Result := '';
  LRegistry := TRegistry.Create;
  try
    LRegistry.RootKey := HKEY_CURRENT_USER;
    if LRegistry.OpenKeyReadOnly(FRegistryKey) then
    begin
      Result := IncludeTrailingPathDelimiter(LRegistry.ReadString('RootDir'));
    end;
  finally
    FreeAndNil(LRegistry);
  end;
end;

procedure TDelphiInstallation.Save(ADeduplicate: boolean);
begin
  if ADeduplicate then
    Deduplicate;
  SaveEnvironmentVariables;
  SaveLibraries;
  // ForceEnvOptionsUpdate;
  NotifyEnvironmentChanges;
end;

procedure TDelphiInstallation.SaveEnvironmentVariables;
var
  LRegistry: TRegistry;
  LLibraryKey: string;
  LValues: TStringList;
  LIdx: integer;
begin
  LRegistry := TRegistry.Create;
  LValues := TStringList.Create;
  try
    LRegistry.RootKey := HKEY_CURRENT_USER;
    LLibraryKey := IncludeTrailingBackslash(FRegistryKey);
    LLibraryKey := IncludeTrailingBackslash
      (LLibraryKey + 'Environment Variables');
    LRegistry.DeleteKey(LLibraryKey);
    if LRegistry.OpenKey(LLibraryKey, true) then
    begin
      for LIdx := 0 to PreD(FEnvironmentVariables.Count) do
      begin
        LRegistry.WriteString(FEnvironmentVariables.Variable[LIdx].Name,
          FEnvironmentVariables.Variable[LIdx].Value);
      end;
      LRegistry.CloseKey;
    end;
  finally
    FreeAndNil(LRegistry);
    FreeAndNil(LValues);
  end;
end;

procedure TDelphiInstallation.SaveLibraries;
var
  LPathType: TLibraryPathType;
begin
  for LPathType := dlpSearch to dlpDebugDCU do
  begin
    SaveLibrary('Android32', FLibraryAndroid32.AsDelimitedString(LPathType),
      LPathType);
    SaveLibrary('iOSDevice64', FLibraryIOS64.AsDelimitedString(LPathType),
      LPathType);
    SaveLibrary('iOSDevice32', FLibraryIOS32.AsDelimitedString(LPathType),
      LPathType);
    SaveLibrary('iOSSimulator', FLibraryIOSSimulator.AsDelimitedString
      (LPathType), LPathType);
    SaveLibrary('OSX32', FLibraryOSX32.AsDelimitedString(LPathType), LPathType);
    SaveLibrary('Win32', FLibraryWin32.AsDelimitedString(LPathType), LPathType);
    SaveLibrary('Win64', FLibraryWin64.AsDelimitedString(LPathType), LPathType);
    SaveLibrary('Linux64', FLibraryLinux64.AsDelimitedString(LPathType),
      LPathType);
  end;

end;

procedure TDelphiInstallation.SaveLibrary(ALibrary, AValue: string;
  APathType: TLibraryPathType);
var
  LRegistry: TRegistry;
  LLibraryKey: string;
  LName: string;
begin
  LRegistry := TRegistry.Create;
  try
    LRegistry.RootKey := HKEY_CURRENT_USER;
    LLibraryKey := IncludeTrailingBackslash(FRegistryKey);
    LLibraryKey := IncludeTrailingBackslash(LLibraryKey + 'Library');
    LLibraryKey := IncludeTrailingBackslash(LLibraryKey + ALibrary);
    if LRegistry.OpenKey(LLibraryKey, False) then
    begin
      case APathType of
        dlpSearch:
          LName := 'Search Path';
        dlpBrowse:
          LName := 'Browsing Path';
        dlpDebugDCU:
          LName := 'Debug DCU Path';
      else
        LName := '';
      end;
      if LName <> '' then
      begin
        Debug('SaveLibrary', 'Saving library %s name: %s, value: %s',
          [LLibraryKey, LName, AValue]);
        LRegistry.WriteString(LName, AValue);
      end;
    end;
  finally
    FreeAndNil(LRegistry);
  end;
end;

procedure TDelphiInstallation.SetLibraryAndroid32(const Value: string);
begin
  SetLibraryPathFromString(Value, FLibraryAndroid32, dlAndroid32);
end;

procedure TDelphiInstallation.SetLibraryIOS32(const Value: string);
begin
  SetLibraryPathFromString(Value, FLibraryIOS32, dlIOS32);
end;

procedure TDelphiInstallation.SetLibraryIOS64(const Value: string);
begin
  SetLibraryPathFromString(Value, FLibraryIOS64, dlIOS64);
end;

procedure TDelphiInstallation.SetLibraryIOSSimulator(const Value: string);
begin
  SetLibraryPathFromString(Value, FLibraryIOSSimulator, dlIOSimulator);
end;

procedure TDelphiInstallation.SetLibraryLinux64(const Value: string);
begin
  SetLibraryPathFromString(Value, FLibraryLinux64, dlLinux64);
end;

procedure TDelphiInstallation.SetLibraryOSX32(const Value: string);
begin
  SetLibraryPathFromString(Value, FLibraryOSX32, dlOSX32);
end;

procedure TDelphiInstallation.SetLibraryPathFromString(AString: string;
  AStrings: TLibraryPaths; ALibrary: TDelphiLibrary);
begin
  AStrings.FromString(AString, FLibraryPathType);
end;

procedure TDelphiInstallation.SetLibraryPathType(const Value: TLibraryPathType);
begin
  FLibraryPathType := Value;
end;

procedure TDelphiInstallation.SetLibraryWin32(const Value: string);
begin
  SetLibraryPathFromString(Value, FLibraryWin32, dlWin32);
end;

procedure TDelphiInstallation.SetLibraryWin64(const Value: string);
begin
  SetLibraryPathFromString(Value, FLibraryWin64, dlWin64);
end;

function TDelphiInstallation.GetLibraryPlatformName
  (ALibrary: TDelphiLibrary): string;
var
  LLibraryHelper: TLibraryHelper;
begin
  LLibraryHelper := TLibraryHelper.Create;
  try
    Result := LLibraryHelper.GetLibraryPlatformName(ALibrary);
  finally
    FreeAndNil(LLibraryHelper);
  end;
end;

{ TEnviromentVariable }

procedure TEnviromentVariable.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TEnviromentVariable.SetValue(const Value: string);
begin
  FValue := Value;
end;

{ TEnvironmentVariables }

function TEnvironmentVariables.Add(AName: string; AValue: string): integer;
var
  LEnviromentVariable: TEnviromentVariable;
begin
  LEnviromentVariable := FindVariable(AName);
  if Assigned(LEnviromentVariable) then
  begin
    Result := FEnviromentVariableList.IndexOf(LEnviromentVariable);
  end
  else
  begin
    LEnviromentVariable := TEnviromentVariable.Create;
    LEnviromentVariable.Name := AName;
    Result := FEnviromentVariableList.Add(LEnviromentVariable);
  end;
  LEnviromentVariable.Value := AValue;
end;

procedure TEnvironmentVariables.Clear;
begin
  FEnviromentVariableList.Clear;
end;

function TEnvironmentVariables.Count: integer;
begin
  Result := FEnviromentVariableList.Count;
end;

constructor TEnvironmentVariables.Create;
begin
  FEnviromentVariableList := TEnviromentVariableList.Create;
end;

destructor TEnvironmentVariables.Destroy;
begin
  try
    FreeAndNil(FEnviromentVariableList);
  finally
    inherited;
  end;
end;

function TEnvironmentVariables.FindVariable(AName: string): TEnviromentVariable;
var
  LIdx: integer;
begin
  Result := nil;
  LIdx := 0;
  while (LIdx < Count) and (Result = nil) do
  begin
    if SameText(FEnviromentVariableList.Items[LIdx].Name, AName) then
    begin
      Result := FEnviromentVariableList.Items[LIdx];
    end;
    Inc(LIdx);
  end;
end;

function TEnvironmentVariables.GetValue(AName: string): string;
var
  LEnviromentVariable: TEnviromentVariable;
begin
  Result := '';
  LEnviromentVariable := FindVariable(AName);
  if Assigned(LEnviromentVariable) then
  begin
    Result := LEnviromentVariable.Value;
  end;
end;

function TEnvironmentVariables.GetVariable(AIndex: integer)
  : TEnviromentVariable;
begin
  Result := FEnviromentVariableList.Items[AIndex];
end;

procedure TEnvironmentVariables.SetValue(AName: string; const Value: string);
var
  LEnviromentVariable: TEnviromentVariable;
begin
  LEnviromentVariable := FindVariable(AName);
  if Assigned(LEnviromentVariable) then
    LEnviromentVariable.Value := Value;
end;

end.
