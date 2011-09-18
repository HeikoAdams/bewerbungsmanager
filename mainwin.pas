unit mainwin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, DB, sqlite3conn, sqldb, FileUtil, Forms, Controls,
  Graphics, Dialogs, Grids, ComCtrls, ExtCtrls, StdCtrls, Calendar, EditBtn,
  DBGrids, DBCtrls, Menus, ActnList, FileCtrl, types;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    actEingang: TAction;
    actEinladung: TAction;
    actAlle: TAction;
    actAbsage: TAction;
    actExport: TAction;
    actWVL: TAction;
    actZusage: TAction;
    actNoResult: TAction;
    actNoFeedback: TAction;
    alFilter: TActionList;
    conData: TSQLite3Connection;
    chkVermittler: TDBCheckBox;
    grdBewerbungen: TDBGrid;
    grdLog: TDBGrid;
    lblNotes: TLabel;
    MenuItem1: TMenuItem;
    miExport: TMenuItem;
    mmoNotes: TDBMemo;
    DBNavigator1: TDBNavigator;
    navActions: TDBNavigator;
    dsData: TDatasource;
    dsLog: TDatasource;
    edtDatum: TDateEdit;
    edtEmpfaenger: TDBEdit;
    edtEmpfMail: TDBEdit;
    edtJobTitel: TDBEdit;
    edtLogDatum: TDateEdit;
    edtLogTyp: TEdit;
    edtRefNr: TDBEdit;
    edtWVL: TDateEdit;
    ilIcons: TImageList;
    lblDatum: TLabel;
    lblEmpfMail: TLabel;
    lblJobTitel: TLabel;
    lblLogDatum: TLabel;
    lblLogText: TLabel;
    lblLogTyp: TLabel;
    lblRefNr: TLabel;
    lblWo: TLabel;
    lblWVL: TLabel;
    miWVL: TMenuItem;
    miAbsage: TMenuItem;
    miZusage: TMenuItem;
    miNoResult: TMenuItem;
    miAlle: TMenuItem;
    miResult: TMenuItem;
    miEinladung: TMenuItem;
    miEingang: TMenuItem;
    miNoFeedback: TMenuItem;
    miFeedback: TMenuItem;
    mmoText: TMemo;
    PageControl1: TPageControl;
    pnlBottom: TPanel;
    pmFilter: TPopupMenu;
    qryBewerbungen: TSQLQuery;
    qryLog: TSQLQuery;
    rgErgebnis: TDBRadioGroup;
    rgFeedback: TDBRadioGroup;
    rgTyp: TRadioGroup;
    dlgExport: TSaveDialog;
    sbInfo: TStatusBar;
    qryCSVExport: TSQLQuery;
    qryFilter: TSQLQuery;
    qryFilterFeedback: TSQLQuery;
    qryFilterResult: TSQLQuery;
    traData: TSQLTransaction;
    tsActions: TTabSheet;
    tsBewerbungData: TTabSheet;
    tsBewerbungen: TTabSheet;
    procedure actAbsageExecute(Sender: TObject);
    procedure actAlleExecute(Sender: TObject);
    procedure actEingangExecute(Sender: TObject);
    procedure actEinladungExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure actNoFeedbackExecute(Sender: TObject);
    procedure actNoResultExecute(Sender: TObject);
    procedure actWVLExecute(Sender: TObject);
    procedure actZusageExecute(Sender: TObject);
    procedure conDataAfterConnect(Sender: TObject);
    procedure conDataBeforeDisconnect(Sender: TObject);
    procedure dbDataAfterOpen(DataSet: TDataSet);
    procedure dbDataAfterScroll(DataSet: TDataSet);
    procedure dbDataBeforePost(DataSet: TDataSet);
    procedure grdBewerbungenDblClick(Sender: TObject);
    procedure grdBewerbungenPrepareCanvas(Sender: TObject; DataCol: integer;
      Column: TColumn; AState: TGridDrawState);
    procedure dbLogAfterScroll(DataSet: TDataSet);
    procedure dbLogBeforePost(DataSet: TDataSet);
    procedure dsDataStateChange(Sender: TObject);
    procedure dsLogStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure grdLogDblClick(Sender: TObject);
    procedure pmFilterPopup(Sender: TObject);
    procedure qryBewerbungenAfterInsert(DataSet: TDataSet);
    procedure qryBewerbungenAfterPost(DataSet: TDataSet);
  private
    { private declarations }
    FConfigDir: string;
    FDataFile: string;
    FLogFile: string;
    FErrorMsg: string;

    FErrorCode: integer;
    FGridFilter: word;

    FEditMode: boolean;
    FInsertMode: boolean;
  public
    { public declarations }
    procedure HandleError;
  end;

