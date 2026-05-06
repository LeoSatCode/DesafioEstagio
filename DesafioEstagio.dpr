program DesafioEstagio;

uses
  Vcl.Forms,
  uPrincipal in 'View\uPrincipal.pas' {frmPrincipal},
  uDTMConexao in 'DAO\uDTMConexao.pas' {dtmConnection: TDataModule},
  cUpdateDataBase in 'DAO\Migration\cUpdateDataBase.pas',
  cUpdateTableMSSQL in 'DAO\Migration\cUpdateTableMSSQL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdtmConnection, dtmConnection);
  Application.Run;
end.
