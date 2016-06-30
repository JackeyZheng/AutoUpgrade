unit CreateXML;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, StrUtils, XMLIntf, XMLDoc, FileCtrl;

type
  TForm1 = class(TForm)
    lbl1: TLabel;
    edtDir: TEdit;
    btnOpen: TButton;
    grp1: TGroupBox;
    fllst1: TFileListBox;
    DirTreeView: TTreeView;
    grp2: TGroupBox;
    btnSave: TButton;
    lbl2: TLabel;
    lbl3: TLabel;
    grp3: TGroupBox;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    edtFileName: TEdit;
    edtURL: TEdit;
    rbNo: TRadioButton;
    rbVer: TRadioButton;
    rbDate: TRadioButton;
    rbSize: TRadioButton;
    rbCreate: TRadioButton;
    grp4: TGroupBox;
    rbCopy: TRadioButton;
    edtSize: TEdit;
    edtVer: TEdit;
    edtDesk: TEdit;
    edtMody: TEdit;
    rbExecute: TRadioButton;
    btnUpdateXML: TButton;
    dlgSave1: TSaveDialog;
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnUpdateXMLClick(Sender: TObject);
    procedure DirTreeViewChanging(Sender: TObject; Node: TTreeNode; var
        AllowChange: Boolean);
    procedure InitTree;
    procedure rbCreateClick(Sender: TObject);
    procedure createNode(root: IXmlNode; node: TTreeNode);
    function getVersion(path: string): string;
    function getDate(path: string): string;
    function getSize(path: string): string;
    function RightPosEx(const Substr,S: string): Integer;
    function GetBuildInfo(var V1, V2, V3, V4: Word; path: string):
    Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  type
    UpdateFile = class
      private
        FFileName: string;
        FFileURL: string;
        FChkType: string;
        FUpdateType: string;
        FVersion: string;
        FModyDatetime: string;
        FFileSize: string;
        FDeskFile: string;
    public
        constructor Create;
        property ChkType: string read FChkType write FChkType;
        property DeskFile: string read FDeskFile write FDeskFile;
        property FileName: string read FFileName write FFileName;
        property FileSize: string read FFileSize write FFileSize;
        property FileURL: string read FFileURL write FFileURL;
        property ModyDatetime: string read FModyDatetime write FModyDatetime;
        property UpdateType: string read FUpdateType write FUpdateType;
        property Version: string read FVersion write FVersion;
    end;
var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnOpenClick(Sender: TObject);
var
  temp: string;
begin
  if SelectDirectory('请指定文件夹', '', temp) then
  begin
    edtDir.Text := temp;
    fllst1.Items.Clear;
    fllst1.Directory := temp;
    DirTreeView.Items.Clear;
    InitTree;
  end;

end;

procedure TForm1.btnSaveClick(Sender: TObject);
var
  DirNode : TTreeNode;
  upFile: UpdateFile;
begin
  //
  DirNode := DirTreeView.Selected;
  if DirNode = nil then Exit;

  upFile := UpdateFile(DirNode.Data);
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
  upFile.ModyDatetime := edtMody.Text;

  ShowMessage('该节点信息保存成功，谢谢！');
end;

procedure TForm1.btnUpdateXMLClick(Sender: TObject);
var
  fileName: string;
  ixd: IXmlDocument;
  root: IXmlNode;
  i: Integer;
//  XML: string;
begin
  dlgSave1.Filter :='XMLFile(*.xml)|*.xml';
  dlgSave1.FilterIndex := 1;
  dlgSave1.DefaultExt := 'txt';
  if dlgSave1.Execute then
  begin
    fileName := ExtractFileExt(dlgSave1.FileName);
    ixd := NewXmlDocument();
    if DirTreeView.Items.Count <= 0 then Exit;

    root := ixd.AddChild('UpdateLists');
    for i := 0 to DirTreeView.Items.Count - 1 do
    begin
      createNode(root, DirTreeView.Items[i]);
    end;

    ixd.SaveToFile(dlgSave1.FileName);
//    ixd.SaveToXML(XML);

    ShowMessage('XML文件生成成功，谢谢！');
  end;

end;

procedure TForm1.createNode(root: IXmlNode; node: TTreeNode);
var
  i: Integer;
  upFile: UpdateFile;
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
  //
  node1 := root.AddChild('UpdateFile');
  upFile := UpdateFile(node.Data);
  node2 := node1.AddChild('FileName');
  node2.Text := upFile.FileName;

  node3 := node1.AddChild('FileURL');
  node3.Text := upFile.FileURL;

  node4 := node1.AddChild('chkType');
  node4.Text := upFile.ChkType;

  node5 := node1.AddChild('UpdateType');
  node5.Text := upFile.UpdateType;

  node6 := node1.AddChild('Version');
  node6.Text := upFile.Version;

  node7 := node1.AddChild('DateTime');
  node7.Text := upFile.ModyDatetime;

  node8 := node1.AddChild('FileSize');
  node8.Text := upFile.FileSize;

  node9 := node1.AddChild('DeskFile');
  node9.Text := upFile.DeskFile;

  for i := 0 to node.Count - 1 do
  begin
    createNode(root, node[i]);
  end;
end;

procedure TForm1.DirTreeViewChanging(Sender: TObject; Node: TTreeNode; var
    AllowChange: Boolean);
var
  upFile: UpdateFile;
  temp: string;
