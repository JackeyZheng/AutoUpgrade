program UpdateSysinfoCfg;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.IniFiles,
  System.Classes;

var
  updateIni, SysCfgIni: TIniFile;
  Sections: TStrings;
  ExeFile: String;
begin
  try
    Sections := TStringList.Create;
    updateIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'UpdateApps.ini');
    try
      updateIni.ReadSections(Sections);
      if Sections.Count > 0 then
      begin
        ExeFile := ExtractFilePath(ParamStr(0)) + updateIni.ReadString(Sections[0], 'EXEFile', 'JGWCW.exe');
        SysCfgIni := TIniFile.Create(ChangeFileExt(ExeFile, '.ini'));
        try
          SysCfgIni.WriteString('Packages', 'Teller', 'TellerActions16.bpl');
        finally
          FreeAndNil(SysCfgIni);
        end;
      end;
    finally
      FreeAndNil(Sections);
      FreeAndNil(updateIni);
    end;
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
