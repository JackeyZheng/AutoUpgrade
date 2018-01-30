unit Analyse;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Transfer, XMLIntf;

type
  /// <summary>
  ///   分析事件，当分析器分析返回的更新呢内容时会触发。
  /// </summary>
  TOnAnalyse = procedure (Sender: TObject; Count, Current: Integer) of object;
  TOnResult = procedure (str: TStrings) of object;
  /// <summary>
  ///   分析器基类
  /// </summary>
  /// <remarks>
  ///   通过调用GetUpdateList方法获取一个UpdateList列表。列表中的每个对象是TUpdate对象
  /// </remarks>
  TAnalyse = class(TPersistent)
  private
    FOnAnalyse: TOnAnalyse;
    FTransfer: TTransfer;
    FUpdateList: string;
    procedure Analyse(Sender: TObject; Count, Current: Integer);
  protected
    function AnalyseData(AStream: TStream): TStrings; virtual; abstract;
  public
    /// <summary>
    ///   析构方法
    /// </summary>
    destructor Destroy; override;
    /// <summary>
    ///   获取Update对象列表的方法。该方法是一个纯虚方法，需要后面的继承类实现该方法。
    /// </summary>
    function GetUpdateList: TStrings; virtual;
    /// <summary>
    ///   传输对象。每一个分析器自带一个传输对象。
    /// </summary>
    /// <seealso cref="TTransfer">
    ///   TTransfer
    /// </seealso>
    property Transfer: TTransfer read FTransfer write FTransfer;
    /// <summary>
    ///   UpdateList网络更新文件的URL地址
    /// </summary>
    property UpdateList: string read FUpdateList write FUpdateList;
  published
    /// <summary>
    ///   分析事件，分析时会触发该事件，方便客户端显示。
    /// </summary>
    property OnAnalyse: TOnAnalyse read FOnAnalyse write FOnAnalyse;
  end;
  
  type userarray=array of string;

  /// <summary>
  ///   对返回的XML对象进行分析的类。该类主要是针对返回的数据是XML的时候对其进行分析。
  /// </summary>
  TXMLAnalyse = class(TAnalyse)
  private
    Fstr: array of string;
    procedure CreateFileDir(path: string);
    procedure arrayString(s:string; dot:char);
  protected
    function AnalyseData(Stream: TStream): TStrings; override;
  public
  end;
  
  TTestThread = class(TThread)
    private
      FAn: TAnalyse;
      FOnRe: TOnResult;
    public
      constructor Create(an: TAnalyse);
      property OnRe: TOnResult write FOnRe;
    protected
      procedure Execute; override;
  end;

implementation

uses
  IdUri, XMLDoc, JGWUpdate, ActiveX;
{
********************************* TXMLAnalyse **********************************
}
procedure TXMLAnalyse.arrayString(s:string;dot:char);
var
  i,j: Integer;
begin
  i := 1;
  j := 0;
  SetLength(Fstr, 50);
  while Pos(dot, s) > 0 do
  begin
    Fstr[j] := copy(s, i, pos(dot,s) - i);
    i := pos(dot,s) + 1;
    s[i-1] := chr(ord(dot) + 1);
    j:=j+1;
  end;
  Fstr[j] := copy(s, i, strlen(pchar(s)) - i + 1);
end;
procedure TXMLAnalyse.CreateFileDir(path: string);
var
  i: integer;
  temp: string;
begin
  arrayString(path,'/');
  for i := 0 to length(Fstr) - 1 do
  begin
    if Fstr[i] <> '' then
    begin
      if POS('.',Fstr[i]) > 0 then
      begin
        break;
      end;
      temp := ExtractFilePath(Application.ExeName);
      temp := temp + Fstr[i];
      if not (DirectoryExists(temp)) then
      begin
        forcedirectories(temp);
      end;
    end
    else
      break;
  end;
