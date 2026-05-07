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
    // O formulário recebe o objeto via Injeção de Dependência
    property Character: TCharacter read FCharacter write FCharacter;
  end;

var
  frmCharRegistration: TfrmCharRegistration;

implementation

{$R *.dfm}

uses
  FireDAC.Comp.Client;

procedure TfrmCharRegistration.FormShow(Sender: TObject);
begin
  LoadLists; // Carrega o que já existe no banco nos ComboBoxes
  ObjectToScreen; // Se for edição, preenche a tela
  edtName.SetFocus;
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

    // Busca Atores existentes
    cmbActor.Items.Clear;
    Qry.Open('SELECT nome FROM Atores ORDER BY nome');
    while not Qry.Eof do
    begin
      cmbActor.Items.Add(Qry.FieldByName('nome').AsString);
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;
end;

procedure TfrmCharRegistration.ObjectToScreen;
begin
  if Assigned(FCharacter) then
  begin
    edtName.Text        := FCharacter.Name;
    cmbFranchise.Text   := FCharacter.Franchise;
    cmbActor.Text       := FCharacter.ActorOrActress;
    cmbMedia.Text       := FCharacter.MediaType;
    memDescription.Text := FCharacter.Description;

    cmbMedia.ItemIndex  := cmbMedia.Items.IndexOf(FCharacter.MediaType); //Recupera o tipo de media ao carregar um personagem existente.

    if FCharacter.Id > 0 then
      lblTitle.Caption := 'Editar Personagem'
    else
      lblTitle.Caption := 'Novo Personagem';
  end;
end;

procedure TfrmCharRegistration.ScreenToObject;
begin
  FCharacter.Name           := edtName.Text;
  FCharacter.Franchise      := cmbFranchise.Text;
  FCharacter.ActorOrActress := cmbActor.Text;
  FCharacter.MediaType      := cmbMedia.Text;
  FCharacter.Description    := memDescription.Text;
end;

procedure TfrmCharRegistration.btnSaveClick(Sender: TObject);
begin
  // Validação simples usando o método Trim
  if Trim(edtName.Text) = '' then
  begin
    ShowMessage('O nome do personagem é obrigatório!');
    edtName.SetFocus;
    Exit;
  end;

  ScreenToObject;
  ModalResult := mrOk; // Fecha a tela avisando que pode salvar
end;

procedure TfrmCharRegistration.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
