unit cCharacterManager;

interface

uses System.SysUtils, System.IOUtils, System.Generics.Collections,
     FireDAC.Comp.Client, cCharacter, cCharacterService;

Type
  TCharacterManager = class  //A ponte reintroduce o arquivo, o processamento de dados e a persistencia no banco
  private
    FConnection: TFDConnection;

    function GetOrCreateFranchise(const AName: string): Integer;
    function GetOrCreateActor(const AName: string): Integer;

  public
    constructor Create(AConnection: TFDConnection);
    procedure SavetoDatabase(ACharacter: TCharacter);
    procedure DeleteFromDatabase(const AId: Integer);
    procedure ImportFromFile(const AFilePath: string; out AImported, ADuplicated: Integer); //Função que será chmada pelo Form
    function GetAllCharacters: TObjectList<TCharacter>; //Pega todos os personagens da lista
    function IsDuplicate(const AName, AFranchise: string; ACurrentId: Integer = 0): Boolean;
  end;

implementation

{ TCharacterManager }

constructor TCharacterManager.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

procedure TCharacterManager.SavetoDatabase(ACharacter: TCharacter);
var Qry: TFDQuery;
    VFranchiseId, VActorId: Integer;
begin
  VFranchiseId := GetOrCreateFranchise(ACharacter.Franchise); //Resolução de dependências (Chaves Estrangeiras)
  VActorId     := GetOrCreateActor(ACharacter.ActorOrActress);

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConnection;

    if ACharacter.Id > 0 then //Se já tiver um Id, faz o UPDATE
    begin
      Qry.SQL.Text := 'UPDATE Personagens SET '+
                      ' nome = :nome, '+
                      ' descricao = :descricao, '+
                      ' tipoMidia = :tipoMidia, '+
                      ' franquiaId = :franquiaId, '+
                      ' atorId = :atorId '+
                      'WHERE personagemId = :id';
      Qry.ParamByName('id').AsInteger := ACharacter.Id;
    end
    else //Do contrário, faz o INSERT
    begin
      Qry.SQL.Text := 'IF NOT EXISTS (SELECT 1 FROM Personagens WHERE nome = :nome AND franquiaId = :franquiaId) '+//Já faz o tratamento de duplicidades
                      'BEGIN '+                                                                                      //e insere personagens APENAS se não existirem
                      ' INSERT INTO Personagens (nome, descricao, tipoMidia, franquiaId, atorId) '+                  //naquela franquia.
                      ' VALUES (:nome, :descricao, :tipoMidia, :franquiaId, :atorId) '+
                      'END';
    end;

    Qry.ParamByName('nome').AsString        := ACharacter.Name;
    Qry.ParamByName('descricao').AsString   := ACharacter.Description;
    Qry.ParamByName('tipoMidia').AsString   := ACharacter.MediaType;

    Qry.ParamByName('franquiaId').AsInteger := VFranchiseId;
    Qry.ParamByName('atorId').AsInteger     := VActorId;

    Qry.ExecSQL;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TCharacterManager.DeleteFromDatabase(const AId: Integer);
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConnection;
    Qry.SQL.Text := 'DELETE FROM Personagens WHERE personagemId = :id';
    Qry.ParamByName('id').AsInteger := AId;
    Qry.ExecSQL;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TCharacterManager.ImportFromFile(const AFilePath: string; out AImported, ADuplicated: Integer);
var JsonContent:   string;
    CharacterList: TObjectList<TCharacter>;
    Character:     TCharacter;
begin
  // Zera os contadores de saída
  AImported := 0;
  ADuplicated := 0;

  if not TFile.Exists(AFilePath) then //Se o caminho do arquivo não existir, tratamos o erro
    raise Exception.Create('Arquivo não encontrado: ' + AFilePath);

  JsonContent := TFile.ReadAllText(AFilePath, TEncoding.UTF8);//Leitura do JSON

  CharacterList := TCharacterService.LoadFromJsonString(JsonContent);//A lista recebe o conteúdo carregado do JSON
  try
    if Assigned(CharacterList) then
    begin
      for Character in CharacterList do //Percorre os personagens da lista
      begin
        Character.Id := 0;

        // Usa a função IsDuplicate para checar duplicidade
        if IsDuplicate(Character.Name, Character.Franchise, 0) then
        begin
          Inc(ADuplicated); // Conta como repetido e ignora
        end
        else
        begin
          SavetoDatabase(Character);
          Inc(AImported); // Conta como sucesso
        end;
      end;
    end;
  finally
    FreeAndNil(CharacterList);
  end;
