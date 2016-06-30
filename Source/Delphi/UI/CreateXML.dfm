object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #33258#21160#21019#24314'XML'#25991#26723
  ClientHeight = 526
  ClientWidth = 519
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 32
    Top = 16
    Width = 96
    Height = 13
    Caption = #35831#36873#25321#31243#24207#30446#24405#65306
  end
  object edtDir: TEdit
    Left = 134
    Top = 8
    Width = 283
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object btnOpen: TButton
    Left = 434
    Top = 6
    Width = 75
    Height = 25
    Caption = #27983#35272'....'
    TabOrder = 0
    OnClick = btnOpenClick
  end
  object grp1: TGroupBox
    Left = 8
    Top = 43
    Width = 185
    Height = 438
    Caption = #30446#24405#26597#30475
    TabOrder = 2
    object DirTreeView: TTreeView
      Left = 3
      Top = 16
      Width = 179
      Height = 417
      Indent = 19
      ReadOnly = True
      TabOrder = 0
      OnChanging = DirTreeViewChanging
    end
  end
  object fllst1: TFileListBox
    Left = 48
    Top = 35
    Width = 185
    Height = 14
    FileType = [ftDirectory, ftNormal]
    ItemHeight = 13
    TabOrder = 3
    Visible = False
  end
  object grp2: TGroupBox
    Left = 196
    Top = 43
    Width = 313
    Height = 438
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
      Left = 160
      Top = 296
      Width = 48
      Height = 13
      Caption = #29256#26412#21495#65306
    end
    object lbl6: TLabel
      Left = 18
      Top = 359
      Width = 84
      Height = 13
      Caption = #26368#21518#20462#25913#26085#26399#65306
    end
    object lbl7: TLabel
      Left = 18
      Top = 296
      Width = 60
      Height = 13
      Caption = #25991#20214#22823#23567#65306
    end
    object lbl8: TLabel
      Left = 18
      Top = 328
      Width = 60
      Height = 13
      Caption = #30446#26631#25991#20214#65306
    end
    object btnSave: TButton
      Left = 112
      Top = 402
      Width = 89
      Height = 25
      Caption = #20445#23384
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object grp3: TGroupBox
      Left = 18
      Top = 83
      Width = 287
      Height = 126
      Caption = #26816#26597#31867#22411
      TabOrder = 1
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
      Left = 76
      Top = 288
      Width = 66
      Height = 21
      ReadOnly = True
      TabOrder = 5
    end
    object edtVer: TEdit
      Left = 206
      Top = 288
      Width = 91
      Height = 21
      ReadOnly = True
      TabOrder = 6
    end
    object edtDesk: TEdit
      Left = 76
      Top = 322
      Width = 229
      Height = 21
      TabOrder = 7
    end
    object edtMody: TEdit
      Left = 100
      Top = 354
      Width = 121
      Height = 21
      ReadOnly = True
      TabOrder = 8
    end
  end
  object rbNo: TRadioButton
    Left = 254
    Top = 219
    Width = 129
    Height = 17
    Caption = #19981#24517#26816#26597#65292#24378#21046#26356#26032
    TabOrder = 5
  end
  object rbVer: TRadioButton
    Left = 388
    Top = 150
    Width = 77
    Height = 17
    Caption = #25353#29256#26412#26816#26597
    TabOrder = 6
  end
  object rbDate: TRadioButton
    Left = 254
    Top = 173
    Width = 158
    Height = 17
    Caption = #25353#36719#20214#26368#21518#26356#26032#26085#26399#26816#26597
    TabOrder = 7
  end
  object rbSize: TRadioButton
    Left = 254
    Top = 150
    Width = 109
    Height = 17
    Caption = #25991#20214#30340#22823#23567#26816#26597
    TabOrder = 8
  end
  object rbCreate: TRadioButton
    Left = 254
    Top = 196
    Width = 138
    Height = 17
    Caption = #21019#24314#26816#26597'('#26032#22686#30340#25991#20214')'
    TabOrder = 9
    OnClick = rbCreateClick
  end
  object btnUpdateXML: TButton
    Left = 214
    Top = 493
    Width = 97
    Height = 25
    Caption = #29983#25104'XML'#25991#20214
    TabOrder = 10
    OnClick = btnUpdateXMLClick
  end
  object dlgSave1: TSaveDialog
    Left = 456
    Top = 480
  end
end
