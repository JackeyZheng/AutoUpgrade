unit uHttpTransfer;

interface

uses
  Transfer, IdComponent, System.Classes, IdHTTP, System.SysUtils, IdURI;

type
  THTTPTransfer = class(TTransfer)
  private
    FidHttp: TIdHttp;
  protected
    function  GetOnStatus: TIdStatusEvent; override;
    procedure SetOnStatus(Value: TIdStatusEvent); override;
    procedure SetURI(Value: TIdURI); override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Abort; override;
    procedure ClearProxySeting; override;
    procedure Connect; override;
    procedure Get(FileName: String); overload; override;
    procedure Get(Stream: TStream); overload; override;
    procedure SetProxy(ProxyObj: TPersistent); overload; override;
    procedure SetProxy(ProxyInfo: TProxySeting); overload; override;
  end;

implementation

uses
  System.IOUtils;

constructor THTTPTransfer.Create;
begin
  inherited;
  FidHttp := TIdHTTP.Create(nil);
  // TODO -cMM: THTTPTransfer.Create default body inserted
end;

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
  FidHttp.ProxyParams.Clear;
end;

procedure THTTPTransfer.Connect;
begin
  FidHttp.Connect;
  inherited;
end;

procedure THTTPTransfer.Get(FileName: String);
var
  temp: Int64;
  FileStream: TFileStream;
  memstream: TMemoryStream;
begin
  try
    if not DirectoryExists(ExtractFilePath(FileName)) then
      TDirectory.CreateDirectory(ExtractFilePath(FileName));
    if Tfile.Exists(FileName) then
      FileStream := TFileStream.Create(FileName, fmOpenReadWrite)
    else
      FileStream := TFileStream.Create(FileName, fmCreate);

    FileStream.Seek(0, soEnd);
    memstream := TMemoryStream.Create;
    try
      FIdHTTP.Request.Range := '';
      FidHttp.HandleRedirects := true;
      FidHttp.Head(Self.URI.URLEncode(Self.URL));
      temp := FIdHTTP.Response.ContentLength;


      if temp > 10240 then
      begin
        FIdHTTP.OnWorkBegin := Self.WorkStart;
        FIdHTTP.OnWork := Self.Work;
        FIdHTTP.OnWorkEnd := Self.WorkEnd;
      end
      else
      begin
        FIdHTTP.OnWorkBegin := nil;
        FIdHTTP.OnWork := nil;
        FIdHTTP.OnWorkEnd := nil;
      end;
      if FileStream.Position - FIdHTTP.Response.ContentLength < 0 then
      begin
        FidHttp.ReadTimeout := 3000;
        FIdHttp.Request.Range := Format('%d-%d', [FileStream.Position, FIdHTTP.Response.ContentLength]);

        //FIdHTTP.Get(Self.URI.URLEncode(Self.URL), FileStream);
        FIdHTTP.Get(Self.URI.URLEncode(Self.URL), memstream);
        memstream.SaveToStream(FileStream);
      end;
    finally
      FreeAndNil(FileStream);
      FreeAndNil(memstream);
    end;
  except
    raise;
  end;
end;

procedure THTTPTransfer.Get(Stream: TStream);
begin
  try
    FidHttp.Get(Self.URI.URI, Stream);
  except
    raise;
  end;
end;

function THTTPTransfer.GetOnStatus: TIdStatusEvent;
begin
  Result := FidHttp.OnStatus;
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

end.
