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

  uDTMConexao, cUpdateDataBase, Vcl.StdCtrls,
  Vcl.Buttons, PngBitBtn, cCharacterManager, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmPrincipal = class(TForm)
    btnImportar: TPngBitBtn;
    QryCharList: TFDQuery;
    dtsCharList: TDataSource;
    QryCharListpersonagemId: TFDAutoIncField;
    QryCharListPersonagem: TStringField;
    QryCharListFranquia: TStringField;
    QryCharListAtor_Atriz: TStringField;
    QryCharListMidia: TStringField;
    QryCharListdescricao: TMemoField;
    Panel1: TPanel;
    pnl2: TPanel;
    grdCharList: TDBGrid;

    procedure FormCreate(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure QryCharListdescricaoGetText(Sender: TField; var Text: string; DisplayText: Boolean);

  private
    procedure UpdateDataBase;

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnImportarClick(Sender: TObject);
var
  Manager: TCharacterManager;
  Registers: Integer;
  OpenDialog: TOpenDialog; // componente de janela do Windows
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    // Configuramos para ele só mostrar arquivos .json
    OpenDialog.Filter := 'Arquivos JSON (*.json)|*.json|Todos os Arquivos (*.*)|*.*';
    OpenDialog.Title := 'Selecione o arquivo de personagens para importar';

    // O Execute abre a janela. Se o usuário escolheu o arquivo e deu OK, ele entra no IF
    if OpenDialog.Execute then
    begin
      Manager := TCharacterManager.Create(dtmConnection.ConnectionDB);
      try
        // Passamos o caminho exato que o usuário escolheu no Windows!
        Registers := Manager.ImportFromFile(OpenDialog.FileName);

        ShowMessage('Importação concluída! ' + IntToStr(Registers) + ' personagens foram processados.');
      except
        on E: Exception do
          ShowMessage('Erro na importação: ' + E.Message);
      end;
      Manager.Free;
    end;

  finally
    OpenDialog.Free; // Tira a janelinha da memória
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  dtmConnection := TdtmConnection.Create(Self);

 with dtmConnection.ConnectionDB.Params do
begin
  Clear;

  Add('DriverID=MSSQL');
  Add('Server=DC-TR-05-VM\SERVERCURSO');
  Add('Database=CineVerseDB');
  Add('User_Name=sa');
  Add('Password=domtec@10');
end;

  dtmConnection.ConnectionDB.LoginPrompt := False;
  dtmConnection.ConnectionDB.Connected := True;

  UpdateDataBase;

  QryCharList.Connection := dtmConnection.ConnectionDB;
  QryCharList.Open;

  ShowMessage('Banco atualizado com sucesso!');
end;

procedure TfrmPrincipal.QryCharListdescricaoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := Sender.AsString;
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
