{
  Copyright 2011 Heiko Adams

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}

unit Data;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, DB, FileUtil, DBCtrls, DateUtils,
  Variants;

type

  { TdmBewerbungen }

  TdmBewerbungen = class(TDataModule)
    conData: TSQLite3Connection;
    dsData: TDatasource;
    dsLog: TDatasource;
    dsDocs: TDatasource;
    qryBewerbungen: TSQLQuery;
    qryCSVExport: TSQLQuery;
    qryLog: TSQLQuery;
    qryDocuments: TSQLQuery;
    traData: TSQLTransaction;
    procedure conDataAfterConnect(Sender: TObject);
    procedure conDataBeforeConnect(Sender: TObject);
    procedure conDataBeforeDisconnect(Sender: TObject);
    procedure dsDataStateChange(Sender: TObject);
    procedure dsDocsStateChange(Sender: TObject);
    procedure dsLogStateChange(Sender: TObject);
    procedure qryBewerbungenAfterOpen(DataSet: TDataSet);
    procedure qryBewerbungenAfterPost(DataSet: TDataSet);
    procedure qryBewerbungenAfterScroll(DataSet: TDataSet);
    procedure qryBewerbungenBeforePost(DataSet: TDataSet);
    procedure qryBewerbungenNewRecord(DataSet: TDataSet);
    procedure qryDocumentsBeforePost(DataSet: TDataSet);
    procedure qryLogAfterScroll(DataSet: TDataSet);
    procedure qryLogBeforePost(DataSet: TDataSet);
  private
    { private declarations }
    FEditMode: boolean;
    FInsertMode: boolean;
    FNewDB: boolean;

    procedure UpdateList(aType: string; aList: TStrings);
    procedure OpenDataSources;
    function GetRecordsCount(DataSet: TDataSet): Integer;
    procedure NewDataBase;
  public
    { public declarations }
    procedure FetchData(aWhere: string);
    procedure FetchExportData(aWhere: string);
    procedure SetIgnoreState(const aID: Integer);
  end;

var
  dmBewerbungen: TdmBewerbungen;

implementation

uses mainwin, bewerbung_strings, Forms, Dialogs;

{$R *.lfm}

{ TdmBewerbungen }

procedure TdmBewerbungen.NewDataBase;
var
  scripts: TSearchRec;
  sSearchPath: string;
  Script: TStringList;
  Files: TStringList;
  nCount: Integer;
begin
  Files := TStringList.Create;
  sSearchPath := ExtractFilePath(Application.ExeName);
  sSearchPath := IncludeTrailingPathDelimiter(sSearchPath) + 'SQL' + PathDelim;

  // Automatisch freien Speicher wieder freigeben
  conData.ExecuteDirect('PRAGMA auto_vacuum = 1;');

  // Sicherstellen, das SQLs in der richtigen Reihenfolge ausgeführt werden ..
  if FindFirst(sSearchPath + '*.sql', faAnyFile, scripts) = 0 then
  begin
    repeat
      Files.Add(scripts.Name);
    until FindNext(scripts) <> 0
  end;

  FindClose(scripts);
  Files.Sort;
  // ..

  // Datenbankstruktur erstellen
  Script := TStringList.Create;

  for nCount := 0 to Files.Count -1 do
  begin
    Script.LoadFromFile(sSearchPath + Files.Strings[nCount]);
    conData.ExecuteDirect(Script.Text);

    traData.Commit;
  end;

  Script.Free;
  Files.Free;
end;

procedure TdmBewerbungen.OpenDataSources;
begin
  if not qryBewerbungen.Active then
    qryBewerbungen.Open;

  if not qryLog.Active then
    qryLog.Open;

  if not qryDocuments.Active then
    qryDocuments.Open;
end;

procedure TdmBewerbungen.SetIgnoreState(const aID: Integer);
var
  nID: Integer;
begin
  nID := qryBewerbungen.FieldByName('ID').AsInteger;

  with TSQLQuery.Create(nil) do
  begin
    DataBase := conData;
    Transaction := traData;

    with SQL do
    begin
      Clear;
      Add('UPDATE BEWERBUNGEN SET IGNORIERT = NOT IGNORIERT WHERE ID = :pID');

      Params.ParamValues['pID'] := aID;
    end;

    ExecSQL;
    Free;
  end;

  traData.Commit;
  OpenDataSources;

  qryBewerbungen.Locate('ID', nID, []);
end;

procedure TdmBewerbungen.FetchData(aWhere: string);
begin
  with qryBewerbungen do
  begin
    Close;

    with SQL do
    begin
      Clear;

      if (aWhere = EmptyStr) then
         Add('SELECT * FROM BEWERBUNGEN ORDER BY Datum DESC, NAME')
      else
         Add(Format('SELECT * FROM BEWERBUNGEN WHERE %s ORDER BY Datum DESC, NAME', [aWhere]));
    end;

    Open;
  end;
end;

