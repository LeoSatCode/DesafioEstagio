unit cGridUtils;

interface

uses
  System.Classes, Vcl.Controls, Vcl.ExtCtrls, Vcl.Dialogs, Vcl.Forms,
  Vcl.Buttons, Vcl.Grids, System.IniFiles, Data.DB, System.SysUtils,
  Winapi.Windows, Vcl.Graphics, Vcl.DBGrids, FireDAC.Comp.Client;

type
  TGrid = class
  public
    class function  GetColumnByFieldName(Grid: TDBGrid; const AFieldName: string): TColumn; static;
    class procedure SaveGrid(Grid: TDBGrid; const NomeINI, UserName, NomeForm: string); static;
    class procedure LoadGrid(Grid: TDBGrid; const NomeINI, UserName, NomeForm: string); static;
    class procedure OrderGrid(Column: TColumn); static;
    class procedure ZebrarGrid(Grid: TDBGrid; State: TGridDrawState; Column: TColumn; Rect: TRect; DataCol: Integer);
  end;

implementation

{ TGrid }

class function TGrid.GetColumnByFieldName(Grid: TDBGrid; const AFieldName: string): TColumn;
var
  I: Integer;
begin
  Result := nil;
  for I  := 0 to Grid.Columns.Count - 1 do
  begin
    if SameText(Grid.Columns[I].FieldName, AFieldName) then
      Exit(Grid.Columns[I]);
  end;
end;

class procedure TGrid.SaveGrid(Grid: TDBGrid; const NomeINI, UserName, NomeForm: string);
var
  INIFile: TIniFile;
  I: Integer;
  Section: string;
begin
  INIFile   := TIniFile.Create(ExtractFilePath(Application.ExeName) + NomeINI);
  try
    Section := UserName + '_' + NomeForm;

    for I := 0 to Grid.Columns.Count - 1 do
    begin
      INIFile.WriteInteger(Section, Grid.Columns[I].FieldName + '.Width', Grid.Columns[I].Width);
      INIFile.WriteInteger(Section, Grid.Columns[I].FieldName + '.Index', Grid.Columns[I].Index);
    end;
  finally
    INIFile.Free;
  end;
end;

class procedure TGrid.LoadGrid(Grid: TDBGrid; const NomeINI, UserName, NomeForm: string);
var
  INIFile: TIniFile;
  I, NewIndex: Integer;
  Col: TColumn;
  Section: string;
begin
  INIFile   := TIniFile.Create(ExtractFilePath(Application.ExeName) + NomeINI);
  try
    Section := UserName + '_' + NomeForm;
    Grid.Columns.BeginUpdate;
    try
      for I := 0 to Grid.Columns.Count - 1 do
      begin
        Col := Grid.Columns[I];
        NewIndex  := INIFile.ReadInteger(Section, Col.FieldName + '.Index', Col.Index);
        Col.Index := NewIndex;
      end;

      for I := 0 to Grid.Columns.Count - 1 do
      begin
        Col       := Grid.Columns[I];
        Col.Width := INIFile.ReadInteger(Section, Col.FieldName + '.Width', Col.Width);
      end;
    finally
      Grid.Columns.EndUpdate;
    end;
  finally
    INIFile.Free;
  end;
end;

class procedure TGrid.OrderGrid(Column: TColumn);
var
  Query: TFDQuery;
begin
  if not (Column.Grid.DataSource.DataSet is TFDQuery) then Exit;

  Query := TFDQuery(Column.Grid.DataSource.DataSet);

  // Blindagem contra dataset fechado
  if not Query.Active then Exit;

  if Query.IndexFieldNames = Column.FieldName then
    Query.IndexFieldNames := Column.FieldName + ':D'
  else
    Query.IndexFieldNames := Column.FieldName;
end;

class procedure TGrid.ZebrarGrid(Grid: TDBGrid; State: TGridDrawState; Column: TColumn; Rect: TRect; DataCol: Integer);
var Linha, I: Integer;
begin
  for I := 0 to Grid.Columns.Count - 1 do
    Grid.Columns[I].Title.Alignment := taCenter;

  if (gdFixed in State) then
  begin
    Grid.Canvas.Brush.Color := clGray;
    Grid.Canvas.FillRect(Rect);
    Exit;
  end;

  if Assigned(Grid.DataSource) and Assigned(Grid.DataSource.DataSet) then
  begin
    Linha := Grid.DataSource.DataSet.RecNo;

    if not (gdSelected in State) then
    begin
      if (Linha mod 2) = 0 then
        Grid.Canvas.Brush.Color := clWebLightgrey
      else
        Grid.Canvas.Brush.Color := clWhite;
    end
    else
    begin
      Grid.Canvas.Brush.Color   := $00FFCC99;
      Grid.Canvas.Font.Color    := clHighlightText;
    end;
  end;

  Grid.Canvas.FillRect(Rect);
  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

end.