end;
function TXMLAnalyse.AnalyseData(Stream: TStream): TStrings;
var
  Xml: IXMLDocument;
  RootNode, Node: IXMLNode;
  i: Integer;
  Update: TUpdate;
  tmpUpdate: TUpdate;
  RetList: TStringList;
  dateTimeFormat: TFormatSettings;
  temp: string;
begin
  // TODO -cMM: TXMLAnalyse.AnalyseData default body inserted
  CoInitialize(nil);
  Xml := NewXmlDocument();
  Xml.LoadFromStream(Stream);
  RootNode := Xml.DocumentElement;
  RetList := TStringList.Create;
  
//  GetLocaleFormatSettings(0, dateTimeFormat);
  dateTimeFormat := TFormatSettings.Create;
  dateTimeFormat.DateSeparator := '-';
  dateTimeFormat.LongDateFormat := 'YYYY-MM-DD';

  for i := 0 to RootNode.ChildNodes.Count - 1 do
  begin

    if (Assigned(OnAnalyse)) then
      OnAnalyse(self, RootNode.ChildNodes.Count, i);
  
    Node := RootNode.ChildNodes[i];
   // ShowMessage(Node.ChildNodes['chkType'].Text);
    Update := TFileUpdate.Create;
    Update.ChkType := TChkType(StrToInt(Node.ChildNodes['chkType'].Text));
    temp := Node.ChildNodes['DeskFile'].text;
    
    CreateFileDir(temp);
    UPdate.LocalFile := Node.ChildNodes['DeskFile'].text;
    Update.NewDate := StrToDateTime(Node.ChildNodes['DateTime'].text, dateTimeFormat);
    Update.NewVersion := Node.ChildNodes['Version'].Text;
    //Update.TempPath := GetSystemTempPath();
    Update.UpdateType := TUpdateType(StrToInt(Node.ChildNodes['UpdateType'].Text));
    Update.UpdateURL := Node.ChildNodes['FileURL'].Text;
    Update.FileName := Node.ChildNodes['FileName'].Text;
    Update.NewSize := strtoInt64(Node.ChildNodes['FileSize'].Text);
    tmpUpdate := Update.Analyse;
    if (Assigned(tmpUpdate)) then
    begin
      RetList.AddObject(Format('%s  文件大小：[%dK]', [tmpUpdate.FileName, tmpUpdate.NewSize div 1024]), tmpUpdate);
    end;
  end;
  Xml := nil;
  Result := RetList;
  FreeAndNil(Update);
end;

{
*********************************** TAnalyse ***********************************
}
destructor TAnalyse.Destroy;
begin
  // TODO -cMM: TAnalyse.Destory default body inserted
  FTransfer := nil;
  inherited;
end;

procedure TAnalyse.Analyse(Sender: TObject; Count, Current: Integer);
begin
  if Assigned(FOnAnalyse) then
    FOnAnalyse(Sender, Count, Current);
end;

function TAnalyse.GetUpdateList: TStrings;
var
  Mem: TMemoryStream;
  URI: TIdURI;
begin
  Result := nil;
  if (Assigned(Transfer)) then
  begin
    URI := TIdURI.Create(UpdateList);
    Mem := TMemoryStream.Create;
    Transfer.URI := URI;
    try
      Transfer.Get(Mem);
      Result := AnalyseData(Mem);
    finally
      FreeAndNil(Mem);
      FreeAndNil(URI);
    end;
  end;
end;

constructor TTestThread.Create(an: TAnalyse);
begin
  inherited Create(True);
  FAn := an;
end;

procedure TTestThread.Execute;
var
  temp: TStrings;
begin
  inherited;
  try
    temp := FAn.GetUpdateList;
    if Assigned(FOnRe) then
    begin
      FOnRe(temp);
      FreeAndNil(FAn);
    end;
  except
    temp := nil;
    FOnRe(temp);
    FreeAndNil(FAn);
  end;

end;


end.
