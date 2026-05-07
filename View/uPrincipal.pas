unit uPrincipal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils, System.Generics.Collections,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,

  uDTMConexao, cUpdateDataBase, Vcl.StdCtrls,
  Vcl.Buttons, PngBitBtn, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
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
    edtNovo: TPngBitBtn;
    btnEditar: TPngBitBtn;
    btnExcluir: TPngBitBtn;
    btnExportar: TPngBitBtn;

    procedure FormCreate(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure QryCharListdescricaoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure edtNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);

  private
    procedure UpdateDataBase;

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses cCharacter, uCharRegistration,cCharacterManager, cCharacterService;


procedure TfrmPrincipal.btnExcluirClick(Sender: TObject);
var Manager: TCharacterManager;
    PersonagemId: Integer;
    NomePersonagem: string;
begin
  if QryCharList.IsEmpty then Exit; // Se a grid estiver vazia, é tchau brigado

  PersonagemId   := QryCharList.FieldByName('personagemId').AsInteger; //Carrega os dados do personagem selecionado antes de apagar
  NomePersonagem := QryCharList.FieldByName('Personagem').AsString;

  // PVerificação para confirmação da exclusão
  if MessageDlg('Tem certeza que deseja excluir o personagem "' + NomePersonagem + '" da base de dados?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Manager := TCharacterManager.Create(dtmConnection.ConnectionDB); //Joga a responsabilidade da exclusão pro nosso Manager que contém o CRUD
    try
      Manager.DeleteFromDatabase(PersonagemId); // Chama o método de exclusão

      QryCharList.Refresh;
      ShowMessage('Personagem excluído com sucesso!');
    finally
      Manager.Free;
    end;
  end;
end;

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
  QryCharList.Refresh;
end;

procedure TfrmPrincipal.btnExportarClick(Sender: TObject);
var Manager:    TCharacterManager;
    SaveDialog: TSaveDialog;
    List:       TObjectList<TCharacter>;
begin
  if QryCharList.IsEmpty then //Novamente se a lista estiver vazia é tchau brigado
  begin
     ShowMessage('Não há dados para exportar!');
     Exit;
  end;

  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Filter := 'Arquivo JSON (*.json)|*.json';
    SaveDialog.DefaultExt := 'json';
    SaveDialog.FileName := 'CineVerse_Export.json';

    if SaveDialog.Execute then
    begin
      Manager := TCharacterManager.Create(dtmConnection.ConnectionDB);
      try
        List  := Manager.GetAllCharacters; //O Manager busca lá no banco todos os personagens
        try
          if TCharacterService.SaveToFile(List, SaveDialog.FileName) then // O Service gera o JSON
            ShowMessage('Dados exportados com sucesso para JSON!')
          else
            ShowMessage('Falha ao exportar dados.');
        finally
          List.Free;
        end;
      finally
        Manager.Free;
      end;
    end;
  finally
    SaveDialog.Free;
  end;
end;

procedure TfrmPrincipal.edtNovoClick(Sender: TObject);
var Char:    TCharacter;
    Manager: TCharacterManager;
begin
  Char := TCharacter.Create; //Criação de um personagem zerado em memória

  frmCharRegistration := TfrmCharRegistration.Create(Self); //Instância da tela de cadastro

  try
    frmCharRegistration.Character := Char; //Personagem zeradinho pra tela (Injeção de Dependência)

    if frmCharRegistration.ShowModal = mrOk then //Se o usuário clicar em "Salvar", entra no IF
    begin
      Manager := TCharacterManager.Create(dtmConnection.ConnectionDB); //Como o usuário confirmou, então é criada a instância da nossa conexão com o banco
      try
        Manager.SaveToDatabase(Char); //Salva o personagem com o mesmo método usado para o JSON
        QryCharList.Refresh; //Atualizamos a Grid
      finally
        Manager.Free;
      end;
    end;
  finally
    frmCharRegistration.Free;
    Char.Free;
  end;
end;

procedure TfrmPrincipal.btnEditarClick(Sender: TObject);
var Char:    TCharacter;
    Manager: TCharacterManager;
begin
  if QryCharList.IsEmpty then Exit; //Se o grid estiver vazio é tchau, bragido

  Char := TCharacter.Create;

  //Preenchimento dos dados do personagem da linha selecionada utilizando os Aliases do SELECT na QryCharList
  Char.Id             := QryCharList.FieldByName('personagemId').AsInteger;
  Char.Name           := QryCharList.FieldByName('Personagem').  AsString;
  Char.Franchise      := QryCharList.FieldByName('Franquia').    AsString;
  Char.ActorOrActress := QryCharList.FieldByName('Ator_Atriz').  AsString;
  Char.MediaType      := QryCharList.FieldByName('Midia').       AsString;
  Char.Description    := QryCharList.FieldByName('descricao').   AsString;

  frmCharRegistration := TfrmCharRegistration.Create(Self); //Instância da tela igual do botão NOVO
  try
    frmCharRegistration.Character := Char; //Injeção de dependência

    if frmCharRegistration.ShowModal = mrOk then  //Se o usuário clicou em editar
    begin
      Manager := TCharacterManager.Create(dtmConnection.ConnectionDB);//Cria a instância da conexão com o banco de dados
      try
        Manager.SavetoDatabase(Char); //Chamamos o método para salvar as alterações

        QryCharList.Refresh; //Refresh maroto pra atualizar o grid
        ShowMessage('Personagem atualizado com sucesso!');
      finally
        Manager.Free; //Limpamos da memória
      end;
    end;
  finally
    frmCharRegistration.Free; //Aqui também
    Char.Free;
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