procedure TdmBewerbungen.FetchExportData(aWhere: string);
begin
  with qryCSVExport do
  begin
    Close;

    with SQL do
    begin
      Clear;

      Add('SELECT DATUM, WVL, NAME, MAIL, JOBTITEL, REFNR, (RESULT = 1) AS ZUSAGE, (RESULT = 2) AS ABSAGE');
      Add('FROM BEWERBUNGEN');

      if not (aWhere = EmptyStr) then
        Add(Format('%s', [aWhere]));

      Add('ORDER BY DATUM DESC, NAME ');
    end;

    Open;
  end;
end;

function TdmBewerbungen.GetRecordsCount(DataSet: TDataSet): Integer;
var
  sWhere: string;
  nWherePos: Integer;
begin
  with TSQLQuery.Create(nil) do
  begin
    DataBase := conData;
    Transaction := traData;

    SQL.Add('SELECT COUNT(*) ANZAHL FROM BEWERBUNGEN');
    nWherePos := Pos('WHERE', qryBewerbungen.SQL.Text);

    if (nWherePos > 0) then
    begin
      sWhere := Copy(qryBewerbungen.SQL.Text,
              nWherePos,
              Length(qryBewerbungen.SQL.Text) - nWherePos);
      SQL.Add(sWhere);
    end;

    Open;
    Result := FieldByName('ANZAHL').AsInteger;
    Close;
    Free;
  end;
end;

procedure TdmBewerbungen.conDataAfterConnect(Sender: TObject);
begin
  if FNewDB then
    NewDatabase;

  // Referenzielle Integritätsprüfung aktivieren
  TSQLite3Connection(Sender).ExecuteDirect('PRAGMA foreign_keys = ON;');

  OpenDataSources;
end;

procedure TdmBewerbungen.conDataBeforeConnect(Sender: TObject);
begin
  // Prüfen, ob eine neue Datenbank erstellt werden muss
  FNewDB:=not FileExists(TSQLite3Connection(Sender).DatabaseName);
end;

procedure TdmBewerbungen.conDataBeforeDisconnect(Sender: TObject);
begin
  qryBewerbungen.Close;
  qryLog.Close;
  qryDocuments.Close;
end;

procedure TdmBewerbungen.UpdateList(aType: string; aList: TStrings);
var
  sSQL: string;
begin
  if (UpperCase(aType) = rsCOMPANIES) then
    sSQL := 'SELECT VALUE FROM V_COMPANIES'
  else if (UpperCase(aType) = rsMAILS) then
    sSQL := 'SELECT VALUE FROM V_MAILS'
  else if (UpperCase(aType) = rsJOBS) then
    sSQL := 'SELECT VALUE FROM V_JOBS'
  else if (UpperCase(aType) = rsACTION) then
    sSQL := 'SELECT DISTINCT TYP VALUE FROM LOG'
  else if (UpperCase(aType) = rsRECEIPENTS) then
    sSQL := 'SELECT VALUE FROM V_RECEIPENTS'
  else
    sSQL := EmptyStr;

  if (sSQL <> EmptyStr) then
  begin
    aList.Clear;

    with TSQLQuery.Create(nil) do
    begin
      DataBase := conData;
      Transaction := traData;

      with SQL do
      begin
        Clear;
        Add(sSQL);
      end;

      Open;
      First;

      while not EOF do
      begin
        aList.Add(FieldByName('VALUE').AsString);
        Next;
      end;

      Close;
      Free;
    end;
  end;
end;

procedure TdmBewerbungen.dsDataStateChange(Sender: TObject);
var
   ReadOnlyButtons: TDBNavButtonSet;
   WriteModeButtons: TDBNavButtonSet;
begin
  FEditMode := ((Sender as TDatasource).State in dsWriteModes);
  FInsertMode := ((Sender as TDatasource).State = dsInsert);
  WriteModeButtons:= [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit,
      nbPost, nbCancel, nbRefresh];
  ReadOnlyButtons := [nbFirst, nbPrior, nbNext, nbLast, nbRefresh];

  frmMain.tsBewerbungData.Enabled := FEditMode;

  if FEditMode then
  begin
    if (frmMain.PageControl1.ActivePageIndex = 0) then
      frmMain.PageControl1.ActivePageIndex := 1;

    frmMain.navActions.VisibleButtons := WriteModeButtons;
    frmMain.navDocs.VisibleButtons:=WriteModeButtons;
  end
  else
  begin
    frmMain.navActions.VisibleButtons := ReadOnlyButtons;
    frmMain.navDocs.VisibleButtons:=ReadOnlyButtons;
  end;
end;

procedure TdmBewerbungen.dsDocsStateChange(Sender: TObject);
var
  bEditMode: boolean;
begin
  bEditMode := ((Sender as TDatasource).State in dsEditModes);

  with frmMain do
  begin
    cbFileType.Enabled := bEditMode;
    edtFile.Enabled := bEditMode;
    btnBrowse.Enabled:= bEditMode;
  end;
end;

procedure TdmBewerbungen.dsLogStateChange(Sender: TObject);
var
  bEditMode: boolean;