var
  frmMain: TfrmMain;

resourcestring
  rsCSVExport = 'CSV-Export';
  rsDatenbankSKo = 'Datenbank (%s) konnte nicht gefunden werden!';
  rsDDatensTze = '%d Datensätze';
  rsExportBeende = 'Export beendet';
  rsFehler = 'Fehler';
  rsDateFormat = 'dd.mm.yyyy';


implementation

uses LCLType, dateutils;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.HandleError;
begin
  FErrorCode := GetLastOSError;
  FErrorMsg := SysErrorMessage(FErrorCode);

  Application.MessageBox(PChar(rsFehler), PChar(FErrorMsg), MB_ICONWARNING + MB_OK);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FConfigDir := GetAppConfigDir(False);
  FDataFile := IncludeTrailingPathDelimiter(FConfigDir) + 'bewerbungen.db';

  if not DirectoryExists(FConfigDir) then
    if not CreateDir(FConfigDir) then
      HandleError;

  if not FileExists(FDataFile) then
  begin
    with Application do
    begin
      MessageBox(PChar(rsFehler),
      PChar(Format(rsDatenbankSKo, [FDataFile])),
      MB_ICONERROR + MB_OK);
      Terminate;
      Exit;
    end;
  end;

  with conData do
  begin
    DatabaseName := FDataFile;
    Open;
  end;

  FGridFilter := 0;
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmMain.dbDataAfterScroll(DataSet: TDataSet);
var
  nID: integer;
begin
  with qryBewerbungen do
  begin
    edtDatum.Date := FieldByName('DATUM').AsDateTime;
    edtWVL.Date := FieldByName('WVL').AsDateTime;
  end;

  nID := qryBewerbungen.FieldByName('ID').AsInteger;

  with qryLog do
  begin
    Close;
    Params.ParamValues['ID'] := nID;
    Open;
  end;
end;

procedure TfrmMain.conDataAfterConnect(Sender: TObject);
begin
  qryBewerbungen.Open;
  qryLog.Open;
end;

procedure TfrmMain.actNoFeedbackExecute(Sender: TObject);
begin
  dsData.DataSet := qryFilterFeedback;

  with qryFilterFeedback do
  begin
    Close;
    Params.ParamValues['WERT'] := 0;
    Open;
  end;

  FGridFilter := 1;
end;

procedure TfrmMain.actNoResultExecute(Sender: TObject);
begin
  dsData.DataSet := qryFilterResult;

  with qryFilterResult do
  begin
    Close;
    Params.ParamValues['WERT'] := 0;
    Open;
  end;

  FGridFilter := 4;
end;

procedure TfrmMain.actWVLExecute(Sender: TObject);
begin
  dsData.DataSet := qryFilter;

  with qryFilter do
  begin
    Close;
    Params.ParamValues['Datum'] := FormatDateTime('dd.mm.yyyy', Date);
    Open;
  end;

  FGridFilter := 7;
end;

procedure TfrmMain.actZusageExecute(Sender: TObject);
begin
  dsData.DataSet := qryFilterResult;

  with qryFilterResult do
  begin
    Close;
    Params.ParamValues['WERT'] := 1;
    Open;
  end;

  FGridFilter := 5;
end;

