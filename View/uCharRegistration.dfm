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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 530
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    Color = 13619151
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 20
      Top = 25
      Width = 170
      Height = 26
      Caption = 'Novo Personagem'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI Variable Small'
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
    Color = 16053492
    ParentBackground = False
    TabOrder = 1
    object lblName: TLabel
      Left = 20
      Top = 20
      Width = 32
      Height = 16
      Caption = 'Nome'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Variable Display'
      Font.Style = []
      ParentFont = False
    end
    object lblFranchise: TLabel
      Left = 20
      Top = 75
      Width = 46
      Height = 16
      Caption = 'Franquia'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Variable Display'
      Font.Style = []
      ParentFont = False
    end
    object lblActor: TLabel
      Left = 260
      Top = 75
      Width = 52
      Height = 16
      Caption = 'Ator/Atriz'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Variable Display'
      Font.Style = []
      ParentFont = False
    end
    object lblMedia: TLabel
      Left = 20
      Top = 130
      Width = 72
      Height = 16
      Caption = 'Tipo de M'#237'dia'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Variable Display'
      Font.Style = []
      ParentFont = False
    end
    object lblDescription: TLabel
      Left = 20
      Top = 185
      Width = 51
      Height = 16
      Caption = 'Descri'#231#227'o'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Variable Display'
      Font.Style = []
      ParentFont = False
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
      Top = 207
      Width = 460
      Height = 92
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Variable Display'
      Font.Style = []
      ParentFont = False
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
    Color = 13619151
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      530
      68)
    object btnSave: TPngBitBtn
      Left = 20
      Top = 20
      Width = 100
      Height = 32
      Anchors = [akLeft, akTop, akRight]
      Caption = '&SALVAR'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Variable Text Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnSaveClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000000097048597300000B1300000B1301009A9C18000000994944415478DA
        6364A0103042E94A20AE05624E02EACB80B81B9B01DF805819889F218981C07F
        247520F62D209E836C0823924246241A97011240BC0F889702711B310630A019
        06929302E2A73075E8061C06621B1C0680E4ECD0D46318402C18E4061C01626B
        2C9A40E2B6C41880CB3558D550CD00504A546180A444420680D2C11D20E64236
        80D8BC0002DF81B809883B900D201B506C000085F330112F269CDA0000000049
        454E44AE426082}
    end
    object btnCancel: TPngBitBtn
      Left = 126
      Top = 20
      Width = 100
      Height = 32
      Anchors = [akLeft, akTop, akRight]
      Cancel = True
      Caption = '&CANCELAR'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Variable Text Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000000097048597300000B1300000B1301009A9C18000001AD4944415478DA
        A593BB4BC35014C64D6B49402B7D589316B54B56A19B82956E0E3A5BF0B13889
        544444D13F41D041B050D0A13829D2C9A14E22BEF70AC5C14DD33486524433C4
        A6ADDF855C48A36D91060E27E7DC737EF7BB37274C57870F634F0483C109B804
        8CF87E980ABB85256559BE6F05E846F301C33093F57A7DC7E1705C0882A0148B
        45BE56AB4D21BF8D7C169035D41ABF00684EA1285CA954E2AAAA7ED9770A0402
        BD2E972B03C80B202B0D005376DA308C0869E679BE4751148D16D1D8EFF7BB59
        96CD01B2408F4301A77097481E9162A7D3F904D98B907F8D63C4709C74B55A1D
        2110C44B8863854261CE0A90901C9524E98DC466D3195E77619B80C509CCAC1D
        867BC066835680EEF57ADDF97CFE9BCA0E85421B1480DDF6685E144556D3B40F
        00B80605B8C03114BEB65380B5306AEF0018B2024EE0AE903C6C770750B68CDA
        28369BB702A2A01EEBBA1E29954A9FCDBE82CFE7EBE3382E87D42C008FF63948
        022202324320F639309B33787D46F36AB349DC07641AF2C924663D1E8F522E97
        0592C3FA16EC1CCDEB7F4EA245C9381A121816325C03B077C437E45FA0B25BFE
        4CFF7D3A06FC00BBBAE611379FF1D70000000049454E44AE426082}
    end
  end
end
