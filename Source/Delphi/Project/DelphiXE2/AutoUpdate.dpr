program AutoUpdate;

uses
  Forms,
  Vcl.XPMan,
  FSeting in '..\..\UI\FSeting.pas' {frmSeting},
  FUpdate in '..\..\UI\FUpdate.pas' {frmAutoUpdate},
  fUpdateWiz in '..\..\UI\fUpdateWiz.pas' {frmUpdateWiz},
  Analyse in '..\..\Common\Analyse.PAS',
  AnalyserCmd in '..\..\Common\AnalyserCmd.PAS',
  AppInfo in '..\..\Common\AppInfo.PAS',
  FmxUtils in '..\..\Common\FmxUtils.pas',
  JGWUpdate in '..\..\Common\JGWUpdate.PAS',
  Transfer in '..\..\Common\Transfer.pas',
  uCheckUpdate in '..\..\Common\uCheckUpdate.pas',
  uFileAction in '..\..\Common\uFileAction.pas',
  uHttpTransfer in '..\..\Common\uHttpTransfer.pas',
  Encrypt in '..\..\..\..\..\JGWCore\Source\Delphi\Common\Encrypt.PAS';

{$R *.res}

begin
  {$IFDEF DEBUG}
  //ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmAutoUpdate, frmAutoUpdate);
  Application.CreateForm(TfrmSeting, frmSeting);
  Application.Run;
end.
