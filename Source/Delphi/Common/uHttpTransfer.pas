unit uHttpTransfer;

interface

uses
  Transfer, IdComponent, System.Classes, IdHTTP, System.SysUtils, IdURI;

type
  THTTPTransfer = class(TTransfer)
  private
    FidHttp: TIdHttp;
    procedure InitHttp;
  protected
    function  GetOnStatus: TIdStatusEvent; override;
    procedure SetOnStatus(Value: TIdStatusEvent); override;
    procedure SetURI(Value: TIdURI); override;
  public
    destructor Destroy; override;
    procedure Abort; override;
    procedure ClearProxySeting; override;
    procedure Connect; override;
    procedure Get(FileName: String); overload; override;
    procedure Get(Stream: TStream); overload; override;
    procedure SetProxy(ProxyObj: TPersistent); overload; override;
    procedure SetProxy(ProxyInfo: TProxySeting); overload; override;
  end;

  THTTPSTransfer = class(THTTPTransfer)
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.IOUtils, IdSSLOpenSSL;

destructor THTTPTransfer.Destroy;
begin
  if Assigned(fIdHttp) then
  begin
    fIdHttp.Disconnect;
    FreeAndNil(fIdHttp);
  end;
  inherited Destroy;
  // TODO -cMM: THTTPTransfer.Destroy default body inserted
end;

procedure THTTPTransfer.Abort;
begin
  FidHttp.Disconnect;
end;

procedure THTTPTransfer.ClearProxySeting;
begin
  InitHttp;
  FidHttp.ProxyParams.Clear;
end;

procedure THTTPTransfer.Connect;
begin
  FidHttp.Connect;
  inherited;
end;

procedure THTTPTransfer.Get(FileName: String);
var
  Position, DataLength: Int64;
  FileStream: TFileStream;
  //MemStream: TMemoryStream;
  i: integer;
  bError: Boolean;
begin
  if not DirectoryExists(ExtractFilePath(FileName)) then
    TDirectory.CreateDirectory(ExtractFilePath(FileName));
  if Tfile.Exists(FileName) then
    FileStream := TFileStream.Create(FileName, fmOpenReadWrite)
  else
    FileStream := TFileStream.Create(FileName, fmCreate);

  FileStream.Seek(0, soEnd);
  //MemStream := TMemoryStream.Create;
  try
    InitHttp;
    bError := False;
    for I := 0 to 99 do
    begin
      try
        FidHttp.Head(Self.URI.URLEncode(Self.URL));
        DataLength := FIdHTTP.Response.ContentLength;
        bError := False;
        Break;
      except
        bError := true;
        sleep(50);
        InitHttp;
        Continue;
      end;
    end;

    if bError then
      raise Exception.Create('获取文件大小错误！')
    else
    begin
      Position := FileStream.Position;
      if Position - DataLength < 0 then
      begin
        bError := False;
        for I := 0 to 99 do
        begin
          FidHttp.Head(Self.URI.URLEncode(Self.URL));
          Position := FileStream.Position;
          FIdHttp.Request.Range := Format('%d-%d', [Position, DataLength]);
          try
            //MemStream.Position := 0;
            FIdHTTP.Get(Self.URI.URLEncode(Self.URL), FileStream);
            bError := False;
            //MemStream.SaveToStream(FileStream);
            Break;
          except
            bError := true;
            InitHttp;
            Sleep(50);
            Continue;
          end;
        end;
        if bError then
        begin
          raise Exception.Create('传输时发生错误，请检查您的网络环境！');
        end;
      end
      else
        OnTransferEnd(nil);
    end;
  finally
    //FreeAndNil(MemStream);
    FreeAndNil(FileStream);
  end;
end;

procedure THTTPTransfer.Get(Stream: TStream);
var
  i: Integer;
  bError: Boolean;
begin
  bError := False;
  for i := 0 to 99 do
  begin
    try
      FidHttp.Head(Self.URI.URLEncode(Self.URL));
      FidHttp.Get(Self.URI.URI, Stream);
      bError := false;
      Break;
    except
      bError := true;
      Sleep(50);
      InitHttp;
      Continue;
    end;
  end;
  if bError then
    raise Exception.Create('获取更新错误！');
end;

function THTTPTransfer.GetOnStatus: TIdStatusEvent;
begin
  Result := FidHttp.OnStatus;
end;

procedure THTTPTransfer.InitHttp;
begin
  // TODO -cMM: THTTPTransfer.InitHttp default body inserted
  if Assigned(FidHttp) then
    FreeAndNil(FIdhttp);
  FidHttp := TIdHTTP.Create(nil);
  FIdHTTP.Request.Range := '';
  FidHttp.HandleRedirects := true;
  FIdHTTP.OnWorkBegin := Self.WorkStart;
  FIdHTTP.OnWork := Self.Work;
  FIdHTTP.OnWorkEnd := Self.WorkEnd;
  FidHttp.ConnectTimeout := 3000;
  FidHttp.ReadTimeout := 3000;
end;

procedure THTTPTransfer.SetOnStatus(Value: TIdStatusEvent);
begin
  FidHttp.OnStatus := Value;
end;

procedure THTTPTransfer.SetProxy(ProxyObj: TPersistent);
begin
  inherited;
  FidHttp.ProxyParams.Assign(ProxyObj);
end;

procedure THTTPTransfer.SetProxy(ProxyInfo: TProxySeting);
begin
  FidHttp.ProxyParams.ProxyServer := proxyInfo.ProxyServer;
  FidHttp.ProxyParams.ProxyPort := ProxyInfo.ProxyPort;
  FidHttp.ProxyParams.ProxyUsername := ProxyInfo.ProxyUser;
  FidHttp.ProxyParams.ProxyPassword := ProxyInfo.ProxyPass;
end;

procedure THTTPTransfer.SetURI(Value: TIdURI);
begin
  // TODO -cMM: THTTPTransfer.SetURI default body inserted
  //if Assigned(FURI) then FURI.Free;
  inherited;
  Self.URL := Value.URI;
  self.Host := URI.Host;
  if trim(URI.Username) = '' then
    self.User := 'Anonymous'
  else
    self.User := URI.Username;
  self.Password := URI.Password;
  if trim(URI.Path) = '' then
    Self.CurrentDir := '/'
  else
    self.CurrentDir := URI.Path;
  self.FileName := URI.Document;
  if (URI.Port = '') then
    self.Port := 80
  else
    self.Port := StrToInt(URI.Port);
end;

constructor THTTPSTransfer.Create;
begin
  inherited;
  FidHttp.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  // TODO -cMM: THTTPSTransfer.Create default body inserted
end;

destructor THTTPSTransfer.Destroy;
begin
  if Assigned(FidHttp) then
    if Assigned(FidHttp.IOHandler) then
      FidHttp.IOHandler.Free;
  inherited Destroy;
  // TODO -cMM: THTTPSTransfer.Destroy default body inserted
end;

end.
