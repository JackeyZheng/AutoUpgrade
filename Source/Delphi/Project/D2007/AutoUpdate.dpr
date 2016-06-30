program AutoUpdate;

uses
  Forms,
  FSeting in '..\..\UI\FSeting.pas' {frmSeting},
  FUpdate in '..\..\UI\FUpdate.pas' {frmAutoUpdate},
  Analyse in '..\..\Common\Analyse.PAS',
  AnalyserCmd in '..\..\Common\AnalyserCmd.PAS',
  AppInfo in '..\..\Common\AppInfo.PAS',
  Transfer in '..\..\Common\Transfer.pas',
  uFileAction in '..\..\Common\uFileAction.pas',
  Update in '..\..\Common\Update.PAS',
  FmxUtils in '..\..\Public\FmxUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSeting, frmSeting);
  Application.CreateForm(TfrmAutoUpdate, frmAutoUpdate);
  Application.Run;
end.
