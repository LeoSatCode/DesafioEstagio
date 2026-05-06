object dtmConnection: TdtmConnection
  OldCreateOrder = False
  Height = 150
  Width = 215
  object ConnectionDB: TFDConnection
    Params.Strings = (
      'Database=CineVerseDB'
      'Server=DC-TR-05-VM\SERVERCURSO'
      'User_Name=sa'
      'Password=domtec@10'
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 88
    Top = 56
  end
end
