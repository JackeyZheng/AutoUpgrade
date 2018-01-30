unit fTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AppInfo, Analyse,Transfer, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    lbl1: TLabel;
    lst1: TListBox;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure OnExecteResult(Ret: TStrings);

    { Private declarations }
  public
    { Public declarations }
  end;
const
  UpdateAppIniFileName = 'UpdateApps.ini';
var
  Form2: TForm2;

implementation

uses
  System.IniFiles, uCheckUpdate;

{$R *.dfm}

procedure TForm2.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for I := 0 to lst1.Items.Count - 1 do
    lst1.Items.Objects[i].Free;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  CheckUpdate(OnExecteResult);
end;

procedure TForm2.OnExecteResult(Ret: TStrings);
begin
  // TODO -cMM: TForm2.OnExecteResult default body inserted
  if Assigned(Ret) then
  begin
    lbl1.Caption := Format('一共有%d个更新', [Ret.Count]);
    lst1.Items.Assign(Ret);
    FreeAndNil(Ret);
  end;
end;



end.
