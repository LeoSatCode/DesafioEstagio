program DesafioEstagio;

uses
  Vcl.Forms,
  uPrincipal in 'View\uPrincipal.pas' {frmPrincipal},
  uDTMConexao in 'DAO\uDTMConexao.pas' {dtmConnection: TDataModule},
  cUpdateDataBase in 'DAO\Migration\cUpdateDataBase.pas',
  cUpdateTableMSSQL in 'DAO\Migration\cUpdateTableMSSQL.pas',
  cCharacter in 'Model\cCharacter.pas',
  cCharacterService in 'Service\cCharacterService.pas',
  cCharacterManager in 'Service\cCharacterManager.pas',
  uCharRegistration in 'View\uCharRegistration.pas' {frmCharRegistration},
  cGridUtils in 'Utils\cGridUtils.pas',
  cSearchUtils in 'Utils\cSearchUtils.pas',
  cIniFile in 'Utils\cIniFile.pas',
  Vcl.Themes,
  Vcl.Styles,
  cCharacterRepository in 'Service\cCharacterRepository.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
