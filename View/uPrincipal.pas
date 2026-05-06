unit uPrincipal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,

  uDTMConexao,
  cUpdateDataBase;

type
  TfrmPrincipal = class(TForm)

    procedure FormCreate(Sender: TObject);

  private
    procedure UpdateDataBase;

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  dtmConnection := TdtmConnection.Create(Self);

 with dtmConnection.ConnectionDB.Params do
begin
  Clear;

  Add('DriverID=MSSQL');
  Add('Server=VM-TREINODOMTEC');
  Add('Database=CineVerseDB');
  Add('OSAuthent=Yes');
end;

  dtmConnection.ConnectionDB.LoginPrompt := False;
  dtmConnection.ConnectionDB.Connected := True;

  UpdateDataBase;

  ShowMessage('Banco atualizado com sucesso!');
end;

procedure TfrmPrincipal.UpdateDataBase;
var
  oUpdate: TUpdateDataBaseMSSQL;
begin
  oUpdate := nil;

  try
    oUpdate := TUpdateDataBaseMSSQL.Create(
      dtmConnection.ConnectionDB
    );

    oUpdate.UpdateDataBase;

  finally
    if Assigned(oUpdate) then
      FreeAndNil(oUpdate);
  end;
end;

end.
