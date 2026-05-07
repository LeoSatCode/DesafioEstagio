object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'frmPrincipal'
  ClientHeight = 404
  ClientWidth = 905
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 905
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = -6
    object btnImportar: TPngBitBtn
      Left = 692
      Top = 48
      Width = 101
      Height = 25
      Caption = 'Importar JSON'
      TabOrder = 0
      OnClick = btnImportarClick
    end
    object btnExportar: TPngBitBtn
      Left = 799
      Top = 48
      Width = 99
      Height = 25
      Caption = 'Exportar JSON'
      TabOrder = 1
      OnClick = btnExportarClick
    end
    object mskPesquisar: TMaskEdit
      Left = 0
      Top = 52
      Width = 172
      Height = 21
      TabOrder = 2
      Text = 'mskPesquisar'
    end
    object btnPesquisar: TPngBitBtn
      Left = 178
      Top = 50
      Width = 95
      Height = 25
      Caption = 'PESQUISAR'
      TabOrder = 3
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000000097048597300000B1300000B1301009A9C180000011B4944415478DA
        6364A01030E293949494E4025215401C05C4B240FC188897323333773C79F2E4
        3B5E03A09AF702F19BFFFFFF3701F1354646462D20AE038A09010D71011982CF
        80262065F8FCF9735F2C729B81069D79F6EC59233E03EE006D8D78F1E2C51974
        3909090953A001CB8086ABE233E0DBAF5FBFC4DFBE7DFB195D4E585898978D8D
        ED35D0000E7C065C02BA20098F0B96020D50C3698094945431D000073C61701A
        18064DF85CE00654B41368C816502CFCFDFBF73A30E43541B100C482ACACAC2E
        0F1F3EFC81D50069696907A0A695401C0B54AC0BA4E380C2AA40FC14C85F0CD4
        DC05D28C351D006DB6012A5A0BC4914F9F3EDDC740003052A219C5007234A318
        000CF54540CDF3809A0F10AB196B18900A283600001D378411B9615874000000
        0049454E44AE426082}
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 362
    Width = 905
    Height = 42
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 368
    ExplicitWidth = 993
    DesignSize = (
      905
      42)
    object btnNovo: TPngBitBtn
      Left = 16
      Top = 9
      Width = 75
      Height = 25
      Caption = 'NOVO'
      TabOrder = 0
      OnClick = btnNovoClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000000097048597300000B1300000B1301009A9C18000001334944415478DA
        6364A0103052D5002929A9B6FFFFFF17333232B2A1A9FB0A14F379FAF4E901BC
        06484A4AFE646666967CF2E4C93B3483FF03A9574043C2D10D4177C1FF67CF9E
        61780B240E04B64003D6027124D0907D241B80EC1DA01A1E920CC0A786A001C0
        70E1025215401C05C4B2D0002E6365659DFCF0E1C31F780D806ADE0BC46F8061
        D004C4D780066801711D508C938D8DCD8790014D40CAF0F9F3E7BEE8F240B9CD
        40EA082103EE006D8D78F1E2C5197479090909532626A605840CF8F6EBD72F71
        7676F64FE881F9F3E74F3EA0175EE24D4840FE45A00B9271B90018164BD10D68
        0152A5C8491968C0165C610054771A6F9CCBCBCB73FCFEFD7B37D0900FA058F8
        FBF7EF75A00B3541B100C482C0A87421981B555454D8BF7DFB5606342016C895
        03E2C740CD8B819ABB40E90000C16FB3F24DD6D3D70000000049454E44AE4260
        82}
    end
    object btnEditar: TPngBitBtn
      Left = 97
      Top = 9
      Width = 75
      Height = 25
      Caption = 'EDITAR'
      TabOrder = 1
      OnClick = btnEditarClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000000097048597300000B1300000B1301009A9C18000001474944415478DA
        B5924D4B846010C77B148BF4A210F94A274F9EBBD635C24B6D876821E8B4D7BE
        4D6C11DD5A88680F9D0A3AC5D207E8185E44D035108D45C983DA7F2F829BDA82
        3430CC3CF3CCFC861986AC7414B26CA2288A1C4DD3F770B7A17DD7755F4A80AA
        AA669EE7978410B5A6769265D911455177F8B7A0A3A2284600C825409665071F
        C708BE2D566B9AB60EC0235CC7F3BC81A2281700A8F0CD12806081E25FE31886
        B11A86E1186E2C08C229FC211AE9699A9A4110CC5A01BAAEAFC5713C46C117CF
        F36751145DA3B38251FBBEEF7F56965807C058E728DE6359F63049921B8436B0
        8703009E91BBFB2700B107749C01B2397F330CD3B36DFB7B31B70940107B87FD
        00E495E3B8A16559695D6E23005AD4DDC3B28046F91FC0FC90604E701C93B662
        E4EDC0DC226FAB029024691FDBBE826A6D002CD4810EA6D3E95305D0453A037E
        00228FB6115BBA0A080000000049454E44AE426082}
    end
    object btnExcluir: TPngBitBtn
      Left = 178
      Top = 9
      Width = 75
      Height = 25
      Caption = 'EXCLUIR'
      TabOrder = 2
      OnClick = btnExcluirClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000000097048597300000B1300000B1301009A9C18000000814944415478DA
        6364A0103062139492926AFBFFFF7F312323231B90FE0514EA7EFEFC790DD106
        484A4AFE646666967CF2E4C93B191919A1BF7FFF3E031AC081D700A0ADFF8975
        F6B367CF18310C20D61064CD380D002902B1D1E95103868401A014084ABEB8D2
        003059FF444F91E82E68052A2AC16608AE3C81352F9002283600009740A411A2
        2B1A210000000049454E44AE426082}
    end
    object btnFechar: TPngBitBtn
      Left = 823
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'FECHAR'
      TabOrder = 3
      OnClick = btnFecharClick
      ExplicitLeft = 742
    end
  end
  object grdCharList: TDBGrid
    Left = 0
    Top = 81
    Width = 905
    Height = 281
    Align = alClient
    DataSource = dtsCharList
    DrawingStyle = gdsClassic
    FixedColor = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWhite
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    OnDrawColumnCell = grdCharListDrawColumnCell
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
        Width = 91
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
