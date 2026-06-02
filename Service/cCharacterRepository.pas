unit cCharacterRepository;

interface

uses System.SysUtils, System.Generics.Collections, FireDAC.Comp.Client, cCharacter;

type
  TCharacterRepository = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);

    function GetOrCreateFranchise(const AName: string): Integer;
    function GetOrCreateActor(const AName: string): Integer;
    function IsDuplicate(const AName: string; const AFranchiseId: Integer; const ACurrentId: Integer = 0): Boolean;

    procedure Save(ACharacter: TCharacter; const AFranchiseId, AActorId: Integer);
    procedure Delete(const AId: Integer);
    function GetAll: TObjectList<TCharacter>;
  end;

implementation

constructor TCharacterRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TCharacterRepository.GetOrCreateFranchise(const AName: string): Integer;
var Qry: TFDQuery;
begin
  Result := 0;
  if AName.Trim.IsEmpty then Exit;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConnection;
    Qry.SQL.Text   := 'SELECT franquiaId FROM Franquias WHERE nome = :nome';
    Qry.ParamByName('nome').AsString := AName.Trim;
    Qry.Open;

    if not Qry.IsEmpty then
      Result := Qry.FieldByName('franquiaId').AsInteger
    else
    begin
      Qry.SQL.Text := 'INSERT INTO Franquias (nome) OUTPUT INSERTED.franquiaId AS NewID VALUES (:nome)';
      Qry.ParamByName('nome').AsString := AName.Trim;
      Qry.Open;
      Result := Qry.FieldByName('NewID').AsInteger;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

function TCharacterRepository.GetOrCreateActor(const AName: string): Integer;
var Qry: TFDQuery;
begin
  Result := 0;
  if AName.Trim.IsEmpty then Exit;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConnection;

    Qry.SQL.Text   := 'SELECT atorId FROM Atores WHERE nome = :nome';
    Qry.ParamByName('nome').AsString := AName.Trim;
    Qry.Open;

    if not Qry.IsEmpty then
      Result := Qry.FieldByName('atorId').AsInteger
    else
    begin
      Qry.SQL.Text := 'INSERT INTO Atores (nome) OUTPUT INSERTED.atorId AS NewID VALUES (:nome)';
      Qry.ParamByName('nome').AsString := AName.Trim;
      Qry.Open;
      Result := Qry.FieldByName('NewID').AsInteger;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

function TCharacterRepository.IsDuplicate(const AName: string; const AFranchiseId: Integer; const ACurrentId: Integer): Boolean;
var Qry: TFDQuery;
begin
  Result := False;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConnection;
    Qry.SQL.Text := 'SELECT 1 FROM Personagens WHERE nome = :nome AND franquiaId = :franquiaId AND personagemId <> :id';
    Qry.ParamByName('nome').AsString        := AName;
    Qry.ParamByName('franquiaId').AsInteger := AFranchiseId;
    Qry.ParamByName('id').AsInteger         := ACurrentId;
    Qry.Open;
    Result := not Qry.IsEmpty;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TCharacterRepository.Save(ACharacter: TCharacter; const AFranchiseId, AActorId: Integer);
var Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConnection;

    if ACharacter.Id > 0 then
    begin
      Qry.SQL.Text := 'UPDATE Personagens SET nome = :nome, descricao = :descricao, ' +
                      'tipoMidia = :tipoMidia, franquiaId = :franquiaId, atorId = :atorId ' +
                      'WHERE personagemId = :id';
      Qry.ParamByName('id').AsInteger := ACharacter.Id;
    end
    else
    begin
      Qry.SQL.Text := 'IF NOT EXISTS (SELECT 1 FROM Personagens WHERE nome = :nome AND franquiaId = :franquiaId) ' +
                      'BEGIN ' +
                      ' INSERT INTO Personagens (nome, descricao, tipoMidia, franquiaId, atorId) ' +
                      ' VALUES (:nome, :descricao, :tipoMidia, :franquiaId, :atorId) ' +
                      'END';
    end;

    Qry.ParamByName('nome').AsString        := ACharacter.Name;
    Qry.ParamByName('descricao').AsString   := ACharacter.Description;
    Qry.ParamByName('tipoMidia').AsString   := ACharacter.MediaType;
    Qry.ParamByName('franquiaId').AsInteger := AFranchiseId;
    Qry.ParamByName('atorId').AsInteger     := AActorId;

    Qry.ExecSQL;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TCharacterRepository.Delete(const AId: Integer);
var Qry: TFDQuery;
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

function TCharacterRepository.GetAll: TObjectList<TCharacter>;
var Qry: TFDQuery;
    Char: TCharacter;
begin
  Result := TObjectList<TCharacter>.Create(True);
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConnection;
    Qry.Open('SELECT P.personagemId, P.nome, P.descricao, P.tipoMidia, F.nome as Franquia, A.nome as Ator ' +
             'FROM Personagens P ' +
             'LEFT JOIN Franquias F ON F.franquiaId = P.franquiaId ' +
             'LEFT JOIN Atores A ON A.atorId = P.atorId');

    while not Qry.Eof do
    begin
      Char := TCharacter.Create;
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
    FreeAndNil(Qry);
  end;
end;

end.
