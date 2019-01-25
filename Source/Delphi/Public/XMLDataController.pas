unit XMLDataController;

interface

uses
  Xml.XMLDataToSchema, System.StrUtils, System.SysUtils, System.IOUtils,
  System.Generics.Collections, Xml.XMLIntf, Xml.XMLDoc, System.Classes;

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
    FMd5Code: String;
  public
    constructor Create;
    function isBinFile(FileName: string): Boolean;
    property ChkType: string read FChkType write FChkType;
    property DeskFile: string read FDeskFile write FDeskFile;
    property DeskDir: string read FDeskDir write FDeskDir;
    property FileName: string read FFileName write FFileName;
    property FileSize: string read FFileSize write FFileSize;
    property FileURL: string read FFileURL write FFileURL;
    property Md5Code: String read FMd5Code write FMd5Code;
    property ModyDatetime: string read FModyDatetime write FModyDatetime;
    property UpdateType: string read FUpdateType write FUpdateType;
    property Version: string read FVersion write FVersion;
  end;

  TXMLTranse = class
  private
    FPath: string;
    FUpdateFiles: TList<TUpdateFile>;
    procedure ReadUpdateFiles(FileName: string);
    procedure RefreshUpdateFile;
  protected
  public
    constructor Create(FileName: string);
    destructor Destroy; override;
    property UpdateFiles: TList<TUpdateFile> read FUpdateFiles;
  end;

  const
    binFiles: array[0..3] of string = ('.EXE', '.DLL', '.BPL', '.OCX');

implementation

uses
  Winapi.ActiveX, uFileAction, uNCreateXML;



{ TUpdateFile }

constructor TUpdateFile.Create;
begin
  inherited;
  FChkType := '1';
  FUpdateType := '0';
  FVersion := '1';
  FDeskDir := '';
end;

function TUpdateFile.isBinFile(FileName: string): Boolean;
var
  i: Integer;
begin
  Result := false;
  // TODO -cMM: TUpdateFile.isBinFile default body inserted
  for I := 0 to Length(binFiles) do
  begin
    if UpperCase(TPath.GetExtension(FileName)) = binFiles[i] then
    begin
      Result := True;
      exit;
    end;
  end;
end;

constructor TXMLTranse.Create(FileName: string);
begin
  inherited Create;
  FUpdateFiles := TObjectList<TUpdateFile>.Create(True);
  FPath := ExtractFilePath(FileName);
  if TFile.Exists(FileName) then
  begin
    ReadUpdateFiles(FileName);
    RefreshUpdateFile;
  end;
  // TODO -cMM: TXMLTranse.Create default body inserted
end;

destructor TXMLTranse.Destroy;
begin
  FUpdateFiles.Free;
  inherited;
  // TODO -cMM: TXMLTranse.Destroy default body inserted
end;

procedure TXMLTranse.ReadUpdateFiles(FileName: string);
var
  dateTimeFormat: TFormatSettings;
  RootNode, Node: IXMLNode;
  Update: TUpdateFile;
  i: Integer;
  XML: IXMLDocument;
begin
  // TODO -cMM: TXMLTranse.ReadUpdateFiles default body inserted
  CoInitialize(nil);
  XML := NewXMLDocument();
  XML.LoadFromFile(FileName);
  RootNode := XML.DocumentElement;

  dateTimeFormat := TFormatSettings.Create;
  dateTimeFormat.DateSeparator := '-';
  dateTimeFormat.LongDateFormat := 'YYYY-MM-DD';

  for I := 0 to RootNode.ChildNodes.Count - 1 do
  begin
    Update := TUpdateFile.Create;
    Node := RootNode.ChildNodes[i];
    Update.ChkType := Node.ChildNodes['chkType'].Text;
    UPdate.FDeskFile := ExtractFileName(Node.ChildNodes['DeskFile'].text);
    Update.ModyDatetime := Node.ChildNodes['DateTime'].text;
    Update.Version := Node.ChildNodes['Version'].Text;
    Update.UpdateType := Node.ChildNodes['UpdateType'].Text;
    Update.FileURL := Node.ChildNodes['FileURL'].Text;
    Update.FileName := TPath.GetFileName(Node.ChildNodes['FileName'].Text);
    Update.FileSize := Node.ChildNodes['FileSize'].Text;
    Update.Md5Code := Node.ChildNodes['md5'].Text;
    Update.FDeskDir := ExtractFilePath(Node.ChildNodes['DeskFile'].Text);
    if Rightstr(Update.FDeskDir, 1) = '\' then
      Update.FDeskDir := Leftstr(Update.FDeskDir, Length(Update.FDeskDir) - 1);
    FUpdatefiles.Add(Update);
  end;
end;

procedure TXMLTranse.RefreshUpdateFile;
var
  UpdateFile: TUpdateFile;
  FileName: string;
begin
  // TODO -cMM: TXMLTranse.RefreshUpdateFile default body inserted
  for UpdateFile in FUpdateFiles do
  begin
    FileName := FPath + UpdateFile.FileURL;
    GetFileInfo(UpdateFile, FileName);
  end;
end;

end.
