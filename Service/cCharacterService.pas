unit cCharacterService;

interface

uses System.SysUtils, System.Generics.Collections, REST.Json, System.JSON, cCharacter;

type
  TCharacterService = class
    public
      class function LoadFromJsonString(const AJsonString: string): TObjectList<TCharacter>;
  end;

implementation

{ TCharacterService }

class function TCharacterService.LoadFromJsonString(const AJsonString: string): TObjectList<TCharacter>;
var
  JsonArray: TJSONArray;
  JsonValue: TJSONValue;
  Character: TCharacter;
begin
  // Criamos a lista vazia primeiro para garantir que ela exista
  Result := TObjectList<TCharacter>.Create;

  // Lemos a string como um Array JSON nativo do Delphi
  JsonArray := TJSONObject.ParseJSONValue(AJsonString) as TJSONArray;

  if Assigned(JsonArray) then
  begin
    try
      // Percorremos cada objeto dentro do Array
      for JsonValue in JsonArray do
      begin
        // Usamos a magia do REST.Json objeto por objeto!
        Character := TJson.JsonToObject<TCharacter>(JsonValue as TJSONObject);

        if Assigned(Character) then
          Result.Add(Character);
      end;
    finally
      JsonArray.Free; // Liberamos o Array original da memória
    end;
  end;
end;

end.
