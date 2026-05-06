unit cUpdateDataBase;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client;

type
  TUpdateDataBase = class
  protected
    ConnectionDB: TFDConnection;

  public
    constructor Create(aConnection: TFDConnection);

    procedure ExecuteDirectSQL(aSQL: string);
  end;

  TUpdateDataBaseMSSQL = class
  private
    ConnectionDB: TFDConnection;

  public
    constructor Create(aConnection: TFDConnection);

    procedure UpdateDataBase;
  end;

implementation

uses
  cUpdateTableMSSQL;

{ TUpdateDataBase }

constructor TUpdateDataBase.Create(aConnection: TFDConnection);
begin
  inherited Create;

  ConnectionDB := aConnection;
end;

procedure TUpdateDataBase.ExecuteDirectSQL(aSQL: string);
var
  Qry: TFDQuery;
begin
  Qry := nil;

  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := ConnectionDB;

    Qry.SQL.Clear;
    Qry.SQL.Add(aSQL);

    ConnectionDB.StartTransaction;

    try
      Qry.ExecSQL;

      ConnectionDB.Commit;

    except
      on E: Exception do
      begin
        ConnectionDB.Rollback;

        raise Exception.Create(
          'Erro ao executar SQL:' + sLineBreak +
          E.Message
        );
      end;
    end;

  finally
    if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

{ TUpdateDataBaseMSSQL }

constructor TUpdateDataBaseMSSQL.Create(aConnection: TFDConnection);
begin
  inherited Create;

  ConnectionDB := aConnection;
end;

procedure TUpdateDataBaseMSSQL.UpdateDataBase;
var
  oTable: TUpdateTableMSSQL;
begin
  oTable := nil;

  try
    oTable := TUpdateTableMSSQL.Create(ConnectionDB);

    oTable.Execute;

  finally
    if Assigned(oTable) then
      FreeAndNil(oTable);
  end;
end;

end.
