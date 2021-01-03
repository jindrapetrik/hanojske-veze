object frmMain: TfrmMain
  Left = 196
  Top = 98
  Caption = 'Hanojsk'#233' V'#283#382'e'
  ClientHeight = 429
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    000001000200101010000000000028010000260000002020100000000000E802
    00004E0100002800000010000000200000000100040000000000C00000000000
    0000000000001000000000000000000000000000800000800000008080008000
    00008000800080800000C0C0C000808080000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF000000000000000000030000000000000003BB
    BBBBBBBBB300033BBBBBBBBB330003BBBBBBBBBBB30003333333333333000003
    BBBBBBB3000000033BBBBB3300000003BBBBBBB3000000033333333300000000
    03BBB30000000000033B33000000000003BBB300000000000333330000000000
    0001100000000000000110000000FFFFFFFF8001FFFF8001FFFF8001FFFF8001
    FFFF8001FFFFE007FFFFE007FFFFE007FFFFE007FFFFF81FFFFFF81FFFFFF81F
    FFFFF81FFFFFFE7FFFFFFE7FFFFF280000002000000040000000010004000000
    0000800200000000000000000000100000000000000000000000000080000080
    000000808000800000008000800080800000C0C0C000808080000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    0000000000000000000000000011111000000000000000000000000000000000
    000000000000000033B3BBBBBBBBBBBBBBBB3B3000000000333BBBBBBBBBBBBB
    BBBBB3300000000033B3BBBBBBBBBBBBBBBB3B3000000000333BBBBBBBBBBBBB
    BBBBB3300000000033B3BBBBBBBBBBBBBBBB3B3000000000333BBBBBBBBBBBBB
    BBBBB3300000000033B3BBBBBBBBBBBBBBBB3B3000000000333BBBBBBBBBBBBB
    BBBBB3300000000003333333333333333333333000000000000033B3BBBBBBBB
    B3300000000000000000333BBBBBBBBB3B30000000000000000033B3BBBBBBBB
    B3300000000000000000333BBBBBBBBB3B30000000000000000033B3BBBBBBBB
    B3300000000000000000333BBBBBBBBB3B30000000000000000033B3BBBBBBBB
    B33000000000000000000333333333333330000000000000000000003BBB3B30
    0000000000000000000000003BBBB3300000000000000000000000003BBB3B30
    0000000000000000000000003BBBB3300000000000000000000000003BBB3B30
    0000000000000000000000003BBBB3300000000000000000000000003BBB3B30
    0000000000000000000000000333333000000000000000000000000000111100
    0000000000000000000000000011110000000000000000000000000000111100
    00000000000000000000000000000000000000000000FFFFFFFFFFFC1FFFF800
    001FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000
    000FF800001FFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00
    00FFFF8001FFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0
    0FFFFFF81FFFFFFC3FFFFFFC3FFFFFFC3FFFFFFFFFFF}
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object lblOvladani: TLabel
    Left = 10
    Top = 120
    Width = 370
    Height = 13
    Caption = 
      'Ovl'#225'd'#225'n'#237': Prav'#233' tla'#269#237'tko - V'#253'b'#283'r v'#283#382'e     Lev'#233' tla'#269#237'tko - P'#345'esun' +
      ' na c'#237'lovou v'#283#382
  end
  object lblJPEXS: TLabel
    Left = 200
    Top = 385
    Width = 96
    Height = 21
    AutoSize = False
    Caption = 'JPEXS 2003'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Comic Sans MS'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object grbVyreseni: TGroupBox
    Left = 180
    Top = 5
    Width = 236
    Height = 111
    Caption = 'Automatick'#233' vy'#345'e'#353'en'#237
    TabOrder = 0
    object pnlCilovaPozice: TPanel
      Left = 5
      Top = 50
      Width = 226
      Height = 56
      TabOrder = 0
      object lblTargetPosition: TLabel
        Left = 30
        Top = 15
        Width = 68
        Height = 13
        Caption = 'C'#237'lov'#225' Pozice:'
      end
      object rdbAutomPozice1: TRadioButton
        Tag = 1
        Left = 5
        Top = 35
        Width = 36
        Height = 11
        Caption = '1'
        Enabled = False
        TabOrder = 0
      end
      object rdbAutomPozice2: TRadioButton
        Tag = 2
        Left = 50
        Top = 35
        Width = 36
        Height = 11
        Caption = '2'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object rdbAutomPozice3: TRadioButton
        Tag = 3
        Left = 95
        Top = 35
        Width = 36
        Height = 11
        Caption = '3'
        TabOrder = 2
      end
      object btnSolve: TButton
        Left = 135
        Top = 15
        Width = 81
        Height = 31
        Caption = 'Vy'#345'e'#353'it'
        TabOrder = 3
        OnClick = btnVyresitClick
      end
    end
  end
  object grbNoveVeze: TGroupBox
    Left = 10
    Top = 5
    Width = 166
    Height = 111
    Caption = 'Nov'#233' V'#283#382'e'
    TabOrder = 1
    object lblVyska: TLabel
      Left = 15
      Top = 25
      Width = 32
      Height = 13
      Caption = 'V'#253#353'ka:'
    end
    object lblPozice: TLabel
      Left = 60
      Top = 75
      Width = 35
      Height = 13
      Caption = 'Pozice:'
    end
    object lblVelikost: TLabel
      Left = 10
      Top = 53
      Width = 40
      Height = 13
      Caption = 'Velikost:'
    end
    object lblpx: TLabel
      Left = 105
      Top = 50
      Width = 11
      Height = 13
      Caption = 'px'
    end
    object btnReset: TButton
      Left = 105
      Top = 20
      Width = 56
      Height = 21
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnResetClick
    end
    object updVyskaVezi: TUpDown
      Left = 86
      Top = 20
      Width = 15
      Height = 21
      Associate = edtVyskaVezi
      Min = 1
      Position = 5
      TabOrder = 1
    end
    object edtVyskaVezi: TEdit
      Left = 55
      Top = 20
      Width = 31
      Height = 21
      Hint = 'V'#253#353'ka cel'#233' v'#283#382'e (po'#269'et pater)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '5'
      OnChange = edtRychlostChange
    end
    object rdbNovaPozice1: TRadioButton
      Tag = 1
      Left = 15
      Top = 95
      Width = 36
      Height = 11
      Caption = '1'
      Checked = True
      TabOrder = 3
      TabStop = True
      OnClick = rdbNovaPoziceClick
    end
    object rdbNovaPozice2: TRadioButton
      Tag = 2
      Left = 55
      Top = 95
      Width = 36
      Height = 11
      Caption = '2'
      TabOrder = 4
      OnClick = rdbNovaPoziceClick
    end
    object rdbNovaPozice3: TRadioButton
      Tag = 3
      Left = 105
      Top = 95
      Width = 36
      Height = 11
      Caption = '3'
      TabOrder = 5
      OnClick = rdbNovaPoziceClick
    end
    object updVelikost: TUpDown
      Left = 86
      Top = 45
      Width = 15
      Height = 21
      Associate = edtVelikost
      Min = 4
      Increment = 2
      Position = 20
      TabOrder = 6
    end
    object edtVelikost: TEdit
      Left = 55
      Top = 45
      Width = 31
      Height = 21
      Hint = 'Velikost 1 patra v'#283#382#283' v pixelech'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Text = '20'
    end
  end
  object pnlRychlost: TPanel
    Left = 185
    Top = 20
    Width = 226
    Height = 31
    BevelOuter = bvNone
    TabOrder = 2
    object lblRychlost: TLabel
      Left = 0
      Top = 10
      Width = 66
      Height = 13
      Caption = 'Rychlost (ms):'
    end
    object lblIDoba: TLabel
      Left = 145
      Top = 0
      Width = 74
      Height = 13
      Caption = 'Minim'#225'ln'#237' doba:'
      Transparent = True
    end
    object lblDoba: TLabel
      Left = 130
      Top = 15
      Width = 96
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = '3 s'
    end
    object edtRychlost: TEdit
      Left = 70
      Top = 5
      Width = 41
      Height = 21
      Hint = 'Rychlost animace vy'#345'e'#353'en'#237' v milisekund'#225'ch'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '100'
      OnChange = edtRychlostChange
    end
    object updRychlost: TUpDown
      Left = 111
      Top = 5
      Width = 15
      Height = 21
      Associate = edtRychlost
      Min = 10
      Max = 2000
      Increment = 100
      Position = 100
      TabOrder = 1
      Thousands = False
    end
  end
  object grbBarvy: TGroupBox
    Left = 420
    Top = 5
    Width = 81
    Height = 111
    Caption = 'Barvy'
    TabOrder = 3
    object lblBarVez: TLabel
      Left = 10
      Top = 25
      Width = 21
      Height = 13
      Caption = 'V'#283#382':'
    end
    object lblBarVyber: TLabel
      Left = 10
      Top = 55
      Width = 30
      Height = 13
      Caption = 'V'#253'b'#283'r:'
    end
    object lblBarTyc: TLabel
      Left = 10
      Top = 85
      Width = 21
      Height = 13
      Caption = 'Ty'#269':'
    end
    object pnlBarvaVez: TPanel
      Left = 45
      Top = 20
      Width = 26
      Height = 26
      Color = clWhite
      TabOrder = 0
      OnClick = pnlBarvaClick
      OnMouseDown = pnlBarvaMouseDown
      OnMouseUp = pnlBarvaMouseUp
    end
    object pnlBarvaVyber: TPanel
      Left = 45
      Top = 50
      Width = 26
      Height = 26
      Color = clYellow
      TabOrder = 1
      OnClick = pnlBarvaClick
      OnMouseDown = pnlBarvaMouseDown
      OnMouseUp = pnlBarvaMouseUp
    end
    object pnlBarvaTyc: TPanel
      Left = 45
      Top = 80
      Width = 26
      Height = 26
      Color = clMaroon
      TabOrder = 2
      OnClick = pnlBarvaClick
      OnMouseDown = pnlBarvaMouseDown
      OnMouseUp = pnlBarvaMouseUp
    end
  end
  object dlgColor: TColorDialog
    Left = 475
    Top = 120
  end
end
