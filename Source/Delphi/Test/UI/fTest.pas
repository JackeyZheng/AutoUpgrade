unit fTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AppInfo, Analyse,Transfer, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    lbl1: TLabel;
    lst1: TListBox;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAnalyse: TAnalyse;
    FAppInfo: TAppinfo;
    FUpateList: TStrings;
    FTransferFactory: TTransferFactory;
    function CreateTransfer(URL: String): TTransfer;
    { Private declarations }
  public
    { Public declarations }
  end;
const
  UpdateAppIniFileName = 'UpdateApps.ini';
var
  Form2: TForm2;

implementation

uses
  System.IniFiles;

{$R *.dfm}

function TForm2.CreateTransfer(URL: String): TTransfer;
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

procedure TForm2.FormDestroy(Sender: TObject);
begin
  if Assigned(FAppInfo) then
    FreeAndNil(FAppinfo);
  if Assigned(FAnalyse) then
    FreeAndNil(FAnalyse);
  if Assigned(FUpateList) then
    FreeAndNil(FUpateList);
  FreeAndNil(FTransferFactory);
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  IniFile: TInifile;
  Section: String;

begin
  FTransferFactory := TTransferFactory.Create;
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    Section := IniFile.ReadString('Application', 'ApplicationName', '');
    if Section <> '' then
    begin
      FAppInfo := TIniAppInfo.Create(ExtractFilePath(Application.ExeName) + UpdateAppIniFileName, Section);
      FAppInfo.AppName := Section;
      FAnalyse := TXMLAnalyse.Create;
      FAnalyse.UpdateList := FAppInfo.UpdateServer  + FAppInfo.ListDefFile;
      FAnalyse.Transfer := CreateTransfer(FAnalyse.UpdateList);
      FUpateList := FAnalyse.GetUpdateList;
      lbl1.Caption := Format('一共有%d个文件需要更新', [FUpateList.Count]);
      lst1.Items.Assign(FUpateList);
    end;
  finally
    FreeAndNil(IniFile);
  end;
  //if Assigned(FAppInfo) then

end;

end.
