unit AppInfo;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, IniFiles;

type
  TAppInfo = class(TPersistent)
  private
    FAppName: string;
    function GetListDefFile: string; virtual; abstract;
  protected
    function GetAppExeFile: string; virtual; abstract;
    function GetLocalPath: string; virtual; abstract;
    function GetLoginPass: string; virtual; abstract;
    function GetLoginUser: string; virtual; abstract;
    function GetProxyPort: string; virtual; abstract;
    function GetProxyServer: string; virtual; abstract;
    function GetRetryCount: Integer; virtual; abstract;
    function GetUpdateServer: string; virtual; abstract;
    procedure SetAppExeFile(const Value: string); virtual; abstract;
    procedure SetLocalPath(const Value: string); virtual; abstract;
    procedure SetLoginPass(const Value: string); virtual; abstract;
    procedure SetLoginUser(const Value: string); virtual; abstract;
    procedure SetProxyPort(const Value: string); virtual; abstract;
    procedure SetProxyServer(const Value: string); virtual; abstract;
    procedure SetRetryCount(const Value: Integer); virtual; abstract;
    procedure SetUpdateServer(const Value: string); virtual; abstract;
  public
    property AppExeFile: string read GetAppExeFile write SetAppExeFile;
    property AppName: string read FAppName write FAppName;
    property ListDefFile: string read GetListDefFile;
    property LocalPath: string read GetLocalPath write SetLocalPath;
    property LoginPass: string read GetLoginPass write SetLoginPass;
    property LoginUser: string read GetLoginUser write SetLoginUser;
    property ProxyPort: string read GetProxyPort write SetProxyPort;
    property ProxyServer: string read GetProxyServer write SetProxyServer;
    property RetryCount: Integer read GetRetryCount write SetRetryCount;
    property UpdateServer: string read GetUpdateServer write SetUpdateServer;
  end;
  
  TIniAppInfo = class(TAppInfo)
  private
    IniFile: TIniFile;
    function GetListDefFile: string; override;
  protected
    function GetAppExeFile: string; override;
    function GetLocalPath: string; override;
    function GetLoginPass: string; override;
    function GetLoginUser: string; override;
    function GetProxyPort: string; override;
    function GetProxyServer: string; override;
    function GetRetryCount: Integer; override;
    function GetUpdateServer: string; override;
    procedure SetAppExeFile(const Value: string); override;
    procedure SetLocalPath(const Value: string); override;
    procedure SetLoginPass(const Value: string); override;
    procedure SetLoginUser(const Value: string); override;
    procedure SetProxyPort(const Value: string); override;
    procedure SetProxyServer(const Value: string); override;
    procedure SetRetryCount(const Value: Integer); override;
    procedure SetUpdateServer(const Value: string); override;
  public
    constructor Create(IniFileName: string; Session: string);
    destructor Destroy; override;
  end;
  
  TAppInfoList = class(TPersistent)
  end;
  

implementation

{
********************************* TIniAppInfo **********************************
}
constructor TIniAppInfo.Create(IniFileName: string; Session: string);
begin
  inherited Create;
  IniFile := TIniFile.Create(IniFileName);
  AppName := Session;
end;

destructor TIniAppInfo.Destroy;
begin
  inherited Destroy;
  FreeAndNil(IniFile);
end;

function TIniAppInfo.GetAppExeFile: string;
begin
  Result := IniFile.ReadString(AppName, 'EXEFile', '');
end;

function TIniAppInfo.GetListDefFile: string;
begin
  // TODO -cMM: TIniAppInfo.GetListDefFile default body inserted
  Result := IniFile.ReadString(AppName, 'UpdateFileList', '');
end;

function TIniAppInfo.GetLocalPath: string;
begin
  Result := IniFile.ReadString(AppName, 'LocalPath', '');
  //为网络报表特意添加的
  if Result = '' then
    Result := ExtractFilePath(Application.ExeName);
end;

function TIniAppInfo.GetLoginPass: string;
begin
  Result := IniFile.ReadString(AppName, 'LoginPass', '');
end;

function TIniAppInfo.GetLoginUser: string;
begin
  Result := IniFile.ReadString(AppName, 'LoginUser', '');
end;

function TIniAppInfo.GetProxyPort: string;
begin
  Result := IniFile.ReadString(AppName, 'ProxyPort', '');
end;

function TIniAppInfo.GetProxyServer: string;
begin
  Result := IniFile.ReadString(AppName, 'ProxyServer', '');
end;

function TIniAppInfo.GetRetryCount: Integer;
begin
  // TODO -cMM: TIniAppInfo.GetRetryCount default body inserted
  Result := IniFile.ReadInteger(AppName, 'Retry', 50);;
end;

function TIniAppInfo.GetUpdateServer: string;
begin
  Result := IniFile.ReadString(AppName, 'UpdateServer', '');
  if (Copy(Result, Length(Result), 1) <> '/') then
    Result := Result + '/';
end;

procedure TIniAppInfo.SetAppExeFile(const Value: string);
begin
  IniFile.WriteString(AppName, 'ExeFile', Value);
end;

procedure TIniAppInfo.SetLocalPath(const Value: string);
begin
  IniFile.WriteString(AppName, 'LocalPath', Value);
end;

procedure TIniAppInfo.SetLoginPass(const Value: string);
begin
  IniFile.WriteString(AppName, 'LoginPass', Value);
end;

procedure TIniAppInfo.SetLoginUser(const Value: string);
begin
  IniFile.WriteString(AppName, 'LoginUser', Value);
end;

procedure TIniAppInfo.SetProxyPort(const Value: string);
begin
  IniFile.WriteString(AppName, 'ProxyPort', Value);
end;

procedure TIniAppInfo.SetProxyServer(const Value: string);
begin
  IniFile.WriteString(AppName, 'proxyServer', Value);
end;

procedure TIniAppInfo.SetRetryCount(const Value: Integer);
begin
  // TODO -cMM: TIniAppInfo.SetRetryCount default body inserted
  IniFile.WriteInteger(AppName, 'Retry', Value);
end;

procedure TIniAppInfo.SetUpdateServer(const Value: string);
begin
  IniFile.WriteString(AppName, 'UpdateServer', Value);
end;


end.
