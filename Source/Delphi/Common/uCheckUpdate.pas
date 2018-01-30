unit uCheckUpdate;

interface

uses
  Analyse,System.Classes, AppInfo, System.IniFiles, Transfer,
  System.SysUtils,Vcl.Forms;

type
  TCheckUpdateThread = class(TThread)
      procedure CheckUpdates;
    private
      FOnExecuteResult: TOnResult;
    public
    protected
      procedure Execute; override;
      procedure ExecuteResult(str: TStrings);
  published
      property OnExecuteResult: TOnResult read FOnExecuteResult write
          FOnExecuteResult;
  end;

procedure CheckUpdate(OnExecuteResult: TOnResult);

const
  UpdateAppIniFileName = 'UpdateApps.ini';

implementation

procedure CheckUpdate(OnExecuteResult: TOnResult);
var
  t: TCheckUpdateThread;
begin
  t := TCheckUpdateThread.Create;
  t.OnExecuteResult := OnExecuteResult;
  t.FreeOnTerminate := True;
  t.Resume;
end;

procedure TCheckUpdateThread.CheckUpdates;
var
  IniFile: TInifile;
  Section: String;
  FAnalyse: TAnalyse;
  FAppInfo: TAppinfo;
  FUpdateList: TStrings;
  FTransferFactory: TTransferFactory;

  function CreateTransfer(URL: String): TTransfer;
  var
    ProxySeting: TProxySeting;
  begin
    Result := FTransferFactory.CreateTransfer(URL);
    if FAppInfo.ProxyServer <> '' then
    begin
      ProxySeting.ProxyServer := FAppInfo.ProxyServer;
      ProxySeting.ProxyPort := StrToInt(FAppInfo.ProxyPort);
      ProxySeting.ProxyUser := FAppInfo.LoginUser;
      ProxySeting.ProxyPass := FAppInfo.LoginPass;
      Result.SetProxy(ProxySeting);
    end
    else
      Result.ClearProxySeting;
  end;
begin
  FTransferFactory := TTransferFactory.Create;
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    Section := IniFile.ReadString('Application', 'ApplicationName', '');
    if Section <> '' then
    begin
      FAppInfo := TIniAppInfo.Create(ExtractFilePath(Application.ExeName) + UpdateAppIniFileName, Section);
      FAnalyse := TXMLAnalyse.Create;
      FAppInfo.AppName := Section;
      FAnalyse.UpdateList := FAppInfo.UpdateServer  + FAppInfo.ListDefFile;
      FAnalyse.Transfer := CreateTransfer(FAnalyse.UpdateList);
      FUpdateList := FAnalyse.GetUpdateList;
      ExecuteResult(FUpdateList);
    end;
  finally
    FreeAndNil(IniFile);
    if Assigned(FAppInfo) then
      FreeAndNil(FAppinfo);
    if Assigned(FAnalyse) then
      FreeAndNil(FAnalyse);
    FreeAndNil(FTransferFactory);
  end;

end;

procedure TCheckUpdateThread.Execute;
begin
  inherited;
  CheckUpdates;
end;

procedure TCheckUpdateThread.ExecuteResult(str: TStrings);
begin
  if Assigned(FOnExecuteResult) then FOnExecuteResult(str);
end;

end.
