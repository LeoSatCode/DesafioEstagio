unit cCharacter;

interface

uses System.SysUtils, REST.Json.Types;

type
  TCharacter = class

  private
    FId: Integer;

    [JSONNameAttribute('nome')]
    FName:             string;

    [JSONNameAttribute('franquia')]
    FFranchise:        string;

    [JSONNameAttribute('ator_ou_atriz')]
    FActorOrActress:   string;

    [JSONNameAttribute('descricao')]
    FDescription:      string;

    [JSONNameAttribute('tipo_de_midia')]
    FMediaType:        string;

  public
    property Id:              Integer   read FId              write FId;
    property Name:            string    read FName            write FName;
    property Franchise:       string    read FFranchise       write FFranchise;
    property ActorOrActress:  string    read FActorOrActress  write FActorOrActress;
    property Description:     string    read FDescription     write FDescription;
    property MediaType:       string    read FMediaType       write FMediaType;

    procedure Clear;

  end;

implementation

{ TCharacter }

procedure TCharacter.Clear;
begin
  FId              := 0;
  FName            := '';
  FFranchise       := '';
  FActorOrActress  := '';
  FDescription     := '';
  FMediaType       := '';
end;

end.
