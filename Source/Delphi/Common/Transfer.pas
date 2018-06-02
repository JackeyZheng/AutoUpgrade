unit Transfer;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, IdFTP, IdComponent, IdURI, Contnrs;


type
  TOnTransferStart = procedure (Sender: TObject; const AWorkCountMax: Integer)
          of object;
  TOnTransfer = procedure (Sender: TObject; const AWorkCount: Integer) of
          object;
  TOnTransferEnd = procedure (Sender: TObject) of object;
  
  TProxySeting = record
    ProxyServer: string;
    ProxyPort: Integer;
    ProxyUser: string;
    ProxyPass: string;
  end;
  
  TTransfer = class(TPersistent)
  private
    FCurrentDir: string;
    FFileName: string;
    FHost: string;
    FOnTransfer: TOnTransfer;
    FOnTransferEnd: TOnTransferEnd;
    FOnTransferStart: TOnTransferStart;
    FPassword: string;
    FPort: Integer;
    FURI: TIdURI;
    FURL: string;
    FUser: string;
    procedure SetHost(const Value: string); virtual;
  protected
    function GetOnStatus: TIdStatusEvent; virtual; abstract;
    procedure SetOnStatus(Value: TIdStatusEvent); virtual; abstract;
    procedure SetURI(Value: TIdURI); virtual;
  public
    procedure Abort; virtual; abstract;
    procedure Connect; virtual; abstract;
    procedure Get(FileName: String); overload; virtual; abstract;
    procedure Get(Stream: TStream); overload; virtual; abstract;
    procedure SetProxy(ProxyObj: TPersistent); overload; virtual; abstract;
    procedure SetProxy(ProxyInfo: TProxySeting); overload; virtual; abstract;
    procedure Work(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
        virtual;
    procedure WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure WorkStart(Sender: TObject; AWorkMode: TWorkMode; AWorkCountMax:
        int64); virtual;
    procedure ClearProxySeting; virtual; abstract;
    property CurrentDir: string read FCurrentDir write FCurrentDir;
    property FileName: string read FFileName write FFileName;
    property Host: string read FHost write SetHost;
    property Password: string read FPassword write FPassword;
    property Port: Integer read FPort write FPort;
    property URI: TIdURI read FURI write SetURI;
    property User: string read FUser write FUser;
    property URL: string read FURL write FURL;
  published
    property OnStatus: TIdStatusEvent read GetOnStatus write SetOnStatus;
    property OnTransfer: TOnTransfer read FOnTransfer write FOnTransfer;
    property OnTransferEnd: TOnTransferEnd read FOnTransferEnd write
            FOnTransferEnd;
    property OnTransferStart: TOnTransferStart read FOnTransferStart write
            FOnTransferStart;
  end;

  

  TFTPTransfer = class(TTransfer)
  private
    FIdfTP: TIdfTP;
    procedure SetHost(const Value: string); override;
  protected
    function GetOnStatus: TIdStatusEvent; override;
    procedure SetOnStatus(Value: TIdStatusEvent); override;
    procedure SetURI(Value: TIdURI); override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Abort; override;
    procedure Connect; override;
    procedure Get(FileName: String); overload; override;
    procedure Get(Stream: TStream); overload; override;
    procedure SetProxy(ProxyObj: TPersistent); overload; override;
    procedure SetProxy(ProxyInfo: TProxySeting); overload; override;
    procedure ClearProxySeting; override;
  end;
  
  TTransferFactory = class(TObject)
  private
    FIdURI: TIdURI;
    FObjectList: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    function CreateTransfer(URL:  String): TTransfer; overload;
    Function CreateTransfer(URL: String; ProxySeting: TProxySeting): TTransfer; overload;
  end;



  ExceptionNoSuport = class(Exception)
  end;
  

implementation

uses
  System.IOUtils, uHttpTransfer;

{
********************************** TTransfer ***********************************
}
procedure TTransfer.SetHost(const Value: string);
begin
  FHost := Value;
end;

procedure TTransfer.SetURI(Value: TIdURI);
begin
  // TODO -cMM: TTransfer.SetURI default body inserted
  //if Assigned(FURI) then FURI.Free;
  FURI := Value;
end;

procedure TTransfer.Work(Sender: TObject; AWorkMode: TWorkMode; AWorkCount:
    Int64);
begin
  if AWorkCount <> 0 then
  begin
    if Assigned(FOnTransfer) then
      FOnTransfer(Sender, AWorkCount);
    Application.ProcessMessages;
  end
end;

procedure TTransfer.WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  if Assigned(FOnTransferEnd) then
    FOnTransferEnd(Sender);
end;

procedure TTransfer.WorkStart(Sender: TObject; AWorkMode: TWorkMode;
    AWorkCountMax: int64);
begin
  if AWorkCountMax <> 0 then
  begin
    if Assigned(FOnTransferStart) then
      FOnTransferStart(Sender, AWorkCountMax);
  end;
end;

{
********************************* TFTPTransfer *********************************
}
constructor TFTPTransfer.Create;
begin
  inherited Create;
  FIdFTP := TIdFTP.Create(nil);
//  FIdFtp.OnWorkBegin := Self.WorkStart;
//  FIdFtp.OnWork := Self.Work;
//  FIdFtp.OnWorkEnd := Self.WorkEnd;
//  FIdFtp.re := 8192;
  //FIdFtp.TransferTimeout := 50000;
  //FIdFtp.SendBufferSize := 4096;
  FIdFtp.Passive := true;
  self.Port := 21;
end;

destructor TFTPTransfer.Destroy;
begin
  if Assigned(FIdFtp) then
  begin
    FIdFtp.Disconnect;
    FreeAndNil(FIdFTP);
  end;
  inherited Destroy;
end;

procedure TFTPTransfer.Abort;
begin
  FIdFtp.Abort;
end;

procedure TFTPTransfer.Connect;
begin
  try
    FIdFtp.Host := self.Host;
    FIdFtp.Username := self.User;
    FidFtp.Password := self.Password;
    FIdFtp.Connect();
    if (FidFtp.Username <> 'Anonymous') then
      FIdFtp.Login;
  except
    raise;
  end;
end;

procedure TFTPTransfer.Get(FileName: String);
var
  temp: Int64;
begin
  try
    if (not FIdFTP.Connected) then
      Connect();
    FIdFtp.ChangeDir(self.CurrentDir);
    if not DirectoryExists(ExtractFilePath(FileName)) then
      TDirectory.CreateDirectory(ExtractFilePath(FileName));
    temp := FIdFtp.Size(self.FileName);
    if temp > 10240 then
    begin
      FIdFtp.OnWorkBegin := Self.WorkStart;
      FIdFtp.OnWork := Self.Work;
      FIdFtp.OnWorkEnd := Self.WorkEnd;
      if Assigned(FIdfTP.OnWorkBegin) then
        FIdfTP.OnWorkBegin(FIdfTP, wmRead, temp);
    end
    else
    begin
      FIdFtp.OnWorkBegin := nil;
      FIdFtp.OnWork := nil;
      FIdFtp.OnWorkEnd := nil;
    end;
    FIdFtp.Get(self.FileName, FileName, true);
  except
    raise;
  end;
end;

procedure TFTPTransfer.Get(Stream: TStream);
begin
  try
    if (not FIdFTP.Connected) then
      Connect();
    FIdFtp.ChangeDir(self.CurrentDir);
    FIdFtp.Get(self.FileName, Stream, true);
    FIdFtp.Disconnect;
  except
    raise;
  end;
end;

function TFTPTransfer.GetOnStatus: TIdStatusEvent;
begin
  Result := FIdFtp.OnStatus
end;

procedure TFTPTransfer.SetHost(const Value: string);
begin
  if (Host <> '') then
   if (Host <> Value) then
      FIdFtp.Disconnect;
  inherited SetHost(Value);
end;

procedure TFTPTransfer.SetOnStatus(Value: TIdStatusEvent);
begin
  FIdFtp.OnStatus := Value;
end;

procedure TFTPTransfer.SetProxy(ProxyObj: TPersistent);
begin
  FIdFtp.ProxySettings.Assign(ProxyObj);
end;

procedure TFTPTransfer.SetProxy(ProxyInfo: TProxySeting);
begin
  FIdFtp.ProxySettings.ProxyType := fpcmUserSite;
  FIdFtp.ProxySettings.Host := ProxyInfo.ProxyServer;
  FIdFtp.ProxySettings.UserName := ProxyInfo.ProxyUser;
  FIdFtp.ProxySettings.Port := ProxyInfo.ProxyPort;
  FIdFtp.ProxySettings.Password := ProxyInfo.ProxyPass;
end;

procedure TFTPTransfer.ClearProxySeting;
begin
  // TODO -cMM: TFTPTransfer.ClearProxySeting default body inserted
  inherited;
  FIdFtp.ProxySettings.ProxyType := fpcmNone;
end;

procedure TFTPTransfer.SetURI(Value: TIdURI);
begin
  // TODO -cMM: TFTPTransfer.SetURI default body inserted
  //if Assigned(FURI) then FURI.Free;
  inherited;
  Self.URL := Value.URI;
  self.Host := FURI.Host;
  if trim(FURI.Username) = '' then
    self.User := 'Anonymous'
  else
    self.User := FURI.Username;
  self.Password := FURI.Password;
  if trim(FURI.Path) = '' then
    Self.CurrentDir := '/'
  else
    self.CurrentDir := FURI.Path;
  self.FileName := FURI.Document;
  if (FURI.Port = '') then
    self.Port := 21
  else
    self.Port := StrToInt(FURI.Port);
end;

{
******************************* TTransferFactory *******************************
}
constructor TTransferFactory.Create;
begin
  inherited Create;
  FObjectList := TObjectList.Create;
  FIdURI := TIdURI.Create;
end;

destructor TTransferFactory.Destroy;
begin
  FreeAndNil(FObjectList);
  FreeAndNil(FIdURI);
  inherited Destroy;
end;

function TTransferFactory.CreateTransfer(URL:  String): TTransfer;
var
  Index: Integer;
begin
  //测试代理的代码
  //ProxyObj := TIdFtpProxySettings.Create;
  //ProxyObj.Host := '192.168.168.163';
  //ProxyObj.ProxyType := fpcmUserSite;
  //ProxyObj.Port := 2121;

  FIdURI.URI := URL;
  if AnsiUpperCase(FIdURI.Protocol) = 'FTP' then
  begin
    Index := FObjectList.FindInstanceOf(TFTPTransfer);
    if Index <> -1 then
      Result := FObjectList.Items[Index] as TTransfer
    else
    begin
    begin
      Result := TFTPTransfer.Create;
      FObjectList.Add(Result);
    end;
    end;
  end
  else if AnsiUpperCase(FIdURI.Protocol) = 'HTTP' then
  begin
    Index := FObjectList.FindInstanceOf(THTTPTransfer);
    if Index <> -1 then
      Result := FObjectList.Items[Index] as TTransfer
    else
    begin
      Result := THTTPTransfer.Create;
      FObjectList.Add(Result);
    end;
  end
  else if AnsiUpperCase(FIdURI.Protocol) = 'HTTPS' then
  begin
    Index := FObjectList.FindInstanceOf(THTTPSTransfer);
    if Index <> -1 then
      Result := FObjectList.Items[Index] as TTransfer
    else
    begin
      Result := THTTPSTransfer.Create;
      FObjectList.Add(Result);
    end;
  end
  else
    raise ExceptionNoSuport.Create('不支持的网络协议！');

  Result.URI := FIdURI;
end;


function TTransferFactory.CreateTransfer(URL: String;
  ProxySeting: TProxySeting): TTransfer;
begin
  Result := CreateTransfer(URL);
  Result.SetProxy(ProxySeting);
end;



end.
