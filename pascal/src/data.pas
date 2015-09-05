{ Bewerbungsmanager - a small tool for managing applications

  Copyright (C) 2011 Heiko Adams heiko.adams@gmail.com

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
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
    dsCompanies: TDataSource;
    dsCompany: TDataSource;
    dsData: TDatasource;
    dsFeedback: TDatasource;
    dsLog: TDatasource;
    dsDocs: TDatasource;
    dsMedium: TDatasource;
    dsResult: TDatasource;
    dsTyp: TDatasource;
    qryBewerbungenANSPRECHPARTNER: TStringField;
    qryBewerbungenBEFRISTET: TBooleanField;
    qryBewerbungenBISDATUM: TDateTimeField;
    qryBewerbungenCOMPANY: TLongintField;
    qryBewerbungenDATUM: TDateTimeField;
    qryBewerbungenFEEDBACK: TLongintField;
    qryBewerbungenID: TLongintField;
    qryBewerbungenIGNORIERT: TBooleanField;
    qryBewerbungenJOBTITEL: TStringField;
    qryBewerbungenMAIL: TStringField;
    qryBewerbungenMEDIUM: TLongintField;
    qryBewerbungenNOTES: TStringField;
    qryBewerbungenREFNR: TStringField;
    qryBewerbungenRESULT: TLongintField;
    qryBewerbungenTYP: TLongintField;
    qryBewerbungenUID: TLongintField;
    qryBewerbungenVERMITTLER: TBooleanField;
    qryBewerbungenWVL: TDateTimeField;
    qryCompanies: TSQLQuery;
    qryCSVExport: TSQLQuery;
    qryLog: TSQLQuery;
    qryDocuments: TSQLQuery;
    scUpdate: TSQLScript;
    qryBenutzer: TSQLQuery;
    qryBewerbungen: TSQLQuery;
    StringField1: TStringField;
    traData: TSQLTransaction;
    procedure conDataAfterConnect(Sender: TObject);
    procedure conDataBeforeConnect(Sender: TObject);
    procedure conDataBeforeDisconnect(Sender: TObject);
    procedure dsCompaniesStateChange(Sender: TObject);
    procedure dsDataStateChange(Sender: TObject);
    procedure dsDocsStateChange(Sender: TObject);
    procedure dsLogStateChange(Sender: TObject);
    procedure qryBewerbungenAfterOpen(DataSet: TDataSet);
    procedure qryBewerbungenAfterPost(DataSet: TDataSet);
    procedure qryBewerbungenAfterScroll(DataSet: TDataSet);
    procedure qryBewerbungenBeforeInsert(DataSet: TDataSet);
    procedure qryBewerbungenBeforeOpen(DataSet: TDataSet);
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
    procedure SetDBVersion(const aVersion: Integer = 0);
    function GetDBVersion: Integer;
    procedure InstallUpdates(const aVersion: Integer);
    procedure UpdateDB;
  public
    { public declarations }
    procedure FetchData(aWhere: string);
    procedure FetchExportData(aWhere: string);
    procedure SetIgnoreState(const aID: Integer);
    procedure UpdateWVL(aID, aDays: Integer);
    procedure WriteToLog(aID: Integer; aAction, aText: string);
  end;

var
  dmBewerbungen: TdmBewerbungen;

implementation

uses mainwin, bewerbung_strings, Forms, Dialogs, login, LCLType;

{$R *.lfm}

{ TdmBewerbungen }

procedure TdmBewerbungen.SetDBVersion(const aVersion: Integer = 0);
begin
  with TSQLQuery.Create(self) do
  begin
    DataBase := conData;
    Transaction := traData;

    with SQL do
    begin
      Add('INSERT INTO DBVERSION(DATUM, VERSION)');
      Add('SELECT :pDatum, :pVersion')
    end;

    with Params do
    begin
      Clear;
      ParseSQL(SQL.Text, True);

      ParamValues['pDatum'] := Date;

      if (aVersion = 0) then
        ParamValues['pVersion'] := nVersion
      else
        ParamValues['pVersion'] := aVersion;
    end;

    ExecSQL;
    Free;
  end;

  traData.Commit;
end;

function TdmBewerbungen.GetDBVersion: Integer;
begin
  with TSQLQuery.Create(self) do
  begin
    DataBase := conData;
    Transaction := traData;

    with SQL do
      Add('SELECT MAX(VERSION) VERSION FROM DBVERSION');

    Open;
    Result := FieldByName('VERSION').AsInteger;
    Close;
    Free;
  end;
end;

procedure TdmBewerbungen.InstallUpdates(const aVersion: Integer);
var
  scripts: TSearchRec;
  sSearchPath: string;
  Files: TStringList;
  nCount: Integer;
begin
  Files := TStringList.Create;
  sSearchPath := ExtractFilePath(Application.ExeName);
  sSearchPath := IncludeTrailingPathDelimiter(sSearchPath) + 'SQL' + PathDelim +
    IntToStr(aVersion) + PathDelim;

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
  for nCount := 0 to Files.Count -1 do
  begin
    scUpdate.Script.LoadFromFile(sSearchPath + Files.Strings[nCount]);
    scUpdate.ExecuteScript;

    traData.Commit;
  end;

  // Wenn SQL-Skripte ausgeführt wurden, neue Datenbankversion setzen
  if (Files.Count > 0) then
    SetDBVersion(aVersion);

  Files.Free;
end;

procedure TdmBewerbungen.UpdateDB;
var
  nVersionCur: Integer;
begin
  // aktuelle Datenbankversion abfragen
  nVersionCur := GetDBVersion;

  // Datenbank aktualisieren
  if (nVersionCur < nVersion) then
  begin
    repeat
      InstallUpdates(nVersionCur);
      Inc(nVersionCur);
    until (nVersionCur > nVersion);
  end;
end;

procedure TdmBewerbungen.NewDataBase;
begin
  // Automatisch freien Speicher wieder freigeben
  conData.ExecuteDirect('PRAGMA auto_vacuum = 1;');

  // SQLs für die Datenbankstruktur ausführen
  InstallUpdates(nInitVer);
end;

procedure TdmBewerbungen.OpenDataSources;
begin
  if not qryBenutzer.Active then
  begin
    qryBenutzer.Open;
    if (frmMain.UserID = 0) then
    begin
      Application.CreateForm(TfrmLogin, frmLogin);
      UpdateList(rsUSER, frmLogin.cbUserName.Items);
      frmLogin.ShowModal;
      FreeAndNil(frmLogin);
    end;
  end;

  if not qryCompanies.Active then
    qryCompanies.Open;

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
      Add('UPDATE BEWERBUNGEN SET IGNORIERT = NOT IGNORIERT WHERE (ID = :pID)');

      Params.ParamValues['pID'] := aID;
    end;

    ExecSQL;
    Free;
    WriteToLog(aID, rsIgnored, rsIgnoredTxt);
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
      begin
         Add('SELECT BEWERBUNGEN.ID, DATUM, MAIL, JOBTITEL, REFNR, TYP, ');
         Add('FEEDBACK, RESULT, WVL, BEWERBUNGEN.NOTES, BEWERBUNGEN.VERMITTLER, ');
         Add('MEDIUM, ANSPRECHPARTNER, BEFRISTET, IGNORIERT, UID, BISDATUM, COMPANY ');
         Add('FROM BEWERBUNGEN ');
         Add('WHERE (UID = :pUserID) ORDER BY Datum DESC')
      end
      else
      begin
         Add('SELECT BEWERBUNGEN.ID, DATUM, MAIL, JOBTITEL, REFNR, TYP, ');
         Add('FEEDBACK, RESULT, WVL, BEWERBUNGEN.NOTES, BEWERBUNGEN.VERMITTLER, ');
         Add('MEDIUM, ANSPRECHPARTNER, BEFRISTET, IGNORIERT, UID, BISDATUM, COMPANY ');
         Add('FROM BEWERBUNGEN ');
         Add(Format('WHERE (UID = :pUserID) AND (%s) ORDER BY Datum DESC', [aWhere]));
      end;
    end;
    Params.ParamByName('pUserID').AsInteger:= frmMain.UserID;
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

      Add('SELECT DATUM, WVL, BISDATUM, COMPANIES.NAME, MAIL, JOBTITEL, REFNR, (RESULT = 1) AS ZUSAGE, (RESULT = 2) AS ABSAGE, (RESULT = 4) AS KEINEANTWORT');
      Add('FROM BEWERBUNGEN JOIN COMPANIES ON BEWERBUNGEN.COMPANY = COMPANIES.ID');

      if not (aWhere = EmptyStr) then
        Add(Format('%s', [aWhere]));

      Add('ORDER BY DATUM DESC, NAME ');
    end;
    Params.ParamByName('pUserID').AsInteger:= frmMain.UserID;

    Open;
  end;
end;

function TdmBewerbungen.GetRecordsCount(DataSet: TDataSet): Integer;
var
  sWhere: string;
  nWherePos: Integer;
  nOrderPos: Integer;
begin
  with TSQLQuery.Create(nil) do
  begin
    DataBase := conData;
    Transaction := traData;

    SQL.Add('SELECT COUNT(*) ANZAHL FROM BEWERBUNGEN');
    nWherePos := Pos('WHERE', qryBewerbungen.SQL.Text);
    nOrderPos := Pos('ORDER BY', qryBewerbungen.SQL.Text);
    if (nOrderPos = 0) then
      nOrderPos := Length(qryBewerbungen.SQL.Text);

    if (nWherePos > 0) then
    begin
      sWhere := Copy(qryBewerbungen.SQL.Text,
              nWherePos,
              nOrderPos - nWherePos);
      SQL.Add(sWhere);
    end;

    Params.ParamByName('pUserID').AsInteger:= frmMain.UserID;
    Open;
    Result := FieldByName('ANZAHL').AsInteger;
    Close;
    Free;
  end;
end;

procedure TdmBewerbungen.conDataAfterConnect(Sender: TObject);
begin
  // Wenn eine neue Datenbank erstellt wurde, die benötigte Struktur anlegen
  if FNewDB then
    NewDatabase;

  // Prüfen, ob Datenbank- und Programmversion identisch sind
  if (GetDBVersion < nVersion) then
    UpdateDB;

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
var
  sMessage: string;
begin
  qryBewerbungen.Close;
  qryLog.Close;
  qryDocuments.Close;

  with TSQLQuery.Create(nil) do
  begin
    DataBase := conData;
    Transaction := traData;

    with SQL do
    begin
      Clear;
      Add(rsCleanupSQL);
    end;

    ExecSQL;
    Close;
    Free;
    traData.Commit;
  end;

  with TSQLQuery.Create(nil) do
  begin
    DataBase := conData;
    Transaction := traData;

    with SQL do
    begin
      Clear;
      Add(rsDeactiveComp);
    end;

    ExecSQL;
    Close;
    Free;
    traData.Commit;
  end;

  if (frmMain.ConfigFile.ReadBool('GENERAL', 'MODIFY-APPLICATION-RESULT', True)) then
  begin
    with TSQLQuery.Create(nil) do
    begin
      DataBase := conData;
      Transaction := traData;

      with SQL do
      begin
        Clear;
        Add(rsPurgeSQL);
      end;

      Params.ParamByName('pUserID').AsInteger:= frmMain.UserID;

      ExecSQL;
      if (RowsAffected > 0) then
      begin
        sMessage:=Format(rsOldDataPurged, [RowsAffected]);
        Application.MessageBox(PChar(sMessage), PChar(rsPurging), MB_ICONASTERISK or MB_OK);
      end;
      Close;
      Free;
    end;
    traData.Commit;
  end;

end;

procedure TdmBewerbungen.dsCompaniesStateChange(Sender: TObject);
begin
  FEditMode := ((Sender as TDatasource).State in dsWriteModes);
  frmMain.pnlCompanyData.Enabled := FEditMode;
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
  else if (UpperCase(aType) = rsUSER) then
    sSQL := 'SELECT NAME AS VALUE FROM BENUTZER'
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

procedure TdmBewerbungen.UpdateWVL(aID, aDays: Integer);
var
  sSQL: string;
begin
  sSQL := Format('UPDATE Bewerbungen SET WVL = DATE(WVL, ''+%d days'')', [aDays]);

  if (frmMain.ConfigFile.ReadBool('GENERAL', 'MODIFY-APPLICATION-RESULT', True)) then
     sSQL := sSQL + ', RESULT = 4';

  sSQL := sSQL + Format(' WHERE (ID = %d);', [aID]);

  if (sSQL <> EmptyStr) then
  begin

    with TSQLQuery.Create(nil) do
    begin
      DataBase := conData;
      Transaction := traData;

      with SQL do
      begin
        Clear;
        Add(sSQL);
      end;

      ExecSQL;
      Free;
    end;

    WriteToLog(aID, rsNewWVL, rsNewWVLTxt);
  end;

  traData.Commit;
  OpenDataSources;
  qryBewerbungen.Locate('ID', aID, []);
end;

procedure TdmBewerbungen.WriteToLog(aID: Integer; aAction, aText: string);
begin
  with qryLog do
  begin
    Append;
    FieldByName('Bewerbung').AsInteger := aID;
    FieldByName('Datum').AsDateTime := Date;
    FieldByName('Typ').AsString := aAction;
    FieldByName('Beschreibung').AsString:= aText;
    Post;
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
  frmMain.sbInfo.Panels[0].Text := Format(rsDDatensTze, [GetRecordsCount(DataSet)]);

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
  frmMain.sbInfo.Panels[0].Text := Format(rsDDatensTze, [GetRecordsCount(DataSet)]);
end;

procedure TdmBewerbungen.qryBewerbungenAfterScroll(DataSet: TDataSet);
var
  nID: integer;
begin
  with qryBewerbungen do
  begin
    if VarIsNull(FieldByName('ID').AsVariant) then
      Exit;

    with frmMain.JobApplication do
    begin
      ApplicationID:=FieldByName('ID').AsInteger;
      DATUM := FieldByName('DATUM').AsDateTime;
      WVL := FieldByName('WVL').AsDateTime;
      BISDATUM := FieldByName('BISDATUM').AsDateTime;
      Vermittler:=FieldByName('Vermittler').AsInteger;
      Befristet:=FieldByName('Befristet').AsInteger;
      Ignoriert:=FieldByName('Ignoriert').AsInteger;
      Feedback:=FieldByName('Feedback').AsInteger;
      Result:=FieldByName('Result').AsInteger;
      RefNr:=FieldByName('RefNr').AsString;
      JobTitel:=FieldByName('JobTitel').AsString;
      Mail:=FieldByName('Mail').AsString;
    end;

    frmMain.edtDatum.Date := frmMain.JobApplication.Datum;
    frmMain.edtWVL.Date := frmMain.JobApplication.WVL;
    frmMain.edtEnde.Date := frmMain.JobApplication.BisDatum;
    nID := frmMain.JobApplication.ApplicationID;
  end;

  with qryCompanies do
  begin
    if Locate('ID', qryBewerbungen.FieldByName('COMPANY').AsInteger, []) then
      frmMain.sbInfo.Panels[1].Text := FieldByName('Name').AsString;
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

procedure TdmBewerbungen.qryBewerbungenBeforeInsert(DataSet: TDataSet);
begin

end;

procedure TdmBewerbungen.qryBewerbungenBeforeOpen(DataSet: TDataSet);
begin
  qryBewerbungen.Params.ParamByName('pUserID').AsInteger:= frmMain.UserID;
end;

procedure TdmBewerbungen.qryBewerbungenBeforePost(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('DATUM').AsDateTime := frmMain.edtDatum.Date;
    FieldByName('WVL').AsDateTime := frmMain.edtWVL.Date;
    if (frmMain.edtEnde.Text <> '  .  .    ') then
      FieldByName('BISDATUM').AsDateTime := frmMain.edtEnde.Date;
    if (FieldByName('REFNR').AsString <> EmptyStr) then
      FieldByName('REFNR').AsString := trim(FieldByName('REFNR').AsString);

    if (State in dsWriteModes) then
    begin
      if qryCompanies.Locate('ID', FieldByName('COMPANY').AsInteger, []) and
        (FieldByName('VERMITTLER').AsVariant = Null) then
        FieldByName('VERMITTLER').AsInteger := qryCompanies.FieldByName('VERMITTLER').AsInteger;

      if frmMain.ConfigFile.ReadBool('GENERAL', 'IGNOREPV', False) then
        if (FieldByName('VERMITTLER').AsBoolean or FieldByName('BEFRISTET').AsBoolean) then
          FieldByName('IGNORIERT').AsInteger:=1;
    end;
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
    FieldByName('UID').AsInteger:= frmMain.UserID;
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