procedure TfrmMain.actEingangExecute(Sender: TObject);
begin
  dsData.DataSet := qryFilterFeedback;

  with qryFilterFeedback do
  begin
    Close;
    Params.ParamValues['WERT'] := 1;
    Open;
  end;

  FGridFilter := 2;
end;

procedure TfrmMain.actAlleExecute(Sender: TObject);
begin
  dsData.DataSet := qryBewerbungen;

  with qryBewerbungen do
  begin
    Filter := EmptyStr;
    Filtered := False;
  end;

  FGridFilter := 0;
end;

procedure TfrmMain.actAbsageExecute(Sender: TObject);
begin
  dsData.DataSet := qryFilterResult;

  with qryFilterResult do
  begin
    Close;
    Params.ParamValues['WERT'] := 2;
    Open;
  end;

  FGridFilter := 6;
end;

procedure TfrmMain.actEinladungExecute(Sender: TObject);
begin
  dsData.DataSet := qryFilterFeedback;

  with qryFilterFeedback do
  begin
    Close;
    Params.ParamValues['WERT'] := 2;
    Open;
  end;

  FGridFilter := 3;
end;

procedure TfrmMain.actExportExecute(Sender: TObject);
var
  ExportFile: TextFile;
  sFileName: string;
  sLine: string;
  nCount: integer;
begin
  if dlgExport.Execute then
  begin
    sFileName := dlgExport.FileName;

    AssignFile(ExportFile, sFileName);

    if FileExists(sFileName) then
      Append(ExportFile)
    else
      Rewrite(ExportFile);

    with qryCSVExport do
    begin
      Open;

      sLine := EmptyStr;
      for nCount := 0 to Fields.Count - 1 do
        sLine := sLine + Fields[nCount].FieldName + ';';

      WriteLn(ExportFile, UTF8ToSys(sLine));

      while not EOF do
      begin
        sLine := EmptyStr;

        for nCount := 0 to Fields.Count - 1 do
          sLine := sLine + Fields[nCount].Text + ';';

        WriteLn(ExportFile, UTF8ToSys(sLine));
        Next;
      end;

      Close;
    end;

    CloseFile(ExportFile);

    Application.MessageBox(PChar(rsExportBeende), PChar(rsCSVExport),
      MB_ICONINFORMATION + MB_OK);
  end;
end;

procedure TfrmMain.conDataBeforeDisconnect(Sender: TObject);
begin
  conData.Transaction.Commit;
end;

procedure TfrmMain.dbDataAfterOpen(DataSet: TDataSet);
begin
  sbInfo.SimpleText := Format(rsDDatensTze, [DataSet.RecordCount]);
end;

procedure TfrmMain.dbDataBeforePost(DataSet: TDataSet);
begin
  with qryBewerbungen do
  begin
    FieldByName('DATUM').AsDateTime := edtDatum.Date;

    if (State = dsInsert) then
      FieldByName('WVL').AsDateTime := IncDay(edtDatum.Date, 14)
    else
    begin
      if (edtWVL.Date <> 0) then
        FieldByName('WVL').AsDateTime := edtWVL.Date
      else
        FieldByName('WVL').AsDateTime := IncDay(edtWVL.Date, 14);
    end;
  end;
end;

procedure TfrmMain.grdBewerbungenDblClick(Sender: TObject);
begin
  qryBewerbungen.Edit;
end;

procedure TfrmMain.grdBewerbungenPrepareCanvas(Sender: TObject;
  DataCol: integer; Column: TColumn; AState: TGridDrawState);
begin
  with (Sender as TDBGrid) do
  begin
    // Kein Feedback und WVL-Termin überschritten
    if (DataSource.DataSet.FieldByName('FEEDBACK').AsInteger = 0) and
      (DataSource.DataSet.FieldByName('RESULT').AsInteger = 0) and
      (DataSource.DataSet.FieldByName('WVL').AsDateTime <= Date) then
      Canvas.Font.Color := clMaroon;

    // Eingangsbestätigung liegt vor
    if (DataSource.DataSet.FieldByName('FEEDBACK').AsInteger = 1) and
      (DataSource.DataSet.FieldByName('RESULT').AsInteger = 0) then
      Canvas.Font.Color := clNavy;

    // Zusage erhalten
    if (DataSource.DataSet.FieldByName('RESULT').AsInteger = 1) then
      Canvas.Font.Color := clGreen;

    // Absage erhalten
    if (DataSource.DataSet.FieldByName('RESULT').AsInteger = 2) then
      Canvas.Font.Color := clRed;
  end;
