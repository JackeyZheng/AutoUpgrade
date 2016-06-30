unit Analyse;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Transfer, XMLIntf;

type
  TOnAnalyse = procedure (Sender: TObject; Count, Current: Integer) of object;
  TOnResult = procedure (str: TStrings) of object;
  TAnalyse = class(TPersistent)
  private
    FOnAnalyse: TOnAnalyse;
    FTransfer: TTransfer;
    FUpdateList: string;
  public
    destructor Destroy; override;
    function GetUpdateList: TStrings; virtual; abstract;
    property Transfer: TTransfer read FTransfer write FTransfer;
    property UpdateList: string read FUpdateList write FUpdateList;
  published
    property OnAnalyse: TOnAnalyse read FOnAnalyse write FOnAnalyse;
  end;
  
  type userarray=array of string;

  TXMLAnalyse = class(TAnalyse)
  private
    Fstr: array of string;
    function Analyse(Stream: TStream): TStrings;
    procedure CreateFileDir(path: string);
    procedure arrayString(s:string; dot:char);
  public
    function GetUpdateList: TStrings; override;

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
  IdUri, XMLDoc, Update, ActiveX;
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
  i := 0;
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
function TXMLAnalyse.Analyse(Stream: TStream): TStrings;
var
  Xml: IXMLDocument;
  RootNode, Node: IXMLNode;
  i, Index: Integer;
  Update: TUpdate;
  tmpUpdate: TUpdate;
  RetList: TStringList;
  dateTimeFormat: TFormatSettings;
  temp: string;
begin
  // TODO -cMM: TXMLAnalyse.Analyse default body inserted
  CoInitialize(nil);
  Xml := NewXmlDocument();
  Xml.LoadFromStream(Stream);
  RootNode := Xml.DocumentElement;
  RetList := TStringList.Create;
  
  GetLocaleFormatSettings(0, dateTimeFormat);
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
      Index := RetList.Add(tmpUpdate.FileName + '    °æ±¾: ' + tmpUpdate.NewVersion);
      RetList.Objects[Index] := tmpUpdate;
    end;
  end;
  Xml := nil;
  Result := RetList;
  FreeAndNil(Update);
end;

function TXMLAnalyse.GetUpdateList: TStrings;
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
      Result := Analyse(Mem);
    finally
      FreeAndNil(Mem);
      FreeAndNil(URI);
    end;
  end;
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
