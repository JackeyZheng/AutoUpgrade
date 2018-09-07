unit FUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, XPMan, ExtCtrls, IniFiles,
  AppInfo, Transfer, IdComponent, Analyse, auHTTP, auAutoUpgrader;


{$R ..\Res\Res.res}

const  MAX_PAGES = 3;
const  BMP_START = 101;

type
  TfrmAutoUpdate = class(TForm)
    Image1: TImage;
    XPManifest1: TXPManifest;
    PcWizard: TPageControl;
    tbsWellCome: TTabSheet;
    tbsGetUpdate: TTabSheet;
    Label1: TLabel;
    cmdPrev: TButton;
    cmdNext: TButton;
    Button3: TButton;
    Button4: TButton;
    lbAppList: TListBox;
    Button5: TButton;
    Label2: TLabel;
    Label3: TLabel;
    lblTotalSize: TLabel;
    ProgressBar1: TProgressBar;
    lbUpdateList: TListBox;
    tbsDownload: TTabSheet;
    Memo1: TMemo;
    tbsFilsh: TTabSheet;
    Label4: TLabel;
    pbDetail: TProgressBar;
    pbMaster: TProgressBar;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    tbNoUpdate: TTabSheet;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    lblStatuse: TLabel;
    atpgrdr1: TauAutoUpgrader;
    tmr1: TTimer;
    procedure FormDestroy(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure cmdPrevClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure PcWizardChange(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure tbsGetUpdateShow(Sender: TObject);
    procedure tbsWellComeShow(Sender: TObject);
    procedure tbsDownloadShow(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
  private
    { Private declarations }
    AppInfo : TAppInfo;
    strCurrentFile: String;
    strTempPath: String;
    strLocalPath: String;
    TransferFactory: TTransferFactory;
    STime: TDateTime;
    AbortTransfer: Boolean;
    FBreak: Boolean;
    FSuccess: Boolean;
    t: TTestThread;
    FThread: TThread;
    function CheckHostExe: Boolean;
    procedure CheckUpdate;
    procedure OnAnalyse(Sender: TObject; Count, Current: Integer);
    procedure DownloadBegin(Sender: TObject; const AWorkCountMax: Integer);
    procedure OnDownload(Sender: TObject; const AWorkCount: Integer);
    procedure DownloadEnd(Sender: TObject);
    procedure GetTempPath;
    Procedure GetLocalPath;
    procedure OnStatuse(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    Function CreateTransfer(URL: String):TTransfer;
    procedure DownloadAndUpdate;
    procedure InitAppInfo;
    procedure ShowWhatsNew;
    procedure UpdaeNext(temp: TStrings);
  public
    { Public declarations }
  end;


var
  frmAutoUpdate: TfrmAutoUpdate;

implementation

uses FSeting, JGWUpdate, uFileAction, System.IOUtils,
  Winapi.TlHelp32, Winapi.ShellAPI, Winapi.PsAPI;

Var
  AverageSpeed: Double = 0;

{$R *.dfm}

procedure TfrmAutoUpdate.FormDestroy(Sender: TObject);
begin
  FreeAndNil(TransferFactory);
  if Assigned(AppInfo) then
    FreeAndNil(AppInfo);
end;

procedure TfrmAutoUpdate.cmdNextClick(Sender: TObject);
begin
  if (PcWizard.ActivePageIndex < MAX_PAGES - 1) then
  begin
    Image1.Picture.Bitmap.LoadFromResourceID(HInstance, BMP_START + PcWizard.ActivePageIndex + 1);
    Image1.Update;
    Application.ProcessMessages;
    PcWizard.ActivePageIndex := PcWizard.ActivePageIndex + 1;
  end;
end;

procedure TfrmAutoUpdate.cmdPrevClick(Sender: TObject);
begin
  if (PcWizard.ActivePageIndex > 0) then
  begin
    Image1.Picture.Bitmap.LoadFromResourceID(HInstance, BMP_START + PcWizard.ActivePageIndex - 1);
    Image1.Update;
    Application.ProcessMessages;
    PcWizard.ActivePageIndex := PcWizard.ActivePageIndex - 1;
  end;
end;

procedure TfrmAutoUpdate.Button3Click(Sender: TObject);
begin
  if Assigned(FThread) then
  begin
    if not FThread.Finished then
    begin
      FBreak := True;
      while FThread.Finished do
        Sleep(100);
    end;
  end;
  Close();
end;

procedure TfrmAutoUpdate.PcWizardChange(Sender: TObject);
begin
  if PcWizard.ActivePageIndex = 0 then
  begin
    cmdPrev.Enabled := false;
    cmdNext.Enabled := true;
  end
  else if PcWizard.ActivePageIndex = MAX_PAGES - 1 then
  begin
    cmdPrev.Enabled := true;
    cmdNext.Enabled := true;
  end
  else
  begin
    cmdPrev.Enabled := true;
    cmdNext.Enabled := false;
  end;
end;

procedure TfrmAutoUpdate.Button5Click(Sender: TObject);
begin
  if (lbAppList.ItemIndex = -1) then
  begin
    Application.MessageBox('��ѡ��һ����Ʒ', 'ϵͳ��ʾ');
    exit;
  end;
  frmSeting.AppName := lbAppList.Items[lbAppList.ItemIndex];
  //frmSeting.SkinRef := SkinData1;
  frmSeting.ShowModal;
end;

function TfrmAutoUpdate.CheckHostExe: Boolean;
var
  ExeFilePath: string;
  function GetProcessPath(ProcessID: DWORD): string;
  var
    Hand: THandle;
    ModName: Array[0..Max_Path-1] of Char;
    hMod: HModule;
    n: DWORD;
  begin
    Result:='';
    Hand:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,False,ProcessID);
    if Hand>0 then
    try
     ENumProcessModules(Hand,@hMod,Sizeof(hMod),n);
     if GetModuleFileNameEx(Hand,hMod,ModName,Sizeof(ModName))>0 then
       //Result:=ExtractFilePath(ModName);
       Result := ModName;
    except
    end;
  end;
  function   FindProcess(AFileName:   string):   boolean;
  var
    ProcessPath: string;
  var
    hSnapshot:   THandle;//���ڻ�ý����б�
    lppe:   TProcessEntry32;//���ڲ��ҽ���
    Found:   Boolean;//�����жϽ��̱����Ƿ����
  begin
      Result   :=False;
      hSnapshot   :=   CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,   0);//���ϵͳ�����б�
      lppe.dwSize   :=   SizeOf(TProcessEntry32);//�ڵ���Process32First   API֮ǰ����Ҫ��ʼ��lppe��¼�Ĵ�С
      Found   :=   Process32First(hSnapshot,   lppe);//�������б�ĵ�һ��������Ϣ����ppe��¼��
    while   Found   do
    begin
      ProcessPath := GetProcessPath(lppe.th32ProcessID);
      //if   ((UpperCase(ExtractFileName(lppe.szExeFile))=UpperCase(AFileName))   or   (UpperCase(lppe.szExeFile   )=UpperCase(AFileName)))   then
      if UpperCase(ProcessPath) = UpperCase(AFileName) then
      begin
        Result   :=True;
      end;
        Found   :=   Process32Next(hSnapshot,   lppe);//�������б����һ��������Ϣ����lppe��¼��
      end;
  end;

begin
  // TODO -cMM: TfrmAutoUpdate.CheckHostExe default body inserted
  ExeFilePath := IncludeTrailingBackslash(AppInfo.LocalPath) + AppInfo.AppExeFile;
  Result := FindProcess(ExeFilePath);
  if Result then
  begin
    cmdNext.Enabled := False;
    tmr1.Enabled := true;
  end
  else
  begin
    cmdNext.Enabled := True;
    tmr1.Enabled := False;
  end;
end;

procedure TfrmAutoUpdate.CheckUpdate;
var
  FileAction: TFileAction;

begin
  // TODO -cMM: TfrmAutoUpdate.CheckUpdate default body inserted
  FileAction := TFileAction.Create(Application.ExeName);
  try
    atpgrdr1.InfoFileURL := 'http://update.68803990.com/AutoUpgrade/UpdateInfo.TXT';
    atpgrdr1.VersionNumber := FileAction.GetFileVersionAsText;
    Self.Caption := Format('�����Զ����³��򡾰汾%s��', [atpgrdr1.VersionNumber]);
    if AppInfo.ProxyServer <> '' then
    begin
      atpgrdr1.Proxy.ProxyServer := AppInfo.ProxyServer;
      atpgrdr1.Proxy.ProxyPort := StrToInt(AppInfo.ProxyPort);
      atpgrdr1.Proxy.AccessType := atUseProxy;
    end;
    atpgrdr1.CheckUpdate;
  finally
    FreeAndNil(FileAction);
  end;

end;

procedure TfrmAutoUpdate.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
begin
  //���ó������۽���

  TransferFactory := TTransferFactory.Create;
  PcWizard.ActivePageIndex := 0;
  Image1.Picture.Bitmap.LoadFromResourceID(HInstance, BMP_START);
  FSuccess := False;
  Inifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'UpdateApps.ini');
  try
    IniFile.ReadSections(lbAppList.Items);
    lbApplist.ItemIndex := 0;
    InitAppInfo;
    CheckUpdate;
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TfrmAutoUpdate.tbsGetUpdateShow(Sender: TObject);
var
  Analyse: TAnalyse;
begin
  tbsGetUpdate.Update;
  Application.ProcessMessages;
  ProgressBar1.Position := 0;
  self.cmdPrev.Enabled := false;
  self.cmdNext.Enabled := false;
  Analyse := TXMLAnalyse.Create;
  if lbAppList.Items.Count > 0 then
  begin

    Label3.Caption := '�������ȡ���¶����ļ�������������';
    Label3.Update;
    AppInfo.AppName := lbAppList.Items[lbAppList.ItemIndex];
    Analyse.UpdateList := AppInfo.UpdateServer  + AppInfo.ListDefFile;
    Analyse.Transfer := CreateTransfer(Analyse.UpdateList);
    Analyse.OnAnalyse := OnAnalyse;
    try
      t := TTestThread.Create(Analyse);
      t.OnRe := UpdaeNext;
      t.FreeOnTerminate := true;
      t.Resume;
    except
      Label3.Font.Color := clRed;
      Label3.Caption := '�������ȡ�����ļ������������������Ƿ���ͨ!';
      Label3.Update;
      self.cmdPrev.Enabled := true;
      self.cmdNext.Enabled := false;
    end;
  end;
end;

procedure TfrmAutoUpdate.OnAnalyse(Sender: TObject; Count,
  Current: Integer);
begin
  ProgressBar1.Max := Count;
  ProgressBar1.Position := Current + 1;
  ProgressBar1.Update;
  Application.ProcessMessages;
end;

procedure TfrmAutoUpdate.tbsWellComeShow(Sender: TObject);
begin
  if lbAppList.Items.Count > 0 then
  begin
    self.cmdPrev.Enabled := false;
    self.cmdNext.Enabled := true;
  end
  else
    self.cmdPrev.Enabled := false;
    self.cmdNext.Enabled := true;
end;

procedure TfrmAutoUpdate.tbsDownloadShow(Sender: TObject);
begin
  FThread := TThread.CreateAnonymousThread(DownloadAndUpdate);
  FThread.FreeOnTerminate := True;
  FThread.Start;
end;

procedure TfrmAutoUpdate.DownloadBegin(Sender: TObject;
  const AWorkCountMax: Integer);
begin
  STime := Now;
  Memo1.Lines.Add(Format('��ʼ���� %s �ļ�', [strCurrentFile]));
  pbDetail.Max := AWorkCountMax;
end;

procedure TfrmAutoUpdate.DownloadEnd(Sender: TObject);
begin
  Memo1.Lines.Add(Format('%s �ļ�������ɣ�', [strCurrentFile]));
  pbDetail.Position := pbDetail.Max;
end;

procedure TfrmAutoUpdate.OnDownload(Sender: TObject;
  const AWorkCount: Integer);
var
  S: String;
  TotalTime: TDateTime;
//  RemainingTime: TDateTime;
  H, M, Sec, MS: Word;
  DLTime: Double;
begin
  TotalTime :=  Now - STime;
  DecodeTime(TotalTime, H, M, Sec, MS);
  Sec := Sec + M * 60 + H * 3600;
  DLTime := Sec + MS / 1000;
  if DLTime > 0 then
    AverageSpeed := {(AverageSpeed + }(AWorkCount / 1024) / DLTime{) / 2};

  if AverageSpeed > 0 then begin
    Sec := Trunc(((pbDetail.Max - AWorkCount) / 1024) / AverageSpeed);

    S := Format('%2d:%2d:%2d', [Sec div 3600, (Sec div 60) mod 60, Sec mod 60]);

    S := 'ʣ��ʱ�䣺 ' + S;
  end
  else S := '';

  S := FormatFloat('0.00 KB/s', AverageSpeed) + '; ' + S;
  lblStatuse.Caption := '�����ٶ�Ϊ��' + S;

  //if AbortTransfer then IdFTP1.Abort;

  pbDetail.Position := AWorkCount;
  pbDetail.Update;
  AbortTransfer := false;
end;
{
procedure TfrmAutoUpdate.AnalyseDownloadBegin(Sender: TObject;
  const AWorkCountMax: Integer);
begin
  ProgressBar1.Max := AWorkCountMax;
  ProgressBar1.Position := 0;
end;

procedure TfrmAutoUpdate.AnalyseDownloadEnd(Sender: TObject);
begin

end;

procedure TfrmAutoUpdate.OnAnalyseDownload(Sender: TObject;
  const AWorkCount: Integer);
begin
  ProgressBar1.Position := AWorkCount;
  ProgressBar1.Update;
end;
}
procedure TfrmAutoUpdate.GetTempPath;
var
  tmpPath: array[0..1024] of char;
begin
  Windows.GetTempPath(1024,tmpPath);
  strTemppath := tmpPath;
end;

procedure TfrmAutoUpdate.GetLocalPath;
begin
  if (AppInfo.LocalPath = '') then
    strLocalPath := ExtractFilePath(Application.ExeName)
  else
    strLocalPath := AppInfo.LocalPath;
end;

procedure TfrmAutoUpdate.OnStatuse(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: string);
begin
  Memo1.Lines.Add(AStatusText);
end;

function TfrmAutoUpdate.CreateTransfer(URL: String): TTransfer;
var
  ProxySeting: TProxySeting;
begin
  Result := TransferFactory.CreateTransfer(URL);
  if AppInfo.ProxyServer <> '' then
  begin
    ProxySeting.ProxyServer := Appinfo.ProxyServer;
    ProxySeting.ProxyPort := StrToInt(AppInfo.ProxyPort);
    ProxySeting.ProxyUser := AppInfo.LoginUser;
    ProxySeting.ProxyPass := AppInfo.LoginPass;
    Result.SetProxy(ProxySeting);
  end
  else
    Result.ClearProxySeting;
end;

procedure TfrmAutoUpdate.InitAppInfo;
begin
  // TODO -cMM: TfrmAutoUpdate.InitAppInfo default body inserted
  if (Assigned(AppInfo)) then AppInfo.Free;
  AppInfo := TIniAppInfo.Create(ExtractFilePath(Application.ExeName) + 'UpdateApps.ini',
                lbAppList.Items[lbAppList.ItemIndex]);
end;

procedure TfrmAutoUpdate.ShowWhatsNew;
var
  FileName: String;
begin
  // TODO -cMM: TfrmAutoUpdate.ShowWhatsNew default body inserted
  FileName := ExtractFilePath(Application.ExeName) + 'What''s New.txt';
  if TFile.Exists(FileName) then
    Memo1.Lines.LoadFromFile(FileName);
end;

procedure TfrmAutoUpdate.DownloadAndUpdate;
var
  TransferObj: TTransfer;
  UpdateObj: TUpdate;
  i, j: Integer;
  bError: Boolean;
begin
  FBreak := False;
  self.cmdPrev.Enabled := false;
  self.cmdNext.Enabled := false;
  pbMaster.Max := lbUpdateList.Items.Count * 3;
  pbMaster.Position := 0;
  pbDetail.Position := 0;
  memo1.Perform(EM_SCROLLCARET, 0, 0 );
  Memo1.Lines.Add('��ʼ��ָ���ķ����������ظ����ļ���������');
  GetTempPath;
  GetLocalPath;
  for i := 0 to lbUpdateList.Items.Count - 1 do
  begin
    pbMaster.StepIt;
    UpdateObj := lbUpdateList.Items.objects[i] as TUpdate;
    UpdateObj.TempPath := strTempPath + UpdateObj.FileName;
    UpdateObj.LocalFile := strLocalpath + UpdateObj.LocalFile;
    strCurrentFile := UpdateObj.FileName;
    TransferObj := CreateTransfer(AppInfo.UpdateServer + Updateobj.UpdateURL);
    TransferObj.OnTransferStart := DownloadBegin;
    TransferObj.OnTransferEnd := DownloadEnd;
    TransferObj.OnTransfer := OnDownload;
    TransferObj.OnStatus := OnStatuse;
    UpdateObj.TransferObj := TransferObj;
    bError := False;
    for j := 1 to AppInfo.RetryCount do
    begin
      try
        if FBreak then
          Exit;

        UpdateObj.Download(UpdateObj.TempPath);
        bError := false;
        Break;
      except
        bError := true;
        Memo1.Lines.Add(Format('����ʱ�����˴����������ڡ�%d������', [j]));
        Sleep(100);
        Continue;
      end;

    end;
    if bError then
    begin
      Memo1.Lines.Add('�޷�����ָ���ļ�������������磡');
      Memo1.Lines.Add('������ֹ��');
      Exit;
    end;
    if FBreak then
      Exit;
  end;
  if CheckHostExe then
    MessageBox(Handle, '������������У���ر�������ټ�����', 'ϵͳ��ʾ', MB_OK +
      MB_ICONWARNING)
  else
  begin

    lblStatuse.Caption := '';
    Memo1.Lines.Add('');
    Memo1.Lines.Add('�����ļ�������������');
    for i := 0 to lbUpdateList.Items.Count - 1 do
    begin
      pbMaster.StepIt;
      UpdateObj := lbUpdateList.Items.objects[i] as TUpdate;

      if (UpdateObj.UpdateType = upExecute) then
        Memo1.Lines.Add(Format('����ִ�� %s �ļ�', [UpdateObj.FileName]))
      else
        Memo1.Lines.Add(Format('���ڸ���%s�ļ�', [UpdateObj.FileName]));

      if UpdateObj.UpdateIt then
        Memo1.Lines.Add(Format('�ļ� %s �������!', [UpdateObj.FileName]))
      else
        Memo1.Lines.Add(Format('�ļ� %s ����ʧ��!!', [UpdateObj.FileName]));
    end;

    Memo1.Lines.Add('');
    Memo1.Lines.Add('ɾ����ʱ�ļ�������������');
    for i := 0 to lbUpdateList.Items.Count - 1 do
    begin
      pbMaster.StepIt;
      UpdateObj := lbUpdateList.Items.objects[i] as TUpdate;
      DeleteFile(UpdateObj.TempPath);
    end;
    Memo1.Lines.Add('��ʱ�ļ���ɾ��');

    Memo1.Lines.Add('');
    Memo1.Lines.Add('�����Ѿ���ɣ�����ر��˳�����');
    Sleep(1000);
    ShowWhatsNew;
    self.cmdPrev.Enabled := false;
    self.cmdNext.Enabled := false;
    Image1.Picture.Bitmap.LoadFromResourceID(HInstance, BMP_START + 3);
    FBreak := True;
    FSuccess := True;
  end;
end;

procedure TfrmAutoUpdate.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  ExeFilePath: string;
begin
  if Assigned(AppInfo) then
  begin
    if FSuccess then
    begin
      ExeFilePath := IncludeTrailingBackslash(AppInfo.LocalPath) + AppInfo.AppExeFile;
      CanClose := True;
      if Application.MessageBox('��������ɣ��Ƿ����г���', 'ϵͳ��ʾ', MB_YESNO + MB_ICONQUESTION) =
        IDYES then
      begin
        ShellExecute(Application.Handle, 'Open',
              PWideChar(ExeFilePath),
              nil, nil, SW_NORMAL);
      end;
    end;
  end;
end;

procedure TfrmAutoUpdate.tmr1Timer(Sender: TObject);
begin
  CheckHostExe;
end;

procedure TfrmAutoUpdate.UpdaeNext(temp: TStrings);
begin
  if temp = nil then
  begin
    Label3.Font.Color := clRed;
    Label3.Caption := '�������ȡ�����ļ������������������Ƿ���ͨ!';
    Label3.Update;
    self.cmdPrev.Enabled := true;
    self.cmdNext.Enabled := false;
  end
  else
  begin
    lbUpdateList.Items.Assign(temp);
    if (lbUpdateList.Items.Count > 0) then
    begin
      Label3.Font.Color := clRed;
      Label3.Caption := Format('���� %d �����ø���', [lbUpdateList.Items.Count]);
      self.cmdPrev.Enabled := true;
      self.cmdNext.Enabled := true;
      if CheckHostExe then
        MessageBox(Handle, '������������У���ر�������ټ�����', 'ϵͳ��ʾ', MB_OK +
          MB_ICONWARNING);
    end
    else
    begin
      Label3.Font.Color := clGreen;
      Label3.Caption := '���������������µİ汾������Ҫ����';
      self.cmdPrev.Enabled := true;
      self.cmdNext.Enabled := false;
    end;
  end;
  FreeAndNil(temp);
  //FreeAndNil(t);
end;

end.