end;

procedure TfrmMain.dbLogAfterScroll(DataSet: TDataSet);
begin
  edtLogDatum.Date := DataSet.FieldByName('DATUM').AsDateTime;
  edtLogTyp.Text := DataSet.FieldByName('TYP').AsString;
  mmoText.Lines.Text := DataSet.FieldByName('BESCHREIBUNG').AsString;
end;

procedure TfrmMain.dbLogBeforePost(DataSet: TDataSet);
begin
  DataSet.FieldByName('BEWERBUNG').AsInteger :=
    qryBewerbungen.FieldByName('ID').AsInteger;
  DataSet.FieldByName('DATUM').AsDateTime := edtLogDatum.Date;
  DataSet.FieldByName('TYP').AsString := edtLogTyp.Text;
  DataSet.FieldByName('BESCHREIBUNG').AsString := mmoText.Lines.Text;
end;

procedure TfrmMain.dsDataStateChange(Sender: TObject);
begin
  FEditMode := ((Sender as TDatasource).State in dsWriteModes);
  FInsertMode := ((Sender as TDatasource).State = dsInsert);

  tsBewerbungData.Enabled := FEditMode;

  if FEditMode then
  begin
    if (PageControl1.ActivePageIndex <> 1) then
        PageControl1.ActivePageIndex := 1;

    navActions.VisibleButtons :=
      [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost,
      nbCancel, nbRefresh];
  end
  else
    navActions.VisibleButtons := [nbFirst, nbPrior, nbNext, nbLast, nbRefresh];
end;

procedure TfrmMain.dsLogStateChange(Sender: TObject);
var
  bEditMode: boolean;
begin
  bEditMode := ((Sender as TDatasource).State in dsEditModes);

  edtLogDatum.Enabled := bEditMode;
  edtLogTyp.Enabled := bEditMode;
  mmoText.Enabled := bEditMode;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  conData.Close;
end;

procedure TfrmMain.grdLogDblClick(Sender: TObject);
begin
  if (qryBewerbungen.State = dsEdit) then
     qryLog.Edit;
end;

procedure TfrmMain.pmFilterPopup(Sender: TObject);
var
  nCount, nCount2: integer;
  TempItem: TMenuItem;
begin
  for nCount := 0 to pmFilter.Items.Count - 1 do
  begin
    TempItem := pmFilter.Items[nCount];

    if (TempItem.Count > 0) then
    begin
      for nCount2 := 0 to TempItem.Count - 1 do
        TempItem.Items[nCount2].Checked := (TempItem.Items[nCount2].Tag = FGridFilter);
    end
    else
      TempItem.Checked := (TempItem.Tag = FGridFilter);
  end;
end;

procedure TfrmMain.qryBewerbungenAfterInsert(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('TYP').AsInteger := 1;
    FieldByName('FEEDBACK').AsInteger := 0;
    FieldByName('RESULT').AsInteger := 0;
    FieldByName('VERMITTLER').AsBoolean := False;
  end;
end;

procedure TfrmMain.qryBewerbungenAfterPost(DataSet: TDataSet);
var
  Bookmark: TBookmark;
begin
  try
    Bookmark := DataSet.GetBookmark;
    TSQLQuery(DataSet).ApplyUpdates;

    if traData.Active then
    begin
      traData.CommitRetaining;
      //DataSet.Refresh;

      if DataSet.BookmarkValid(Bookmark) then
        DataSet.GotoBookmark(Bookmark);

      DataSet.FreeBookmark(Bookmark);
    end;
  except
    traData.Rollback;
  end;
end;

end.

