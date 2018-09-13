unit AnalyserCmd;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, JGWUpdate;

type
  TAnalyseCmd = class(TObject)
  private
  protected
    function CreateNewUpdate(Source: TUpdate): TUpdate;
    function CreateUpdateDecorator(UpDate: TUpdate): TUpdateDecorator; virtual;
  public
    function Run(Update: TUpdate): TUpdate; virtual;
  end;
  
  TVersionAnalyse = class(TAnalyseCmd)
  private
    function CompareVersionString(ALeft, ARight: string): Integer;
  public
    function Run(Update: TUpdate): TUpdate; override;
  end;
  
  TDefaultAnalyse = class(TAnalyseCmd)
  public
    function Run(Update: TUpdate): TUpdate; override;
  end;
  
  TAnalyseCmdClass = Class of TAnalyseCmd;

  TDateAnalyse = class(TAnalyseCmd)
  public
    function Run(Update: TUpdate): TUpdate; override;
  end;
  
  TSizeAnalyse = class(TAnalyseCmd)
  public
    function Run(Update: TUpdate): TUpdate; override;
  end;
  
  TCreateAnalyse = class(TAnalyseCmd)
  public
    function Run(Update: TUpdate): TUpdate; override;
  end;
  
  TAnalyseCmdFactory = class(TObject)
  public
    class function CreateAnalyseCmd(AnalyseCmdClass: TAnalyseCmdClass):
            TAnalyseCmd;
  end;
  
  const
    ChkTypeArrar:array[0..4] of TAnalyseCmdClass=(TDefaultAnalyse,
                                                  TVersionAnalyse,
                                                  TDateAnalyse,
                                                  TSizeAnalyse,
                                                  TCreateAnalyse);


implementation

uses uFileAction, System.IOUtils;

function TAnalyseCmd.CreateNewUpdate(Source: TUpdate): TUpdate;
begin
  Result := TFileUpdate.Create;
  Result.Assign(Source);
  // TODO -cMM: TAnalyseCmd.CreateNewUpdate default body inserted
end;

{
********************************* TAnalyseCmd **********************************
}
function TAnalyseCmd.CreateUpdateDecorator(UpDate: TUpdate): TUpdateDecorator;
begin
  try
    Result := TUpdateDecoratorFactory.CreateUpdateDecorator(UpdateClassArray[Integer(Update.UpdateType)], Update);
  except
    Raise;
  end;
end;

function TAnalyseCmd.Run(Update: TUpdate): TUpdate;
begin
  Result := nil;
  if not TFile.Exists(Update.LocalFile) then
    Result := CreateUpdateDecorator(CreateNewUpdate(Update));
end;

function TVersionAnalyse.CompareVersionString(ALeft, ARight: string): Integer;
var
  LeftList: TStrings;
  RightList: TStrings;
  i: integer;
begin
  LeftList := TStringList.Create;
  RightList := TStringList.Create;
  try
    LeftList.Delimiter := '.';
    RightList.Delimiter := '.';
    LeftList.DelimitedText := ALeft;
    RightList.DelimitedText := ARight;
    for I := 0 to LeftList.Count - 1 do
    begin
      if RightList.Count  > i then
      begin
        Result := StrToInt(LeftList[i]) - StrToInt(RightList[i]);
        if Result <> 0 then
          Break;
      end
      else
        Result := 1;
    end;
  finally
    FreeAndNil(LeftList);
    FreeAndNil(RightList);
  end;
  // TODO -cMM: TVersionAnalyse.CompareVersionString default body inserted
end;

{
******************************* TVersionAnalyse ********************************
}
function TVersionAnalyse.Run(Update: TUpdate): TUpdate;
var
  NewUpdate: TUpdate;
  FileAction: TFileAction;
begin
  //Update.LocalFile
  Result := inherited;
  if not Assigned(Result) then
  begin
    FileAction := TFileAction.Create(Update.LocalFile);
    try
      if CompareVersionString(Update.NewVersion, FileAction.GetFileVersionAsText) > 0 then
      begin
        Result := CreateUpdateDecorator(CreateNewUpdate(Update));
      end
    finally
      FreeAndNil(FileAction);
    end;
  end;
end;

{
******************************* TDefaultAnalyse ********************************
}
function TDefaultAnalyse.Run(Update: TUpdate): TUpdate;
begin
  // TODO -cMM: TDefaultAnalyse.Run default body inserted
  Result := CreateUpdateDecorator(CreateNewUpdate(Update));
end;

{
********************************* TDateAnalyse *********************************
}
function TDateAnalyse.Run(Update: TUpdate): TUpdate;
var
  FileAction: TFileAction;
  NewUpdate: TUpdate;
begin
  Result := inherited;
  if not Assigned(Result) then
  begin
    FileAction := TFileAction.Create(Update.LocalFile);
    try
      if (FileAction.GetFileDate < Update.NewDate) then
      begin
//        NewUpdate := TFileUpdate.Create;
//        NewUpdate.Assign(Update);
        //Result := CreateUpdateDecorator(NewUpdate);
        Result := CreateUpdateDecorator(CreateNewUpdate(Update));
      end;
    finally
      freeAndNil(FileAction);
    end;
  end;
end;

{
********************************* TSizeAnalyse *********************************
}
function TSizeAnalyse.Run(Update: TUpdate): TUpdate;
var
  FileAction: TFileAction;
begin
  Result := inherited;
  if not Assigned(Result) then
  begin
    FileAction := TFileAction.Create(Update.LocalFile);
    try
      if (FileAction.GetFileSize > Update.NewSize) then
      begin
        Result := CreateUpdateDecorator(CreateNewUpdate(Update));
      end;
    finally
      FreeAndNil(FileAction);
    end;
  end;
end;

{
******************************** TCreateAnalyse ********************************
}
function TCreateAnalyse.Run(Update: TUpdate): TUpdate;
var
  FileAction: TFileAction;
begin
  Result := inherited;
  if not Assigned(Result) then
  begin
    FileAction := TFileAction.Create(Update.LocalFile);
    try
      if (FileAction.GetFileDate < Update.NewDate) then
      begin
        Result := CreateUpdateDecorator(CreateNewUpdate(Update));
      end;
    finally
      FreeAndNil(FileAction);
    end;
  end;
end;

{
****************************** TAnalyseCmdFactory ******************************
}
class function TAnalyseCmdFactory.CreateAnalyseCmd(AnalyseCmdClass:
        TAnalyseCmdClass): TAnalyseCmd;
begin
  // TODO -cMM: TAnalyseCmdFactory.CreateAnalyseCmd default body inserted
  Result := AnalyseCmdClass.Create;
end;

end.
