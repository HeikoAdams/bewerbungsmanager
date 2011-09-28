{
This file is part of Bewerbungsmanager.

Bewerbungsmanager is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

Bewerbungsmanager is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Bewerbungsmanager.  If not, see <http://www.gnu.org/licenses/>.
}

unit Data;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, DB, FileUtil, DBCtrls, DateUtils;

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
    procedure conDataBeforeDisconnect(Sender: TObject);
    procedure dsDataStateChange(Sender: TObject);
    procedure dsDocsStateChange(Sender: TObject);
    procedure dsLogStateChange(Sender: TObject);
    procedure qryBewerbungenAfterInsert(DataSet: TDataSet);
    procedure qryBewerbungenAfterOpen(DataSet: TDataSet);
    procedure qryBewerbungenAfterPost(DataSet: TDataSet);
    procedure qryBewerbungenAfterScroll(DataSet: TDataSet);
    procedure qryBewerbungenBeforePost(DataSet: TDataSet);
    procedure qryDocumentsBeforePost(DataSet: TDataSet);
    procedure qryLogAfterScroll(DataSet: TDataSet);
    procedure qryLogBeforePost(DataSet: TDataSet);
  private
    { private declarations }
    FEditMode: boolean;
    FInsertMode: boolean;

    procedure UpdateList(aType: string; aList: TStrings);
    function GetRecordsCount(DataSet: TDataSet): Integer;
  public
    { public declarations }
    procedure FetchData(aWhere: string);
    procedure FetchExportData(aWhere: string);
  end;

var
  dmBewerbungen: TdmBewerbungen;

implementation

uses mainwin, bewerbung_strings;

{$R *.lfm}

{ TdmBewerbungen }

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
  qryBewerbungen.Open;
  qryLog.Open;
  qryDocuments.Open;
end;

procedure TdmBewerbungen.conDataBeforeDisconnect(Sender: TObject);
begin
  conData.Transaction.Commit;
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
    if (frmMain.PageControl1.ActivePageIndex <> 1) then
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
    edtLogTyp.Enabled := bEditMode;
    mmoText.Enabled := bEditMode;
  end;
end;

procedure TdmBewerbungen.qryBewerbungenAfterInsert(DataSet: TDataSet);
var
  nDefaults: array[0..3] of integer;
begin
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
end;

procedure TdmBewerbungen.qryBewerbungenAfterOpen(DataSet: TDataSet);
begin
  DataSet.First;
  frmMain.sbInfo.SimpleText := Format(rsDDatensTze, [GetRecordsCount(DataSet)]);

  UpdateList(rsCOMPANIES, frmMain.cbbEmpfName.Items);
  UpdateList(rsMAILS, frmMain.cbbEmpfMail.Items);
  UpdateList(rsJOBS, frmMain.cbbJobTitel.Items);
end;

procedure TdmBewerbungen.qryBewerbungenAfterPost(DataSet: TDataSet);
var
  Bookmark: TBookmark;
begin
  try
    Bookmark := DataSet.GetBookmark;
    TSQLQuery(DataSet).ApplyUpdates;

    if traData.Active then
    begin
      traData.CommitRetaining;
      DataSet.Refresh;

      if DataSet.BookmarkValid(Bookmark) then
        DataSet.GotoBookmark(Bookmark)
      else
        DataSet.First;

      DataSet.FreeBookmark(Bookmark);
    end;
  except
    traData.Rollback;
  end;

  if not conData.Connected then
     conData.Open;

  UpdateList(rsCOMPANIES, frmMain.cbbEmpfName.Items);
  UpdateList(rsMAILS, frmMain.cbbEmpfMail.Items);
  UpdateList(rsJOBS, frmMain.cbbJobTitel.Items);
  frmMain.sbInfo.SimpleText := Format(rsDDatensTze, [GetRecordsCount(DataSet)]);
end;

procedure TdmBewerbungen.qryBewerbungenAfterScroll(DataSet: TDataSet);
var
  nID: integer;
begin
  with qryBewerbungen do
  begin
    frmMain.edtDatum.Date := FieldByName('DATUM').AsDateTime;
    frmMain.edtWVL.Date := FieldByName('WVL').AsDateTime;
    nID := FieldByName('ID').AsInteger;
  end;

  if (nID <= 0) then
    Exit;

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
var
  nDays: Word;
begin
  nDays := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'WVL', 14);

  with qryBewerbungen do
  begin
    FieldByName('DATUM').AsDateTime := frmMain.edtDatum.Date;

    if (State = dsInsert) then
      FieldByName('WVL').AsDateTime := IncDay(frmMain.edtDatum.Date, nDays)
    else
    begin
      if (frmMain.edtWVL.Date <> 0) then
        FieldByName('WVL').AsDateTime := frmMain.edtWVL.Date
      else
        FieldByName('WVL').AsDateTime := IncDay(frmMain.edtWVL.Date, nDays);
    end;
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