begin
  if Node.Count > 0 then
  begin
    ;
  end
  else
  begin
    upFile := UpdateFile(Node.Data);
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
        rbExecute.Checked := True;
      end;

      edtDesk.Text := upFile.DeskFile;
      edtSize.Text := upFile.FileSize;
      edtVer.Text := upFile.Version;
      edtMody.Text := upFile.ModyDatetime;
    end
    else
    begin
      DirTreeView.OnChanging := nil;
      DirTreeView.Select(Node);
      DirTreeView.OnChanging := DirTreeViewChanging;
      temp := StringReplace(upFile.FileURL, '[', '', [rfReplaceAll]);
      temp := StringReplace(temp, ']', '', [rfReplaceAll]);
      fllst1.Items.Clear;
      fllst1.Directory := temp;
      InitTree;
      Node.Expanded := True;
    end;
  end;
end;

function TForm1.getDate(path: string): string;
var
  SearchRec: TSearchRec;
  Tct: TSystemTime;
  Temp: TFileTime;
  modTime: TDateTime;
begin
  try
    if FindFirst(ExpandFileName(path), faAnyFile, SearchRec) = 0 then
    begin
      FileTimeToLocalFileTime(SearchRec.FindData.ftLastWriteTime, Temp);
      FileTimeToSystemTime(Temp, Tct);
      modTime := SystemTimeToDateTime(Tct);
      Result := FormatDateTime('yyyy-MM-dd HH:MM:SS', modTime);
    end
    else
      Result := '';
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

function TForm1.getSize(path: string): string;
var
  SearchRec: TSearchRec;
begin
  try
    if FindFirst(ExpandFileName(path), faAnyFile, SearchRec) = 0 then
      Result := IntToStr(SearchRec.Size)
    else Result := '0';
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

function TForm1.getVersion(path: string): string;
var
  V1, V2, V3, V4: Word;
begin
  // TODO -cMM: TFileAction.GetFileVersionAsText default body inserted
  GetBuildInfo(V1, V2, V3, V4, path);
  Result := IntToStr(V1) + '.' + IntToStr(V2) + '.' + IntToStr(V3) + '.' + IntToStr(V4);
end;

function TForm1.GetBuildInfo(var V1, V2, V3, V4: Word; path: string):
    Boolean;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  Result := true;
  VerInfoSize := GetFileVersionInfoSize(PChar(path), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(Pchar(path), 0, VerInfoSize, VerInfo);
  try
    try
      VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
      with VerValue^ do
      begin
        V1 := dwFileVersionMS shr 16;

        V2 := dwFileVersionMS and $FFFF;
        V3 := dwFileVersionLS shr 16;
        V4 := dwFileVersionLS and $FFFF;
      end;
    except
      Result := false;
    end;
  finally
    FreeMem(VerInfo, VerInfoSize);
  end;
end;

procedure TForm1.InitTree;
var
  i, count, k: Integer;
  temp, tempCase, itemstr, exitH: string;
  DirNode : TTreeNode;
  temp1: UpdateFile;
begin
  count := fllst1.Items.Count;
  for i := 0 to count - 1 do
  begin
     itemstr := fllst1.Items[i];
     if pos('[', itemstr) > 0 then
     begin
        //针对目录的操作
        itemstr := StringReplace(itemstr, '[', '', [rfReplaceAll]);
        itemstr := StringReplace(itemstr, ']', '', [rfReplaceAll]);
        if (itemstr <> '.') and (itemstr <> '..') then
        begin
          DirNode := DirTreeView.Items.AddChild(DirTreeView.Selected, itemstr);
          fllst1.Selected[i] := True;
          DirNode.HasChildren := True;
          temp1 := UpdateFile.Create;
          temp1.FileURL := fllst1.FileName;
          //temp1.FileName := fllst1.FileName;
          DirNode.Data := Pointer(temp1);
        end;
     end
     else
     begin
        //针对文件的操作
        DirNode := DirTreeView.Items.AddChild(DirTreeView.Selected, itemstr);
        fllst1.Selected[i] := True;
        temp := StringReplace(fllst1.FileName, edtDir.Text + '\', '', [rfReplaceAll]);
        temp := StringReplace(temp, '\', '/', [rfReplaceAll]);
        temp1 := UpdateFile.Create;
        temp1.FileURL := temp;
        temp1.FileSize := getSize(fllst1.FileName);
        exitH := ExtractFileExt(fllst1.FileName);
        if (exitH = '.exe') or (exitH = '.dll') then
          temp1.Version := getVersion(fllst1.FileName);
        temp1.ModyDatetime := getDate(fllst1.FileName);
        k := RightPosEx(temp, '/');
        if k <> 0 then
        begin
          tempCase := MidStr(temp, k + 1, Length(temp));
          temp1.FileName := tempCase;
          if temp1.DeskFile = '' then
            temp1.DeskFile := tempCase;
        end
        else
        begin
          temp1.FileName := temp;
          if temp1.DeskFile = '' then
            temp1.DeskFile := temp;
        end;
        DirNode.Data := Pointer(temp1);
     end;
  end;
end;

procedure TForm1.rbCreateClick(Sender: TObject);
begin
  rbExecute.Checked := True;
end;

//查找最后一个匹配的字符的索引
function TForm1.RightPosEx(const Substr,S: string): Integer;
var
  iPos: Integer;
  resul: Integer;
  TmpStr: string;
begin
  TmpStr := Substr;
  resul := 0;
  while True do
  begin
    iPos := Pos(s, TmpStr);
    if iPos <> 0 then
    begin
      TmpStr := StringReplace(TmpStr, '/', '', []);
      resul := iPos;
    end
    else
    begin
      Break;
    end;
  end;
  Result := resul;
end;

constructor UpdateFile.Create;
begin
  inherited;
  FChkType := '0';
  FUpdateType := '1';
  FVersion := '1';
  // TODO -cMM: UpdateFile.Create default body inserted
end;

end.
