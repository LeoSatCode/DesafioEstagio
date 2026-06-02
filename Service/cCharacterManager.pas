unit cCharacterManager;

interface

uses System.SysUtils, System.IOUtils, System.Generics.Collections,
     FireDAC.Comp.Client, cCharacter, cCharacterService, cCharacterRepository;

type
  TCharacterManager = class
  private
    FRepository: TCharacterRepository;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    procedure SavetoDatabase(ACharacter: TCharacter);
    procedure DeleteFromDatabase(const AId: Integer);
    procedure ImportFromFile(const AFilePath: string; out AImported, ADuplicated: Integer);
    function GetAllCharacters: TObjectList<TCharacter>;
    function IsDuplicate(const AName, AFranchise: string; ACurrentId: Integer = 0): Boolean;
  end;

implementation

{ TCharacterManager }

constructor TCharacterManager.Create(AConnection: TFDConnection);
begin
  inherited Create;
  // Instancia o repositório encapsulando a conexão
  FRepository := TCharacterRepository.Create(AConnection);
end;

destructor TCharacterManager.Destroy;
begin
  FreeAndNil(FRepository);
  inherited;
end;

procedure TCharacterManager.SavetoDatabase(ACharacter: TCharacter);
var
  VFranchiseId, VActorId: Integer;
begin
  // O Manager ordena a lógica de buscar/criar as dependências de texto
  VFranchiseId := FRepository.GetOrCreateFranchise(ACharacter.Franchise);
  VActorId     := FRepository.GetOrCreateActor(ACharacter.ActorOrActress);

  // E manda o repositório salvar o registro puramente mapeado
  FRepository.Save(ACharacter, VFranchiseId, VActorId);
end;

procedure TCharacterManager.DeleteFromDatabase(const AId: Integer);
begin
  FRepository.Delete(AId);
end;

function TCharacterManager.GetAllCharacters: TObjectList<TCharacter>;
begin
  Result := FRepository.GetAll;
end;

function TCharacterManager.IsDuplicate(const AName, AFranchise: string; ACurrentId: Integer): Boolean;
var
  VFranchiseId: Integer;
begin
  VFranchiseId := FRepository.GetOrCreateFranchise(AFranchise);
  Result := FRepository.IsDuplicate(AName, VFranchiseId, ACurrentId);
end;

procedure TCharacterManager.ImportFromFile(const AFilePath: string; out AImported, ADuplicated: Integer);
var
  JsonContent: string;
  CharacterList: TObjectList<TCharacter>;
  Character: TCharacter;
begin
  AImported := 0;
  ADuplicated := 0;

  if not TFile.Exists(AFilePath) then
    raise Exception.Create('Arquivo não encontrado: ' + AFilePath);

  JsonContent := TFile.ReadAllText(AFilePath, TEncoding.UTF8);
  CharacterList := TCharacterService.LoadFromJsonString(JsonContent);

  try
    if Assigned(CharacterList) then
    begin
      for Character in CharacterList do
      begin
        Character.Id := 0;

        if IsDuplicate(Character.Name, Character.Franchise, 0) then
          Inc(ADuplicated)
        else
        begin
          SavetoDatabase(Character);
          Inc(AImported);
        end;
      end;
    end;
  finally
    FreeAndNil(CharacterList);
  end;
end;

end.
