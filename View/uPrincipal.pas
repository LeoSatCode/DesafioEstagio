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
  Vcl.ExtCtrls, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Mask;

type
  TfrmPrincipal = class(TForm)
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
    btnNovo: TPngBitBtn;
    btnEditar: TPngBitBtn;
    btnExcluir: TPngBitBtn;
    btnFechar: TPngBitBtn;
    btnImportar: TPngBitBtn;
    btnExportar: TPngBitBtn;
    mskPesquisar: TMaskEdit;
    btnPesquisar: TPngBitBtn;

    procedure FormCreate(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure QryCharListdescricaoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure grdCharListDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure btnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mskPesquisarChange(Sender: TObject);
    procedure mskPesquisarKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdCharListTitleClick(Column: TColumn);
    procedure btnPesquisarClick(Sender: TObject);


  private
    procedure UpdateDataBase;

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses cCharacter, uCharRegistration,cCharacterManager, cCharacterService, cGridUtils, cSearchUtils;


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
  Imported, Duplicated: Integer;
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
        //Passa as variáveis para o Manager preencher
        Manager.ImportFromFile(OpenDialog.FileName, Imported, Duplicated);
        ShowMessage('Processamento do JSON concluído!' + sLineBreak + sLineBreak +
                    '✅ Registros Importados: ' + IntToStr(Imported) + sLineBreak +
                    '⚠️ Duplicados Ignorados: ' + IntToStr(Duplicated));
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

procedure TfrmPrincipal.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.btnNovoClick(Sender: TObject);
var Char: TCharacter;
    Manager: TCharacterManager;
begin
  Char := TCharacter.Create;
  frmCharRegistration := TfrmCharRegistration.Create(Self);
  try
    // 1. Injeta a dependência
    frmCharRegistration.Character := Char;

    // 2. Prepara a tela (Carrega listas e seta os combos de forma segura)
    frmCharRegistration.PrepareScreen;

    repeat
      if frmCharRegistration.ShowModal = mrOk then
      begin
        Manager := TCharacterManager.Create(dtmConnection.ConnectionDB);
        try
          if Manager.IsDuplicate(Char.Name, Char.Franchise, Char.Id) then
          begin
            ShowMessage('❌ Atenção: O personagem "' + Char.Name + '" já existe na franquia "' + Char.Franchise + '"!');
            Continue; // Reabre a tela!
          end;

          Manager.SaveToDatabase(Char);
          QryCharList.Refresh;
          Break; // Sai do laço, deu tudo certo
        finally
          Manager.Free;
        end;
      end
      else
        Break; // Cancelou a tela
    until False;

  finally
    frmCharRegistration.Free;
    Char.Free;
  end;
end;

procedure TfrmPrincipal.btnPesquisarClick(Sender: TObject);
begin
  TSearchUtils.ApplyFastFilter(QryCharList, mskPesquisar.Text);
end;


procedure TfrmPrincipal.btnEditarClick(Sender: TObject);
var Char:    TCharacter;
    Manager: TCharacterManager;
begin
  if QryCharList.IsEmpty then Exit; //Se o grid estiver vazio é tchau, brigado

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
    // 1. Injeta a dependência com os dados do Grid
    frmCharRegistration.Character := Char;

    // 2. Prepara a tela e seleciona os itens corretos no ComboBox
    frmCharRegistration.PrepareScreen;

    repeat
      if frmCharRegistration.ShowModal = mrOk then
      begin
        Manager := TCharacterManager.Create(dtmConnection.ConnectionDB);
        try
          // Passa o Char.Id para ele saber que está editando
          if Manager.IsDuplicate(Char.Name, Char.Franchise, Char.Id) then
          begin
            ShowMessage('❌ Atenção: O personagem "' + Char.Name + '" já existe na franquia "' + Char.Franchise + '"!');
            Continue;
          end;

          Manager.SavetoDatabase(Char);
          QryCharList.Refresh;
          ShowMessage('Personagem atualizado com sucesso!');
          Break;
        finally
          Manager.Free;
        end;
      end
      else
        Break;
    until False;
  finally
    frmCharRegistration.Free;
    Char.Free;
  end;

end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TGrid.SaveGrid(grdCharList, 'CineVerse.ini', 'Leo', Self.Name);
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
  QryCharList.FetchAll; // Traz tudo pra RAM!

  try
    TGrid.LoadGrid(grdCharList, 'CineVerse.ini', 'Leo', Self.Name);
  finally
    mskPesquisar.OnChange := mskPesquisarChange;
  end;
end;


procedure TfrmPrincipal.grdCharListDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  TGrid.ZebrarGrid(TDBGrid(Sender), State, Column, Rect, DataCol);
end;

procedure TfrmPrincipal.grdCharListTitleClick(Column: TColumn);
begin
  TGrid.OrderGrid(Column);
end;

procedure TfrmPrincipal.mskPesquisarChange(Sender: TObject);
begin
  TSearchUtils.ApplyFastFilter(QryCharList, mskPesquisar.Text);
end;

procedure TfrmPrincipal.mskPesquisarKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    btnPesquisar.Click;
    Key := 0;
  end;
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
