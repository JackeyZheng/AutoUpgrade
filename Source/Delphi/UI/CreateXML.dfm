object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #33258#21160#21019#24314'XML'#25991#26723
  ClientHeight = 553
  ClientWidth = 1125
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 32
    Top = 16
    Width = 96
    Height = 13
    Caption = #35831#36873#25321#31243#24207#30446#24405#65306
  end
  object Label1: TLabel
    Left = 638
    Top = 49
    Width = 72
    Height = 13
    Caption = #19979#36733#25991#20214#20301#32622
  end
  object Label2: TLabel
    Left = 638
    Top = 11
    Width = 84
    Height = 13
    Caption = #24403#21069#25991#20214#22841#20301#32622
  end
  object Label3: TLabel
    Left = 638
    Top = 30
    Width = 156
    Height = 13
    Caption = #38656#35201#26356#26032#30340#25991#20214#22841#21644#25991#20214#20301#32622
  end
  object edtDir: TEdit
    Left = 134
    Top = 8
    Width = 331
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = 'E:\Work\Products\Internet\JGWProductes\autoupgrade\Bin'
  end
  object btnOpen: TButton
    Left = 466
    Top = 8
    Width = 55
    Height = 25
    Caption = #27983#35272'....'
    TabOrder = 0
    OnClick = btnOpenClick
  end
  object grp1: TGroupBox
    Left = 8
    Top = 43
    Width = 275
    Height = 475
    Caption = #30446#24405#26597#30475
    TabOrder = 2
    object DirTreeView: TTreeView
      Left = 3
      Top = 16
      Width = 269
      Height = 425
      Indent = 19
      ReadOnly = True
      TabOrder = 0
      OnChanging = DirTreeViewChanging
    end
  end
  object fllst1: TFileListBox
    Left = 786
    Top = 16
    Width = 171
    Height = 510
    FileType = [ftDirectory, ftNormal]
    ItemHeight = 13
    TabOrder = 3
  end
  object grp2: TGroupBox
    Left = 289
    Top = 39
    Width = 313
    Height = 448
    Caption = #23646#24615#35774#32622
    TabOrder = 4
    object lbl2: TLabel
      Left = 18
      Top = 24
      Width = 60
      Height = 13
      Caption = #25991#20214#21517#31216#65306
    end
    object lbl3: TLabel
      Left = 18
      Top = 56
      Width = 60
      Height = 13
      Caption = #19979#36733#22320#22336#65306
    end
    object lbl5: TLabel
      Left = 54
      Top = 319
      Width = 48
      Height = 13
      Caption = #29256#26412#21495#65306
    end
    object lbl6: TLabel
      Left = 18
      Top = 380
      Width = 84
      Height = 13
      Caption = #26368#21518#20462#25913#26085#26399#65306
    end
    object lbl7: TLabel
      Left = 42
      Top = 288
      Width = 60
      Height = 13
      Caption = #25991#20214#22823#23567#65306
    end
    object lbl8: TLabel
      Left = 42
      Top = 349
      Width = 60
      Height = 13
      Caption = #30446#26631#25991#20214#65306
    end
    object btnSave: TButton
      Left = 100
      Top = 402
      Width = 89
      Height = 36
      Caption = #20445#23384
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object grp3: TGroupBox
      Left = 20
      Top = 93
      Width = 282
      Height = 121
      Caption = #26816#26597#31867#22411
      TabOrder = 1
      object rbNo: TRadioButton
        Left = 62
        Top = 21
        Width = 129
        Height = 17
        Caption = #19981#24517#26816#26597#65292#24378#21046#26356#26032
        TabOrder = 0
      end
      object rbCreate: TRadioButton
        Left = 37
        Top = 21
        Width = 156
        Height = 17
        Caption = #21019#24314#26816#26597'('#26032#22686#30340#25991#20214')'
        TabOrder = 1
        OnClick = rbCreateClick
      end
      object rbDate: TRadioButton
        Left = 37
        Top = 45
        Width = 158
        Height = 17
        Caption = #25353#36719#20214#26368#21518#26356#26032#26085#26399#26816#26597
        TabOrder = 2
      end
      object rbSize: TRadioButton
        Left = 37
        Top = 71
        Width = 109
        Height = 17
        Caption = #25991#20214#30340#22823#23567#26816#26597
        TabOrder = 3
      end
      object rbVer: TRadioButton
        Left = 37
        Top = 96
        Width = 77
        Height = 17
        Caption = #25353#29256#26412#26816#26597
        TabOrder = 4
      end
    end
    object edtFileName: TEdit
      Left = 84
      Top = 21
      Width = 221
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object edtURL: TEdit
      Left = 84
      Top = 48
      Width = 221
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
    object grp4: TGroupBox
      Left = 18
      Top = 225
      Width = 287
      Height = 41
      Caption = #26356#26032#26041#24335
      TabOrder = 4
      object rbCopy: TRadioButton
        Left = 40
        Top = 17
        Width = 85
        Height = 17
        Caption = 'Copy'#26356#26032
        TabOrder = 0
      end
      object rbExecute: TRadioButton
        Left = 160
        Top = 17
        Width = 73
        Height = 17
        Caption = #25191#34892#26356#26032
        TabOrder = 1
      end
    end
    object edtSize: TEdit
      Left = 100
      Top = 280
      Width = 197
      Height = 21
      ReadOnly = True
      TabOrder = 5
    end
    object edtVer: TEdit
      Left = 100
      Top = 312
      Width = 197
      Height = 21
      ReadOnly = True
      TabOrder = 6
    end
    object edtDesk: TEdit
      Left = 100
      Top = 343
      Width = 197
      Height = 21
      TabOrder = 7
    end
    object edtMody: TEdit
      Left = 100
      Top = 375
      Width = 197
      Height = 21
      ReadOnly = True
      TabOrder = 8
    end
  end
  object btnUpdateXML: TButton
    Left = 289
    Top = 498
    Width = 121
    Height = 44
    Caption = #29983#25104'XML'#25991#20214
    TabOrder = 5
    OnClick = btnUpdateXMLClick
  end
  object btn1: TButton
    Left = 527
    Top = 8
    Width = 75
    Height = 25
    Caption = #26597#30475
    TabOrder = 6
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 446
    Top = 497
    Width = 156
    Height = 48
    Caption = #29983#25104'XML'#25991#20214'('#24102#26684#24335#30340')'
    TabOrder = 7
    OnClick = btn2Click
  end
  object dlgSave1: TSaveDialog
    Left = 304
    Top = 288
  end
end
