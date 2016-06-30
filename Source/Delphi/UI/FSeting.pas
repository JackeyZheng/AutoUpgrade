unit FSeting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, AppInfo;

type
  TfrmSeting = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    txtServer: TEdit;
    GroupBox1: TGroupBox;
    chkNeedLogin: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    txtLoginPass: TEdit;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    txtProxyServer: TEdit;
    Label5: TLabel;
    txtProxyPort: TEdit;
    txtLoginUser: TEdit;
    chkUseProxy: TCheckBox;
    TabSheet3: TTabSheet;
    chkUserSkin: TCheckBox;
    lstSkin: TListBox;
    Label6: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkNeedLoginClick(Sender: TObject);
    procedure chkUseProxyClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure chkUserSkinClick(Sender: TObject);
    procedure lstSkinDblClick(Sender: TObject);
  private
    FAppName: string;
    FAppInfo: TAppInfo;
    procedure SetAppName(const Value: string);
    Procedure GetSkinList;
    { Private declarations }
  public
    //SkinRef: TSkinData;
    destructor Destory;
    property AppName: string read FAppName write SetAppName;
    { Public declarations }
  end;

var
  frmSeting: TfrmSeting;

implementation

{$R *.dfm}

procedure TfrmSeting.Button2Click(Sender: TObject);
begin
  Close();
end;

procedure TfrmSeting.SetAppName(const Value: string);
begin
  // TODO -cMM: TfrmSeting.SetAppName default body inserted
  FAppName := Value;
  if (not Assigned(FAppInfo)) then
    FAppInfo := TIniAppInfo.Create(ExtractFilePath(Application.ExeName) + 'UpdateApps.ini', FAppName)
  else
    FAppInfo.AppName := Value;
end;

procedure TfrmSeting.FormShow(Sender: TObject);
begin
  GetSkinList;
  txtServer.Text := FAppInfo.UpdateServer;
  if (FAppInfo.LoginUser <> '') then
  begin
    chkNeedLogin.Checked := true;
    txtLoginUser.Text := FAppInfo.LoginUser;
    txtLoginPass.Text := FAppInfo.LoginPass;
  end
  else
  begin
    chkNeedLogin.Checked := false;
    txtLoginUser.Text := '';
    txtLoginPass.Text := '';
  end;
  if (FAppInfo.ProxyServer <> '') then
  begin
    chkUseProxy.Checked := true;
    txtProxyServer.Text := FAppInfo.ProxyServer;
    txtProxyPort.Text := FAppInfo.ProxyPort;
  end
  else
  begin
    chkUseProxy.Checked := false;
    txtProxyServer.Text := '';
    txtProxyPort.Text := '';
  end;
end;

procedure TfrmSeting.chkNeedLoginClick(Sender: TObject);
begin
  txtLoginUser.Enabled := chkNeedLogin.Checked;
  txtLoginPass.Enabled := chkNeedLogin.Checked;
end;

procedure TfrmSeting.chkUseProxyClick(Sender: TObject);
begin
  txtProxyServer.Enabled := chkUseProxy.Checked;
  txtProxyPort.Enabled := chkUseProxy.Checked;
end;

procedure TfrmSeting.Button1Click(Sender: TObject);
begin
  FAppInfo.UpdateServer := trim(txtServer.Text);
  {if (chkNeedLogin.Checked) then
  begin
    FAppInfo.LoginUser := Trim(txtLoginUser.Text);
    FAppInfo.LoginPass := Trim(txtLoginPass.Text);
  end
  else
  begin
    FAppInfo.LoginUser := '';
    FAppInfo.LoginPass := '';
  end;}
  if (chkUseProxy.Checked) then
  begin
    FAppInfo.ProxyServer := Trim(txtProxyServer.Text);
    FAppInfo.ProxyPort := Trim(txtProxyPort.Text);
  end
  else
  begin
    FAppInfo.ProxyServer := '';
    FAppInfo.ProxyPort := '';
  end;
  Close();
end;

destructor TfrmSeting.Destory;
begin
  // TODO -cMM: TfrmSeting.Destory default body inserted
  if Assigned(FAppInfo) then
    FreeAndNil(FAppInfo);
  inherited;
end;

procedure TfrmSeting.GetSkinList;
var
  Paths: String;
begin
//  if SkinRef.SkinFile <> '' then
//  begin
//    chkUserSkin.Checked := true;
//    lstSkin.ItemIndex := lstSkin.Items.IndexOf(SkinRef.SkinFile);
//  end
//  else
//    chkUserSkin.Checked := false;
//
//  lstSkin.Enabled := chkUserSkin.Checked;
//  lstSkin.Items.Clear;
  Paths := ExtractFilePath(Application.ExeName) + 'Skins\*.*';
//  取得Skin文件列表
  lstSkin.Perform(LB_DIR, DDL_ARCHIVE or DDL_EXCLUSIVE or DDL_READWRITE, Integer(Pchar(Paths)));
end;

procedure TfrmSeting.chkUserSkinClick(Sender: TObject);
begin
  lstSkin.Enabled := chkUserSkin.Checked;
//  if not chkUserSkin.Checked then
//  begin
//    SkinRef.SkinFile := '';
//    if SkinRef.Active then
//      SkinRef.Active := false;
//  end;
end;

procedure TfrmSeting.lstSkinDblClick(Sender: TObject);
begin
//  try
//    SkinRef.SkinFile := 'Skins\' + lstSkin.Items[lstSkin.ItemIndex];
//    if not SkinRef.Active then
//      SkinRef.Active := true;
//  except
//    Application.MessageBox('启用皮肤错误', '系统提示');
//  end;
end;

end.
