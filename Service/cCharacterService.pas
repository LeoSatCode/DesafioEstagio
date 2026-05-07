unit cCharacterService;

interface

uses System.SysUtils, System.Generics.Collections, REST.Json, Vcl.Dialogs, System.JSON, System.IOUtils, cCharacter;

type
  TCharacterService = class
    public
      class function LoadFromJsonString(const AJsonString: string): TObjectList<TCharacter>;
      class function SaveToFile(AList: TObjectList<TCharacter>; const AFilePath: string): Boolean;
  end;

implementation

{ TCharacterService }

class function TCharacterService.LoadFromJsonString(const AJsonString: string): TObjectList<TCharacter>;
var JsonRoot:  TJSONValue;
    JsonArray: TJSONArray;
    JsonValue: TJSONValue;
    Character: TCharacter;
begin
  Result := TObjectList<TCharacter>.Create;

  // Lemos a raiz do JSON, seja Arrya ou Objeto
  JsonRoot := TJSONObject.ParseJSONValue(AJsonString);

  if not Assigned(JsonRoot) then Exit;

  try

    if JsonRoot is TJSONArray then
    begin
      // Formato Padrão estabelecido pelo Jurado
      JsonArray := JsonRoot as TJSONArray;
    end
    else if JsonRoot is TJSONObject then
    begin
      // Formato "Diferentão" (Começa com chave). Vamos procurar a lista 'items'
      JsonValue := TJSONObject(JsonRoot).GetValue('items');

      // Se achou o 'items' e ele é um Array, nós pegamos ele!
      if Assigned(JsonValue) and (JsonValue is TJSONArray) then
        JsonArray := JsonValue as TJSONArray
      else
        Exit; // É um objeto desconhecido, tchau brigado.
    end
    else
      Exit;

    // Agora que isolamos o Array (seja de onde ele veio), o processamento é idêntico!
    for JsonValue in JsonArray do
    begin
      Character := TJson.JsonToObject<TCharacter>(JsonValue as TJSONObject);
      if Assigned(Character) then
        Result.Add(Character);
    end;

  finally
    // Limpamos a raiz da memória
    JsonRoot.Free;
  end;
end;

class function TCharacterService.SaveToFile(AList: TObjectList<TCharacter>; const AFilePath: string): Boolean;
var JsonArray: TJSONArray;
    CharItem: TCharacter;
    JsonContent: string;
begin
  Result := False;
  if not Assigned(AList) then Exit;    //Se a lista for nula é tchau brigado

  JsonArray := TJSONArray.Create;
  try
    try
      for CharItem in AList do // Percorremos a nossa lista e convertemos cada Personagem em um Objeto JSON,
      begin
        JsonArray.AddElement(TJson.ObjectToJsonObject(CharItem)); //adicionando eles diretamente no nosso Array limpo!
      end;

      // Transformamos o Array em texto JSON
      JsonContent := TJson.Format(JsonArray);

      // Salva no disco
      TFile.WriteAllText(AFilePath, JsonContent, TEncoding.UTF8);
      Result := True;
    except
      on E: Exception do
      begin
        ShowMessage('Erro ao exportar: ' + E.Message);
        Result := False;
      end;
    end;
  finally
    JsonArray.Free;
  end;
end;
end.
