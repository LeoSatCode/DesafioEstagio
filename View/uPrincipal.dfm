object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'frmPrincipal'
  ClientHeight = 394
  ClientWidth = 824
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 824
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitLeft = 200
    ExplicitTop = 8
    ExplicitWidth = 185
  end
  object pnl2: TPanel
    Left = 0
    Top = 352
    Width = 824
    Height = 42
    Align = alBottom
    Caption = 'pnl2'
    TabOrder = 1
    ExplicitLeft = -8
    ExplicitTop = 296
    ExplicitWidth = 675
    object btnImportar: TPngBitBtn
      Left = 16
      Top = 9
      Width = 75
      Height = 25
      Caption = 'IMPORTAR'
      TabOrder = 0
      OnClick = btnImportarClick
    end
  end
  object grdCharList: TDBGrid
    Left = 0
    Top = 41
    Width = 824
    Height = 311
    Align = alClient
    DataSource = dtsCharList
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'personagemId'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'Personagem'
        Title.Caption = 'Nome do Personagem'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Franquia'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Ator_Atriz'
        Title.Caption = 'Ator/Atriz'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Midia'
        Title.Caption = 'M'#237'dia'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'descricao'
        Title.Caption = 'Descri'#231#227'o'
        Width = 500
        Visible = True
      end>
  end
  object QryCharList: TFDQuery
    Connection = dtmConnection.ConnectionDB
    SQL.Strings = (
      'SELECT '
      '    P.personagemId,'
      '    P.nome AS Personagem,'
      '    F.nome AS Franquia,'
      '    A.nome AS Ator_Atriz,'
      '    P.tipoMidia AS Midia,'
      '    P.descricao'
      'FROM Personagens P'
      'LEFT JOIN Franquias F ON F.franquiaId = P.franquiaId'
      'LEFT JOIN Atores A ON A.atorId = P.atorId'
      'ORDER BY P.nome ASC')
    Left = 280
    Top = 144
    object QryCharListpersonagemId: TFDAutoIncField
      FieldName = 'personagemId'
      Origin = 'personagemId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QryCharListPersonagem: TStringField
      FieldName = 'Personagem'
      Origin = 'Personagem'
      Size = 100
    end
    object QryCharListFranquia: TStringField
      FieldName = 'Franquia'
      Origin = 'Franquia'
      Size = 100
    end
    object QryCharListAtor_Atriz: TStringField
      FieldName = 'Ator_Atriz'
      Origin = 'Ator_Atriz'
      Size = 100
    end
    object QryCharListMidia: TStringField
      FieldName = 'Midia'
      Origin = 'Midia'
    end
    object QryCharListdescricao: TMemoField
      FieldName = 'descricao'
      Origin = 'descricao'
      OnGetText = QryCharListdescricaoGetText
      BlobType = ftMemo
      Size = 2147483647
    end
  end
  object dtsCharList: TDataSource
    DataSet = QryCharList
    Left = 344
    Top = 144
  end
end