begin
  bEditMode := ((Sender as TDatasource).State in dsEditModes);

  with frmMain do
  begin
    edtLogDatum.Enabled := bEditMode;
    cbbLogTyp.Enabled := bEditMode;
    mmoText.Enabled := bEditMode;
  end;
end;

procedure TdmBewerbungen.qryBewerbungenAfterOpen(DataSet: TDataSet);
begin
  DataSet.First;
  frmMain.sbInfo.SimpleText := Format(rsDDatensTze, [GetRecordsCount(DataSet)]);

  UpdateList(rsCOMPANIES, frmMain.cbbEmpfName.Items);
  UpdateList(rsMAILS, frmMain.cbbEmpfMail.Items);
  UpdateList(rsJOBS, frmMain.cbbJobTitel.Items);
  UpdateList(rsACTION, frmMain.cbbLogTyp.Items);
  UpdateList(rsRECEIPENTS, frmMain.cbbAnspr.Items);
end;

procedure TdmBewerbungen.qryBewerbungenAfterPost(DataSet: TDataSet);
var
  nID: Integer;
begin
  try
    if Assigned(DataSet.Fields.FindField('ID')) then
      nID := DataSet.FieldByName('ID').AsInteger
    else
      nID := -1;

    TSQLQuery(DataSet).ApplyUpdates;

    if traData.Active then
    begin
      traData.Commit;
      OpenDataSources;

      if (nID > 0) then
        DataSet.Locate('ID', nID, []);
    end;
  except
    traData.Rollback;
  end;

  UpdateList(rsCOMPANIES, frmMain.cbbEmpfName.Items);
  UpdateList(rsMAILS, frmMain.cbbEmpfMail.Items);
  UpdateList(rsJOBS, frmMain.cbbJobTitel.Items);
  UpdateList(rsACTION, frmMain.cbbLogTyp.Items);
  UpdateList(rsRECEIPENTS, frmMain.cbbAnspr.Items);
  frmMain.sbInfo.SimpleText := Format(rsDDatensTze, [GetRecordsCount(DataSet)]);
end;

procedure TdmBewerbungen.qryBewerbungenAfterScroll(DataSet: TDataSet);
var
  nID: integer;
begin
  with qryBewerbungen do
  begin
    if VarIsNull(FieldByName('ID').AsVariant) then
      Exit;

    frmMain.edtDatum.Date := FieldByName('DATUM').AsDateTime;
    frmMain.edtWVL.Date := FieldByName('WVL').AsDateTime;
    nID := FieldByName('ID').AsInteger;
  end;

  with qryLog do
  begin
    Close;
    Params.ParamValues['ID'] := nID;
    Open;
  end;

  with qryDocuments do
  begin
    Close;
    Params.ParamValues['ID'] := nID;
    Open;
  end;
end;

procedure TdmBewerbungen.qryBewerbungenBeforePost(DataSet: TDataSet);
begin
  with qryBewerbungen do
  begin
    FieldByName('DATUM').AsDateTime := frmMain.edtDatum.Date;
    FieldByName('WVL').AsDateTime := frmMain.edtWVL.Date;
  end;
end;

procedure TdmBewerbungen.qryBewerbungenNewRecord(DataSet: TDataSet);
var
  nDefaults: array[0..3] of integer;
  nDays: Word;
begin
  nDays := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'WVL', 14);

  if FileExists(frmMain.ConfigFile.FileName) then
  begin
    nDefaults[0] := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'TYP', 1);
    nDefaults[1] := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'FEEDBACK', 0);
    nDefaults[2] := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'RESULT', 0);
    nDefaults[3] := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'MEDIUM', 0);
  end
  else
  begin
    nDefaults[0] := 1;
    nDefaults[1] := 0;
    nDefaults[2] := 0;
    nDefaults[3] := 0;
  end;

  with DataSet do
  begin
    FieldByName('TYP').AsInteger := nDefaults[0];
    FieldByName('FEEDBACK').AsInteger := nDefaults[1];
    FieldByName('RESULT').AsInteger := nDefaults[2];
    FieldByName('MEDIUM').AsInteger := nDefaults[3];
  end;

  with frmMain do
  begin
    edtDatum.Date := Date;
    edtWVL.Date := IncDay(Date, nDays);
  end;
end;

procedure TdmBewerbungen.qryDocumentsBeforePost(DataSet: TDataSet);
begin
  DataSet.FieldByName('BEWERBUNG').AsInteger :=
    qryBewerbungen.FieldByName('ID').AsInteger;
end;

procedure TdmBewerbungen.qryLogAfterScroll(DataSet: TDataSet);
begin
  with frmMain do
  begin
    edtLogDatum.Date := DataSet.FieldByName('DATUM').AsDateTime;
  end;
end;

procedure TdmBewerbungen.qryLogBeforePost(DataSet: TDataSet);
begin
  DataSet.FieldByName('BEWERBUNG').AsInteger :=
    qryBewerbungen.FieldByName('ID').AsInteger;
  DataSet.FieldByName('DATUM').AsDateTime := frmMain.edtLogDatum.Date;
end;

end.

