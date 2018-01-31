unit fUpdateWiz;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvWizard, JvExControls;

type
  TfrmUpdateWiz = class(TForm)
    jvwzrd1: TJvWizard;
    jvwzrdwlcmpg1: TJvWizardWelcomePage;
    jvwzp1: TJvWizardInteriorPage;
    jvwzp2: TJvWizardInteriorPage;
    lstAppList: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUpdateWiz: TfrmUpdateWiz;

implementation

{$R *.dfm}

end.
