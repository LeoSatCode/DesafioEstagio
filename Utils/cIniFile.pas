unit cIniFile;

interface

uses
  System.SysUtils, System.IniFiles, Vcl.Forms;

type
  TConnectionParams = record
    Server: string;
    Database: string;
    OSAuthent: Boolean; // Define se usa Autenticação do Windows
    UserName: string;
    Password: string;
  end;

  TConfigService = class
  private
    FFilePath: string;
  public
    constructor Create;
    function GetConnectionParams: TConnectionParams;
    procedure SaveDefaultConfig(AParams: TConnectionParams);
  end;

implementation

constructor TConfigService.Create;
begin
  // Salva o Config.ini sempre na mesma pasta do executável .exe
  FFilePath := ExtractFilePath(Application.ExeName) + 'Config.ini';
end;

function TConfigService.GetConnectionParams: TConnectionParams;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FFilePath);
  try
    // Lê os dados. Se não existir, assume os valores padrão (da sua VM)
    Result.Server    := Ini.ReadString('Database', 'Server', 'DC-TR-05-VM\SERVERCURSO');
    Result.Database  := Ini.ReadString('Database', 'Database', 'CineVerseDB');
    Result.OSAuthent := Ini.ReadBool('Database', 'OSAuthent', True); // True = Autenticação do Windows
    Result.UserName  := Ini.ReadString('Database', 'User', 'sa');
    Result.Password  := Ini.ReadString('Database', 'Password', 'domtec@10');
  finally
    Ini.Free;
  end;
end;

procedure TConfigService.SaveDefaultConfig(AParams: TConnectionParams);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FFilePath);
  try
    Ini.WriteString('Database', 'Server', AParams.Server);
    Ini.WriteString('Database', 'Database', AParams.Database);
    Ini.WriteBool('Database', 'OSAuthent', AParams.OSAuthent);
    Ini.WriteString('Database', 'User', AParams.UserName);
    Ini.WriteString('Database', 'Password', AParams.Password);
  finally
    Ini.Free;
  end;
end;

end.