end;

function TCharacterManager.GetOrCreateFranchise(const AName: string): Integer;
var Qry: TFDQuery;
begin
  Result := 0;
  if AName.Trim.IsEmpty then Exit;  //O Trim remove espaços no inicio e final da string, se o nome estiver vazio, é tchau, brigado (y)

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConnection;

    Qry.SQL.Text   := 'SELECT franquiaId FROM Franquias WHERE nome = :nome'; //Faz o Select pra achar a Franquia existente
    Qry.ParamByName('nome').AsString := AName;
    Qry.Open;

    if not Qry.IsEmpty then
      Result := Qry.FieldByName('franquiaId').AsInteger
    else
    begin
      Qry.Close;      //Se não achou a Franquia, faz uma inserção da mesma já retornando o ID gerado pelo IDENTITY do SQL Server
      Qry.SQL.Text := 'INSERT INTO Franquias (nome) VALUES (:nome); SELECT SCOPE_IDENTITY() AS NewID;';
      Qry.ParamByName('nome').AsString := AName;
      Qry.Open;
      Result := Qry.FieldByName('NewID').AsInteger; //Campo criado no ato do INSERT
    end;

  finally
    FreeAndNil(Qry);
  end;
end;

function TCharacterManager.GetOrCreateActor(const AName: string): Integer;
var Qry: TFDQuery;
begin
  Result := 0;
  if AName.Trim.IsEmpty then Exit;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConnection;

    //A mesma lógica das Franquias, pode ser usada nos Atores
    Qry.SQL.Text   := 'SELECT atorId FROM Atores WHERE nome = :nome';
    Qry.ParamByName('nome').AsString := AName;
    Qry.Open;

    if not Qry.IsEmpty then
      Result := Qry.FieldByName('atorId').AsInteger
    else
    begin
      Qry.Close;
      Qry.SQL.Text := 'INSERT INTO Atores (nome) VALUES (:nome); SELECT SCOPE_IDENTITY() AS NewID;';
      Qry.ParamByName('nome').AsString := AName;
      Qry.Open;
      Result := Qry.FieldByName('NewID').AsInteger;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

function TCharacterManager.GetAllCharacters: TObjectList<TCharacter>;
var Qry:  TFDQuery;
    Char: TCharacter;
begin
  Result := TObjectList<TCharacter>.Create(True);
  Qry    := TFDQuery.Create(nil);
  try
    Qry.Connection := FConnection;

    //O SELECT maroto com os JOINs
    Qry.Open('SELECT P.personagemId, P.nome, P.descricao, P.tipoMidia, F.nome as Franquia, A.nome as Ator ' +
             'FROM Personagens P ' +
             'LEFT JOIN Franquias F ON F.franquiaId = P.franquiaId ' +
             'LEFT JOIN Atores A ON A.atorId = P.atorId');

    while not Qry.Eof do //Enquanto a Qry não estiver vazia.
    begin
      Char                := TCharacter.Create;
      Char.Id             := Qry.FieldByName('personagemId').AsInteger;
      Char.Name           := Qry.FieldByName('nome').AsString;
      Char.Description    := Qry.FieldByName('descricao').AsString;
      Char.MediaType      := Qry.FieldByName('tipoMidia').AsString;
      Char.Franchise      := Qry.FieldByName('Franquia').AsString;
      Char.ActorOrActress := Qry.FieldByName('Ator').AsString;

      Result.Add(Char);
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;
end;

function TCharacterManager.IsDuplicate(const AName, AFranchise: string; ACurrentId: Integer): Boolean;
var Qry: TFDQuery;
    VFranchiseId: Integer;
begin
  Result := False;

  // Pegamos o ID da Franquia para usar no Select
  VFranchiseId := GetOrCreateFranchise(AFranchise);

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConnection;

    // Buscamos pelos nomes de colunas corretos da tabela.
    Qry.SQL.Text := 'SELECT 1 FROM Personagens WHERE nome = :nome AND franquiaId = :franquiaId AND personagemId <> :id';

    Qry.ParamByName('nome').AsString       := AName;
    Qry.ParamByName('franquiaId').AsInteger := VFranchiseId;
    Qry.ParamByName('id').AsInteger        := ACurrentId;

    Qry.Open;
    Result := not Qry.IsEmpty;
  finally
    Qry.Free;
  end;
end;

end.
