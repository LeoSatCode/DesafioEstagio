unit cGridUtils;

interface

uses
  System.Classes, Vcl.Controls, Vcl.ExtCtrls, Vcl.Dialogs, Vcl.Forms,
  Vcl.Buttons, Vcl.Grids, System.IniFiles, Data.DB, System.SysUtils,
  Winapi.Windows, Vcl.Graphics, Vcl.DBGrids, FireDAC.Comp.Client;

type
  TGrid = class
  public
    class function GetColumnByFieldName(Grid: TDBGrid; const AFieldName: string): TColumn; static;
    class procedure SaveGrid(Grid: TDBGrid; const NomeINI, NomeUsuario, NomeForm: string); static;
    class procedure LoadGrid(Grid: TDBGrid; const NomeINI, NomeUsuario, NomeForm: string); static;
    class procedure ZebrarGrid(Grid: TDBGrid; State: TGridDrawState; Column: TColumn; Rect: TRect; DataCol: Integer);
  end;

implementation

{ TGrid }

class function TGrid.GetColumnByFieldName(Grid: TDBGrid; const AFieldName: string): TColumn;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Grid.Columns.Count - 1 do
  begin
    if SameText(Grid.Columns[I].FieldName, AFieldName) then
      Exit(Grid.Columns[I]);
  end;
end;

class procedure TGrid.SaveGrid(Grid: TDBGrid; const NomeINI, NomeUsuario, NomeForm: string);
var
  ArquivoINI: TIniFile;
  I: Integer;
  Secao: string;
begin
  ArquivoINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + NomeINI);
  try
    Secao := NomeUsuario + '_' + NomeForm;

    for I := 0 to Grid.Columns.Count - 1 do
    begin
      ArquivoINI.WriteInteger(Secao, Grid.Columns[I].FieldName + '.Width', Grid.Columns[I].Width);
      ArquivoINI.WriteInteger(Secao, Grid.Columns[I].FieldName + '.Index', Grid.Columns[I].Index);
    end;
  finally
    ArquivoINI.Free;
  end;
end;

class procedure TGrid.LoadGrid(Grid: TDBGrid; const NomeINI, NomeUsuario, NomeForm: string);
var
  ArquivoINI: TIniFile;
  I, NewIndex: Integer;
  Col: TColumn;
  Secao: string;
begin
  ArquivoINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + NomeINI);
  try
    Secao := NomeUsuario + '_' + NomeForm;
    Grid.Columns.BeginUpdate;
    try
      for I := 0 to Grid.Columns.Count - 1 do
      begin
        Col := Grid.Columns[I];
        NewIndex := ArquivoINI.ReadInteger(Secao, Col.FieldName + '.Index', Col.Index);
        Col.Index := NewIndex;
      end;

      for I := 0 to Grid.Columns.Count - 1 do
      begin
        Col := Grid.Columns[I];
        Col.Width := ArquivoINI.ReadInteger(Secao, Col.FieldName + '.Width', Col.Width);
      end;
    finally
      Grid.Columns.EndUpdate;
    end;
  finally
    ArquivoINI.Free;
  end;
end;

class procedure TGrid.ZebrarGrid(Grid: TDBGrid; State: TGridDrawState; Column: TColumn; Rect: TRect; DataCol: Integer);
var Linha, I: Integer;
begin
  for I := 0 to Grid.Columns.Count - 1 do
    Grid.Columns[I].Title.Alignment := taCenter;  //Centraliza o título

  // Pinta o cabeçalho
  if (gdFixed in State) then
  begin
    Grid.Canvas.Brush.Color := clGray;
    Grid.Canvas.FillRect(Rect);
    Exit;
  end;

  // Lógica para Zebrar as linhas
  if Assigned(Grid.DataSource) and Assigned(Grid.DataSource.DataSet) then
  begin
    Linha := Grid.DataSource.DataSet.RecNo;

    if not (gdSelected in State) then
    begin
      if (Linha mod 2) = 0 then
        Grid.Canvas.Brush.Color := clWebLightgrey // Linha Par
      else
        Grid.Canvas.Brush.Color := clWhite;       // Linha Ímpar
    end
    else
    begin
      // Cor da linha selecionada
      Grid.Canvas.Brush.Color := $00FFCC99;
      Grid.Canvas.Font.Color := clHighlightText;
    end;
  end;

  Grid.Canvas.FillRect(Rect);

  // Desenha o texto padrão da célula por cima do fundo colorido
  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

end.
