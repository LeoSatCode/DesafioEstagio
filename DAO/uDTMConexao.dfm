object dtmConnection: TdtmConnection
  OldCreateOrder = False
  Height = 150
  Width = 215
  object ConnectionDB: TFDConnection
    Params.Strings = (
      'Database=CineVerseDB'
      'OSAuthent=Yes'
      'Server=VM-TREINODOMTEC'
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 88
    Top = 56
  end
end
