program AutoCreateXML;

uses
  Forms,
  uNCreateXML in '..\..\UI\uNCreateXML.pas' {FrmNCreateXML};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmNCreateXML, FrmNCreateXML);
  Application.Run;
end.
