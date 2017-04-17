object FrmNCreateXML: TFrmNCreateXML
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #33258#21160#21019#24314'XML'#25991#26723
  ClientHeight = 457
  ClientWidth = 864
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label2: TLabel
    Left = 6
    Top = 27
    Width = 6
    Height = 12
  end
  object Labellbl1: TLabel
    Left = 14
    Top = 8
    Width = 132
    Height = 12
    Caption = #35774#23450#26356#26032#23450#20041#25991#20214#30446#24405#65306
  end
  object edtDir: TEdit
    Left = 8
    Top = 27
    Width = 791
    Height = 20
    ReadOnly = True
    TabOrder = 0
    OnChange = edtDirChange
  end
  object btnOpen: TButton
    Left = 805
    Top = 26
    Width = 28
    Height = 22
    Caption = '....'
    TabOrder = 1
    OnClick = btnOpenClick
  end
  object grp1: TGroupBox
    Left = 8
    Top = 54
    Width = 267
    Height = 395
    Caption = #26356#26032#25991#20214#21015#34920
    TabOrder = 3
    object btn1: TButton
      Left = 3
      Top = 357
      Width = 73
      Height = 33
      Caption = #28155#21152#25991#20214
      TabOrder = 0
      OnClick = btn1Click
    end
    object ListBox1: TListBox
      Left = 3
      Top = 24
      Width = 249
      Height = 327
      ItemHeight = 12
      MultiSelect = True
      TabOrder = 1
      OnClick = ListBox1Click
    end
    object btn2: TButton
      Left = 179
      Top = 357
      Width = 73
      Height = 33
      Caption = #31227#38500#25991#20214
      TabOrder = 2
      OnClick = btn2Click
    end
    object btnAddDir: TButton
      Left = 91
      Top = 357
      Width = 73
      Height = 33
      Caption = #28155#21152#25991#20214#22841
      TabOrder = 3
      OnClick = btnAddDirClick
    end
  end
  object grp2: TGroupBox
    Left = 281
    Top = 54
    Width = 552
    Height = 339
    Caption = #23646#24615#35774#32622
    TabOrder = 2
    object Labellbl2: TLabel
      Left = 18
      Top = 27
      Width = 60
      Height = 12
      Caption = #25991#20214#21517#31216#65306
    end
    object Labellbl3: TLabel
      Left = 18
      Top = 59
      Width = 60
      Height = 12
      Caption = #19979#36733#22320#22336#65306
    end
    object btnSave: TButton
      Left = 18
      Top = 282
      Width = 231
      Height = 32
      Caption = #20445#23384
      TabOrder = 5
      OnClick = btnSaveClick
    end
    object grp3: TGroupBox
      Left = 20
      Top = 101
      Width = 229
      Height = 167
      Caption = #26816#26597#31867#22411
      TabOrder = 3
      object rbNo: TRadioButton
        Left = 62
        Top = 21
        Width = 129
        Height = 17
        Caption = #19981#24517#26816#26597#65292#24378#21046#26356#26032
        TabOrder = 1
      end
      object rbCreate: TRadioButton
        Left = 37
        Top = 21
        Width = 156
        Height = 17
        Caption = #21019#24314#26816#26597'('#26032#22686#30340#25991#20214')'
        TabOrder = 0
      end
      object rbDate: TRadioButton
        Left = 37
        Top = 59
        Width = 158
        Height = 17
        Caption = #25353#36719#20214#26368#21518#26356#26032#26085#26399#26816#26597
        TabOrder = 2
      end
      object rbSize: TRadioButton
        Left = 37
        Top = 98
        Width = 109
        Height = 17
        Caption = #25991#20214#30340#22823#23567#26816#26597
        TabOrder = 3
      end
      object rbVer: TRadioButton
        Left = 37
        Top = 136
        Width = 77
        Height = 17
        Caption = #25353#29256#26412#26816#26597
        TabOrder = 4
      end
    end
    object edtFileName: TEdit
      Left = 84
      Top = 24
      Width = 165
      Height = 20
      ReadOnly = True
      TabOrder = 0
    end
    object edtURL: TEdit
      Left = 84
      Top = 51
      Width = 165
      Height = 20
      ReadOnly = True
      TabOrder = 2
    end
    object grp4: TGroupBox
      Left = 306
      Top = 24
      Width = 231
      Height = 48
      Caption = #26356#26032#26041#24335
      TabOrder = 1
      object rbCopy: TRadioButton
        Left = 22
        Top = 21
        Width = 85
        Height = 17
        Caption = 'Copy'#26356#26032
        TabOrder = 0
      end
      object rbExecute: TRadioButton
        Left = 132
        Top = 21
        Width = 78
        Height = 17
        Caption = #25191#34892#26356#26032
        TabOrder = 1
      end
    end
    object grp5: TGroupBox
      Left = 276
      Top = 101
      Width = 261
      Height = 167
      Caption = #30446#26631#25991#20214
      TabOrder = 4
      object Labellbl7: TLabel
        Left = 22
        Top = 52
        Width = 60
        Height = 12
        Caption = #25991#20214#22823#23567#65306
      end
      object Labellbl5: TLabel
        Left = 34
        Top = 23
        Width = 48
        Height = 12
        Caption = #29256#26412#21495#65306
      end
      object Label1: TLabel
        Left = 22
        Top = 137
        Width = 60
        Height = 12
        Caption = #30456#23545#36335#24452#65306
      end
      object Labellbl8: TLabel
        Left = 34
        Top = 108
        Width = 48
        Height = 12
        Caption = #25991#20214#21517#65306
      end
      object Labellbl6: TLabel
        Left = -2
        Top = 80
        Width = 84
        Height = 12
        Caption = #26368#21518#20462#25913#26085#26399#65306
      end
      object edtSize: TEdit
        Left = 88
        Top = 49
        Width = 160
        Height = 20
        ReadOnly = True
        TabOrder = 1
      end
      object edtVer: TEdit
        Left = 88
        Top = 20
        Width = 160
        Height = 20
        ReadOnly = True
        TabOrder = 0
      end
      object edtdeskDir: TEdit
        Left = 88
        Top = 137
        Width = 160
        Height = 20
        TabOrder = 4
      end
      object edtDesk: TEdit
        Left = 88
        Top = 108
        Width = 160
        Height = 20
        ReadOnly = True
        TabOrder = 3
      end
      object edtMody: TEdit
        Left = 88
        Top = 78
        Width = 160
        Height = 20
        ReadOnly = True
        TabOrder = 2
      end
    end
    object btnBatchSave: TButton
      Left = 274
      Top = 282
      Width = 263
      Height = 32
      Caption = #25209#37327#35774#32622
      TabOrder = 6
      OnClick = btnBatchSaveClick
    end
  end
  object btnUpdateXML: TButton
    Left = 744
    Top = 399
    Width = 89
    Height = 33
    Caption = #29983#25104'XML'#25991#20214
    TabOrder = 4
    OnClick = btnUpdateXMLClick
  end
  object dlgOpen1: TOpenDialog
    Filter = #25152#26377#25991#20214#31867#22411'|*.*'
    Options = [ofAllowMultiSelect, ofPathMustExist, ofEnableSizing]
    Left = 64
    Top = 344
  end
end
