object frmCharRegistration: TfrmCharRegistration
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Cadastro de Personagem'
  ClientHeight = 470
  ClientWidth = 530
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 530
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 520
    object lblTitle: TLabel
      Left = 20
      Top = 25
      Width = 155
      Height = 25
      Caption = 'Novo Personagem'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlContent: TPanel
    Left = 0
    Top = 70
    Width = 530
    Height = 332
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 520
    ExplicitHeight = 322
    object lblName: TLabel
      Left = 20
      Top = 20
      Width = 33
      Height = 15
      Caption = 'Nome'
    end
    object lblFranchise: TLabel
      Left = 20
      Top = 75
      Width = 46
      Height = 15
      Caption = 'Franquia'
    end
    object lblActor: TLabel
      Left = 260
      Top = 75
      Width = 52
      Height = 15
      Caption = 'Ator/Atriz'
    end
    object lblMedia: TLabel
      Left = 20
      Top = 130
      Width = 72
      Height = 15
      Caption = 'Tipo de M'#237'dia'
    end
    object lblDescription: TLabel
      Left = 20
      Top = 185
      Width = 51
      Height = 15
      Caption = 'Descri'#231#227'o'
    end
    object edtName: TEdit
      Left = 20
      Top = 40
      Width = 460
      Height = 23
      TabOrder = 0
    end
    object cmbFranchise: TComboBox
      Left = 20
      Top = 95
      Width = 220
      Height = 23
      TabOrder = 1
    end
    object cmbActor: TComboBox
      Left = 260
      Top = 95
      Width = 220
      Height = 23
      TabOrder = 2
    end
    object cmbMedia: TComboBox
      Left = 20
      Top = 150
      Width = 220
      Height = 23
      Style = csDropDownList
      TabOrder = 3
      Items.Strings = (
        'Filme'
        'S'#233'rie')
    end
    object memDescription: TMemo
      Left = 20
      Top = 205
      Width = 460
      Height = 92
      TabOrder = 4
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 402
    Width = 530
    Height = 68
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 392
    ExplicitWidth = 520
    DesignSize = (
      530
      68)
    object btnSave: TPngBitBtn
      Left = 20
      Top = 20
      Width = 100
      Height = 32
      Anchors = [akLeft, akTop, akRight]
      Caption = 'SALVAR'
      Default = True
      TabOrder = 0
      OnClick = btnSaveClick
      ExplicitWidth = 90
    end
    object btnCancel: TPngBitBtn
      Left = 116
      Top = 20
      Width = 100
      Height = 32
      Anchors = [akLeft, akTop, akRight]
      Cancel = True
      Caption = 'CANCELAR'
      TabOrder = 1
      OnClick = btnCancelClick
      ExplicitWidth = 90
    end
  end
end
