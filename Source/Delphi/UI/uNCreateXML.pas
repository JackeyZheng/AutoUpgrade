unit uNCreateXML;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.FileCtrl, ShlwApi, Xml.XMLIntf, Xml.XMLDoc;

type
  TUpdateFile = class(TInterfacedObject)
  private
    FFileName: string;
    FFileURL: string;
    FChkType: string;
    FUpdateType: string;
    FVersion: string;
    FModyDatetime: string;
    FFileSize: string;
    FDeskFile: string;
    FDeskDir: string;
  public
    constructor Create;
    property ChkType: string read FChkType write FChkType;
    property DeskFile: string read FDeskFile write FDeskFile;
    property DeskDir: string read FDeskDir write FDeskDir;
    property FileName: string read FFileName write FFileName;
    property FileSize: string read FFileSize write FFileSize;
    property FileURL: string read FFileURL write FFileURL;
    property ModyDatetime: string read FModyDatetime write FModyDatetime;
    property UpdateType: string read FUpdateType write FUpdateType;
    property Version: string read FVersion write FVersion;
  end;

  TFrmNCreateXML = class(TForm)
    Label2: TLabel;
    Labellbl1: TLabel;
    edtDir: TEdit;
    btnOpen: TButton;
    grp1: TGroupBox;
    grp2: TGroupBox;
    Labellbl2: TLabel;
    Labellbl3: TLabel;
    btnSave: TButton;
    grp3: TGroupBox;
    rbNo: TRadioButton;
    rbCreate: TRadioButton;
    rbDate: TRadioButton;
    rbSize: TRadioButton;
    rbVer: TRadioButton;
    edtFileName: TEdit;
    edtURL: TEdit;
    grp4: TGroupBox;
    rbCopy: TRadioButton;
    rbExecute: TRadioButton;
    grp5: TGroupBox;
    Labellbl7: TLabel;
    edtSize: TEdit;
    Labellbl5: TLabel;
    edtVer: TEdit;
    Label1: TLabel;
    edtdeskDir: TEdit;
    Labellbl8: TLabel;
    edtDesk: TEdit;
    Labellbl6: TLabel;
    edtMody: TEdit;
    btnUpdateXML: TButton;
    btn1: TButton;
    dlgOpen1: TOpenDialog;
    ListBox1: TListBox;
    btn2: TButton;
    btnBatchSave: TButton;
    btnAddDir: TButton;
    procedure btnOpenClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure edtDirChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnUpdateXMLClick(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btnAddDirClick(Sender: TObject);
    procedure btnBatchSaveClick(Sender: TObject);
  private
    function GetRelativePath(const Path, AFile: string): string;
    procedure CreateXMLNode(root: IXmlNode; uFile: TUpdateFile);
  public
    { Public declarations }
  end;

procedure GetChildFileList(AStrings: TStrings; ASourFile, FileName: string); // 查找子目录

var
  FrmNCreateXML: TFrmNCreateXML;

implementation

{$R *.dfm}

uses
  uFileAction, System.IOUtils;

procedure GetFileInfo(temFile: TUpdateFile; FileName: string);
var
  FileAction: TFileAction;
  AFormatSettings: TFormatSettings;
begin
  FileAction := TFileAction.Create(FileName);
  AFormatSettings := TFormatSettings.Create();
  AFormatSettings.DateSeparator := '-';
  AFormatSettings.ShortDateFormat := 'yyyy-MM-dd';
  try
    temFile.Version := FileAction.GetFileVersionAsText;
    temFile.FileSize := inttostr(FileAction.GetFileSize);
    temFile.ModyDatetime := DatetimeTostr(FileAction.GetFileDate, AFormatSettings);
  finally
    freeandnil(FileAction);
  end;
end;

procedure TFrmNCreateXML.btn1Click(Sender: TObject);
var
  oldpath, sfile, newfile: string;
  i, icount: Integer;
  UFile: TUpdateFile;

begin
  oldpath := edtDir.Text;
  if oldpath = '' then
    exit;

  if dlgOpen1.InitialDir = '' then
    dlgOpen1.InitialDir := oldpath;

  if dlgOpen1.Execute(self.Handle) then
  begin
    icount := dlgopen1.Files.Count;
    for i := 0 to icount - 1 do
    begin
      sfile := dlgopen1.Files[i];
      newfile := GetRelativePath(oldpath, sfile);
      if ((newfile[1] = '.') and (newfile[2] = '\')) then
        Delete(newfile, 1, 2);
      if listbox1.Items.IndexOf(newfile) = -1 then
      begin
        UFile := TUpdateFile.Create;
        UFile.FileURL := newfile;
        UFile.FileName := ExtractFileName(sfile);
        UFile.DeskFile := ExtractFileName(sfile);
        GetFileInfo(UFile, sfile);
        Listbox1.AddItem(newfile, UFile);
      end;
    end;
  end;
end;

procedure TFrmNCreateXML.btn2Click(Sender: TObject);
begin
  if ListBox1.Count = 0 then
    exit;
  if ListBox1.ItemIndex = -1 then
    exit;

  ListBox1.DeleteSelected;
end;

procedure TFrmNCreateXML.btnBatchSaveClick(Sender: TObject);
var
  upFile: TUpdateFile;
  index: Integer;
begin

  for index := 0 to ListBox1.Items.Count - 1 do
  begin
    if ListBox1.Selected[index] then
    begin
      upFile := TUpdateFile(ListBox1.Items.Objects[index]);
      if rbSize.Checked then
        upFile.ChkType := '3'
      else if rbVer.Checked then
        upFile.ChkType := '1'
      else if rbDate.Checked then
        upFile.ChkType := '2'
      else if rbCreate.Checked then
        upFile.ChkType := '4'
      else if rbNo.Checked then
        upFile.ChkType := '0';

      if rbCopy.Checked then
        upFile.UpdateType := '0'
      else if rbExecute.Checked then
        upFile.UpdateType := '1';

      //upFile.FileSize := edtSize.Text;
      //upFile.Version := edtVer.Text;
      //upFile.DeskFile := edtDesk.Text;
      upFile.DeskDir := edtdeskDir.Text;
      //upFile.ModyDatetime := edtMody.Text;
    end;
  end;
end;

procedure TFrmNCreateXML.btnOpenClick(Sender: TObject);
var
  temp: string;
begin
  temp := edtDir.Text;
  if SelectDirectory('请指定文件夹', '', temp) then
  begin
    edtDir.Text := IncludeTrailingPathDelimiter(temp);
  end;
end;

procedure TFrmNCreateXML.btnSaveClick(Sender: TObject);
var
  upFile: TUpdateFile;
begin
  if ListBox1.ItemIndex > -1 then
  begin
    upFile := TUpdateFile(ListBox1.Items.Objects[ListBox1.ItemIndex]);
    if rbSize.Checked then
      upFile.ChkType := '3'
    else if rbVer.Checked then
      upFile.ChkType := '1'
    else if rbDate.Checked then
      upFile.ChkType := '2'
    else if rbCreate.Checked then
      upFile.ChkType := '4'
    else if rbNo.Checked then
      upFile.ChkType := '0';

    if rbCopy.Checked then
      upFile.UpdateType := '0'
    else if rbExecute.Checked then
      upFile.UpdateType := '1';

    upFile.FileSize := edtSize.Text;
    upFile.Version := edtVer.Text;
    upFile.DeskFile := edtDesk.Text;
    upFile.DeskDir := edtdeskDir.Text;
    upFile.ModyDatetime := edtMody.Text;
  end;
end;

procedure GetChildFileList(AStrings: TStrings; ASourFile, FileName: string); // 查找子目录
 // AStrings存放路径， ASourceFile要查找的目录，FileName搜索的文件类型 若指定类型，则'*.jpg'or '*.png'
var
  sour_path, sour_file: string;
  TmpList: TStringList;
  FileRec, subFileRec: TSearchrec;
  i: Integer;
begin
  if copy(ASourFile, Length(ASourFile), 1) <> '\' then
    sour_path := IncludeTrailingPathDelimiter(Trim(ASourFile))      // 在路径后面加上反斜杠
  else
    sour_path := trim(ASourFile);
  sour_file := FileName;

  if not TDirectory.Exists(sour_path) then
  begin
    AStrings.Clear;
    exit;
  end;
  TmpList := TStringList.Create;
  TmpList.Clear;

  if FindFirst(sour_path + '*.*', faAnyfile, FileRec) = 0 then
    repeat
      if ((FileRec.Attr and faDirectory) <> 0) then
      begin
        if ((FileRec.Name <> '.') and (FileRec.Name <> '..')) then
          GetChildFileList(AStrings, sour_path + FileRec.Name + '\', sour_file);
      end;
    until FindNext(FileRec) <> 0;
  FindClose(FileRec);

  if FindFirst(sour_path + FileName, faAnyfile, subFileRec) = 0 then
    repeat
      if ((subFileRec.Attr and faDirectory) = 0) then
        TmpList.Add(sour_path + subFileRec.Name);
    until FindNext(subFileRec) <> 0;
  FindClose(subFileRec);

  for i := 0 to TmpList.Count - 1 do
    AStrings.Add(TmpList.Strings[i]);
  TmpList.Free;
end;

procedure TFrmNCreateXML.btnAddDirClick(Sender: TObject);
var
  temp, newFile: string;
  tempFiles: TStrings;
  i: Integer;
  UFile: TUpdateFile;
begin
  temp := edtDir.Text;
  if SelectDirectory('请指定文件夹', '', temp) then
  begin
    temp := IncludeTrailingPathDelimiter(temp);
    tempFiles := TStringList.Create;
    try
      GetChildFileList(tempFiles, temp, '*.*');
      for i := 0 to tempFiles.Count - 1 do
      begin
        newfile := GetRelativePath(edtDir.Text, tempFiles[i]);
        if ((newfile[1] = '.') and (newfile[2] = '\')) then
          Delete(newfile, 1, 2);
        if listbox1.Items.IndexOf(newfile) = -1 then
        begin
          UFile := TUpdateFile.Create;
          UFile.FileURL := newfile;
          UFile.FileName := ExtractFileName(tempFiles[i]);
          UFile.DeskFile := ExtractFileName(tempFiles[i]);
          GetFileInfo(UFile, tempFiles[i]);
          Listbox1.AddItem(newfile, UFile);
        end;
      end;
    finally
      FreeAndNil(tempFiles);
    end;
  end;
end;

procedure TFrmNCreateXML.btnUpdateXMLClick(Sender: TObject);
var
  SavePathFileName: string;
  ixd: IXmlDocument;
  root: IXmlNode;
  i: Integer;
begin
  if ListBox1.Items.Count <= 0 then
    Exit;

  SavePathFileName := edtDir.Text + 'UpdateList.XML';
  ixd := NewXmlDocument();

  root := ixd.AddChild('UpdateLists');
  for i := 0 to ListBox1.Items.Count - 1 do
  begin
    CreateXMLNode(root, TUpdateFIle(ListBox1.Items.Objects[i]));
  end;

  ixd.SaveToFile(SavePathFileName);

  ShowMessage('XML文件生成成功，谢谢！');
end;

procedure TFrmNCreateXML.CreateXMLNode(root: IXmlNode; uFile: TUpdateFile);
var
  node1: IXmlNode;
  node2: IXmlNode;
  node3: IXmlNode;
  node4: IXmlNode;
  node5: IXmlNode;
  node6: IXmlNode;
  node7: IXmlNode;
  node8: IXmlNode;
  node9: IXmlNode;
begin
  node1 := root.AddChild('UpdateFile');

  node2 := node1.AddChild('FileName');
  node2.Text := uFile.FileName;

  node3 := node1.AddChild('FileURL');
  node3.Text := uFile.FileURL;

  node4 := node1.AddChild('chkType');
  node4.Text := uFile.ChkType;

  node5 := node1.AddChild('UpdateType');
  node5.Text := uFile.UpdateType;

  node6 := node1.AddChild('Version');
  node6.Text := uFile.Version;

  node7 := node1.AddChild('DateTime');
  node7.Text := uFile.ModyDatetime;

  node8 := node1.AddChild('FileSize');
  node8.Text := uFile.FileSize;

  node9 := node1.AddChild('DeskFile');
  if uFile.DeskDir <> '' then
    node9.Text := uFile.DeskDir + '\' + uFile.DeskFile
  else
    node9.Text := uFile.DeskFile;
end;

procedure TFrmNCreateXML.edtDirChange(Sender: TObject);
begin
//  ListBox1.Clear;
  dlgOpen1.InitialDir := edtDir.Text;
end;

procedure TFrmNCreateXML.FormCreate(Sender: TObject);
begin
  ListBox1.Items.Clear;
end;

function TFrmNCreateXML.GetRelativePath(const Path, AFile: string): string;

  function GetAttr(IsDir: Boolean): DWORD;
  begin
    if IsDir then
      Result := FILE_ATTRIBUTE_DIRECTORY
    else
      Result := FILE_ATTRIBUTE_NORMAL;
  end;

var
  p: array[0..MAX_PATH] of Char;
begin
  PathRelativePathTo(p, PChar(Path), GetAttr(False), PChar(AFile), GetAttr(True));
  Result := StrPas(p);
end;

procedure TFrmNCreateXML.ListBox1Click(Sender: TObject);
var
  upFile: TUpdateFile;
begin
  if ListBox1.Count = 0 then
    exit;
  if ListBox1.ItemIndex = -1 then
    exit;

  upFile := TUpdateFile(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  edtFileName.Text := upFile.FileName;
  if upFile.FileName <> '' then
  begin
    edtURL.Text := upFile.FileURL;

    if upFile.UpdateType = '0' then
      rbCopy.Checked := True
    else if upFile.UpdateType = '1' then
      rbExecute.Checked := True;

    if upFile.ChkType = '0' then
      rbNo.Checked := True
    else if upFile.ChkType = '1' then
      rbVer.Checked := True
    else if upFile.ChkType = '2' then
      rbDate.Checked := True
    else if upFile.ChkType = '3' then
      rbSize.Checked := True
    else if upFile.ChkType = '4' then
    begin
      rbCreate.Checked := True;
        //rbExecute.Checked := True;
    end;

    edtSize.Text := upFile.FileSize;
    edtVer.Text := upFile.Version;
    edtMody.Text := upFile.ModyDatetime;
    edtDesk.Text := upFile.DeskFile;
    edtdeskDir.Text := upFile.DeskDir;
  end;
end;

{ TUpdateFile }

constructor TUpdateFile.Create;
begin
  inherited;
  FChkType := '1';
  FUpdateType := '0';
  FVersion := '1';
  FDeskDir := '';
end;

end.

