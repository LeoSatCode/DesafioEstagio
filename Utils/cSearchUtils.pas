unit cSearchUtils;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client;

type
  TSearchUtils = class
  public
    class procedure ApplyFastFilter(AQry: TFDQuery; const ASearchText: string); static;
  end;

implementation

{ TSearchUtils }

class procedure TSearchUtils.ApplyFastFilter(AQry: TFDQuery; const ASearchText: string);
var
  CleanText: string;
begin
  if not Assigned(AQry) then Exit;

  // Blindagem contra dataset fechado.
  if not AQry.Active then Exit;

  CleanText := Trim(ASearchText);

  if CleanText = '' then
  begin
    AQry.Filtered := False;
    Exit;
  end;

  AQry.Filter := 'Personagem LIKE ' + QuotedStr('%' + CleanText + '%') +
                 ' OR Franquia LIKE ' + QuotedStr('%' + CleanText + '%') +
                 ' OR Ator_Atriz LIKE ' + QuotedStr('%' + CleanText + '%') +
                 ' OR Midia LIKE ' + QuotedStr('%' + CleanText + '%');

  AQry.Filtered := True;
  AQry.First;
end;

end.
