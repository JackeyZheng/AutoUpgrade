program AutoCreateXML;

uses
  Forms,
  uNCreateXML in '..\..\UI\uNCreateXML.pas' {FrmNCreateXML},
  Encrypt in '..\..\..\..\..\JGWCore\Source\Delphi\Common\Encrypt.PAS',
  XMLDataController in '..\..\Public\XMLDataController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmNCreateXML, FrmNCreateXML);
  Application.Run;
end.
