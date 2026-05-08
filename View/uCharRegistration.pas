unit uCharRegistration;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, PngBitBtn, cCharacter, uDTMConexao;

type
  TfrmCharRegistration = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    pnlContent: TPanel;
    lblName: TLabel;
    lblFranchise: TLabel;
    lblActor: TLabel;
    lblMedia: TLabel;
    lblDescription: TLabel;
    edtName: TEdit;
    cmbFranchise: TComboBox;
    cmbActor: TComboBox;
    cmbMedia: TComboBox;
    memDescription: TMemo;
    pnlFooter: TPanel;
    btnSave: TPngBitBtn;
    btnCancel: TPngBitBtn;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCharacter: TCharacter;
    procedure LoadLists;
    procedure ObjectToScreen;
    procedure ScreenToObject;
  public
    property Character: TCharacter read FCharacter write FCharacter;
    procedure PrepareScreen;
  end;

var
  frmCharRegistration: TfrmCharRegistration;

implementation

{$R *.dfm}

uses
  FireDAC.Comp.Client, cCharacterManager;

procedure TfrmCharRegistration.PrepareScreen;
begin
  // Carrega as opções do banco de dados
  LoadLists;

  // Preenche a tela garantindo que o objeto FCharacter já foi injetado!
  ObjectToScreen;

end;

procedure TfrmCharRegistration.LoadLists;
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := dtmConnection.ConnectionDB;

    // Busca Franquias existentes
    cmbFranchise.Items.Clear;
    Qry.Open('SELECT nome FROM Franquias ORDER BY nome');
    while not Qry.Eof do
    begin
      cmbFranchise.Items.Add(Qry.FieldByName('nome').AsString);
      Qry.Next;
    end;
    Qry.Close;

    // Busca Atores existentes
    cmbActor.Items.Clear;
    Qry.Open('SELECT nome FROM Atores ORDER BY nome');
    while not Qry.Eof do
    begin
      cmbActor.Items.Add(Qry.FieldByName('nome').AsString);
      Qry.Next;
    end;
    Qry.Close;

  finally
    Qry.Free;
  end;
end;

procedure TfrmCharRegistration.ObjectToScreen;
var
  Idx: Integer;
begin
  if Assigned(FCharacter) then
  begin
    edtName.Text := FCharacter.Name;
    memDescription.Text := FCharacter.Description;

    // Busca inteligente na lista recém carregada

    // Franquia
    if FCharacter.Franchise <> '' then
    begin
      Idx := cmbFranchise.Items.IndexOf(FCharacter.Franchise);
      if Idx >= 0 then
        cmbFranchise.ItemIndex := Idx
      else
        cmbFranchise.Text := FCharacter.Franchise;
    end
    else
      cmbFranchise.ItemIndex := -1;

    // Ator
    if FCharacter.ActorOrActress <> '' then
    begin
      Idx := cmbActor.Items.IndexOf(FCharacter.ActorOrActress);
      if Idx >= 0 then
        cmbActor.ItemIndex := Idx
      else
        cmbActor.Text := FCharacter.ActorOrActress;
    end
    else
      cmbActor.ItemIndex := -1;

    // Mídia
    if FCharacter.MediaType <> '' then
    begin
      Idx := cmbMedia.Items.IndexOf(FCharacter.MediaType);
      if Idx >= 0 then
        cmbMedia.ItemIndex := Idx
      else
        cmbMedia.Text := FCharacter.MediaType;
    end
    else
      cmbMedia.ItemIndex := -1;

    if FCharacter.Id > 0 then
      lblTitle.Caption := 'Editar Personagem'
    else
      lblTitle.Caption := 'Novo Personagem';
  end;
end;

procedure TfrmCharRegistration.ScreenToObject;
begin
  FCharacter.Name           := Trim(edtName.Text);
  FCharacter.Franchise      := Trim(cmbFranchise.Text);
  FCharacter.ActorOrActress := Trim(cmbActor.Text);
  FCharacter.MediaType      := Trim(cmbMedia.Text);
  FCharacter.Description    := Trim(memDescription.Text);
end;

procedure TfrmCharRegistration.btnSaveClick(Sender: TObject);
var
  Manager: TCharacterManager;
begin
  // 1. Validação de preenchimento obrigatório
  if Trim(edtName.Text) = '' then
  begin
    ShowMessage('O nome do personagem é obrigatório!');
    edtName.SetFocus;
    Exit;
  end;

  if Trim(cmbFranchise.Text) = '' then
  begin
    ShowMessage('A franquia é obrigatória!');
    cmbFranchise.SetFocus;
    Exit;
  end;

  // Sincroniza a tela com o objeto antes de validar no banco
  ScreenToObject;

  // Validação de Regra de Negócio: Duplicidade (Sem fechar a tela)
  Manager := TCharacterManager.Create(dtmConnection.ConnectionDB);
  try
    if Manager.IsDuplicate(FCharacter.Name, FCharacter.Franchise, FCharacter.Id) then
    begin
      ShowMessage('❌ Atenção: O personagem "' + FCharacter.Name + '" já existe na franquia "' + FCharacter.Franchise + '"!');
      edtName.SetFocus;
      Exit; // O Exit impede que o ModalResult seja definido, mantendo o form aberto
    end;
  finally
    Manager.Free;
  end;

  // Se chegou aqui, passou em tudo!
  ModalResult := mrOk;
end;

procedure TfrmCharRegistration.FormShow(Sender: TObject);
begin
  if edtName.CanFocus then
    edtName.SetFocus;
end;

procedure TfrmCharRegistration.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
