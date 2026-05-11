unit uTestCharacterService;

interface

uses
  DUnitX.TestFramework,
  System.Generics.Collections,
  cCharacterService,
  cCharacter; // Precisamos conhecer a Model para checar os dados

type
  [TestFixture]
  TTestCharacterService = class
  public
    // Não precisamos de Setup e TearDown porque usaremos métodos de Classe (Static)

    [Test]
    procedure Test_LoadFromJson_JsonValido_DeveRetornarListaPreenchida;

    [Test]
    procedure Test_LoadFromJson_StringVazia_DeveRetornarListaVazia;
  end;

implementation

{ TTestCharacterService }

procedure TTestCharacterService.Test_LoadFromJson_JsonValido_DeveRetornarListaPreenchida;
var
  LJsonString: string;
  LListaRetorno: TObjectList<TCharacter>;
begin
  // Arrange: Montamos um JSON verdadeiro ou falso direto na memória para o teste
  LJsonString := '[{"nome": "Tony Stark", "franquia": "Universo Cinematográfico Marvel", "ator_ou_atriz": "Robert Downey Jr.", "descricao": "Bilionário, gênio, playboy e filantropo que constrói uma armadura voadora de alta tecnologia.", "tipo_de_midia": "Filme"}]';

  // Act: Disparamos o serviço passando a nossa string
  LListaRetorno := TCharacterService.LoadFromJsonString(LJsonString);

  // Assert: A hora da verdade!
  try
    Assert.IsNotNull(LListaRetorno, 'A lista não deveria ser nula após ler o JSON.');
    Assert.AreEqual(1, LListaRetorno.Count, 'A lista deveria conter exatamente 1 personagem.');
    Assert.AreEqual('Tony Stark', LListaRetorno[0].Name, 'O nome do personagem parseado está incorreto.');
    Assert.AreEqual('Universo Cinematográfico Marvel', LListaRetorno[0].Franchise, 'A franquia não foi interpretada corretamente.');
  finally
    LListaRetorno.Free; // Prevenindo memory leak no teste!
  end;
end;

procedure TTestCharacterService.Test_LoadFromJson_StringVazia_DeveRetornarListaVazia;
var
  LListaRetorno: TObjectList<TCharacter>;
begin
  // Arrange
  // Não precisamos de variáveis, vamos passar uma string vazia direto.

  // Act
  LListaRetorno := TCharacterService.LoadFromJsonString('');

  // Assert
  try
    Assert.IsNotNull(LListaRetorno, 'O sistema deve instanciar a lista mesmo se o JSON for vazio (para evitar Access Violation).');
    Assert.AreEqual(0, LListaRetorno.Count, 'A lista deveria estar vazia, pois não enviamos dados.');
  finally
    LListaRetorno.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCharacterService);
end.
