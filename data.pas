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
    qryBewerbungen: TSQLQuery;
    qryCSVExport: TSQLQuery;
    qryFilter: TSQLQuery;
    qryFilterFeedback: TSQLQuery;
    qryFilterResult: TSQLQuery;
    qryFilterTyp: TSQLQuery;
    qryFilterVermittler: TSQLQuery;
    qryLog: TSQLQuery;
    traData: TSQLTransaction;
    procedure conDataAfterConnect(Sender: TObject);
    procedure conDataBeforeDisconnect(Sender: TObject);
    procedure dsDataStateChange(Sender: TObject);
    procedure dsLogStateChange(Sender: TObject);
    procedure qryBewerbungenAfterDelete(DataSet: TDataSet);
    procedure qryBewerbungenAfterInsert(DataSet: TDataSet);
    procedure qryBewerbungenAfterOpen(DataSet: TDataSet);
    procedure qryBewerbungenAfterScroll(DataSet: TDataSet);
    procedure qryBewerbungenBeforePost(DataSet: TDataSet);
    procedure qryLogAfterScroll(DataSet: TDataSet);
    procedure qryLogBeforePost(DataSet: TDataSet);
  private
    { private declarations }
    FEditMode: boolean;
    FInsertMode: boolean;
  public
    { public declarations }
  end;

var
  dmBewerbungen: TdmBewerbungen;

implementation

uses mainwin, bewerbung_strings;

{$R *.lfm}

{ TdmBewerbungen }

procedure TdmBewerbungen.conDataAfterConnect(Sender: TObject);
begin
  qryBewerbungen.Open;
  qryLog.Open;
end;

procedure TdmBewerbungen.conDataBeforeDisconnect(Sender: TObject);
begin
  conData.Transaction.Commit;
end;

procedure TdmBewerbungen.dsDataStateChange(Sender: TObject);
begin
  FEditMode := ((Sender as TDatasource).State in dsWriteModes);
  FInsertMode := ((Sender as TDatasource).State = dsInsert);

  frmMain.tsBewerbungData.Enabled := FEditMode;

  if FEditMode then
  begin
    if (frmMain.PageControl1.ActivePageIndex <> 1) then
      frmMain.PageControl1.ActivePageIndex := 1;

    frmMain.navActions.VisibleButtons :=
      [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit,
      nbPost, nbCancel, nbRefresh];
  end
  else
    frmMain.navActions.VisibleButtons := [nbFirst, nbPrior, nbNext, nbLast, nbRefresh];
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

procedure TdmBewerbungen.qryBewerbungenAfterDelete(DataSet: TDataSet);
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

procedure TdmBewerbungen.qryBewerbungenAfterInsert(DataSet: TDataSet);
var
  nDefaults: array[0..2] of integer;
  bVermittler: boolean;
begin
  if FileExists(frmMain.ConfigFile.FileName) then
  begin
    nDefaults[0] := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'TYP', 1);
    nDefaults[1] := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'FEEDBACK', 1);
    nDefaults[2] := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'RESULT', 0);
    bVermittler := frmMain.ConfigFile.ReadBool('DEFAULTS', 'VERMITTLER', False);
  end
  else
  begin
    nDefaults[0] := 1;
    nDefaults[1] := 0;
    nDefaults[2] := 0;
    bVermittler := False;
  end;

  with DataSet do
  begin
    FieldByName('TYP').AsInteger := nDefaults[0];
    FieldByName('FEEDBACK').AsInteger := nDefaults[1];
    FieldByName('RESULT').AsInteger := nDefaults[2];
    FieldByName('VERMITTLER').AsBoolean := bVermittler;
  end;
end;

procedure TdmBewerbungen.qryBewerbungenAfterOpen(DataSet: TDataSet);
begin
  frmMain.sbInfo.SimpleText := Format(rsDDatensTze, [DataSet.RecordCount]);
end;

procedure TdmBewerbungen.qryBewerbungenAfterScroll(DataSet: TDataSet);
var
  nID: integer;
begin
  with qryBewerbungen do
  begin
    frmMain.edtDatum.Date := FieldByName('DATUM').AsDateTime;
    frmMain.edtWVL.Date := FieldByName('WVL').AsDateTime;
  end;

  nID := qryBewerbungen.FieldByName('ID').AsInteger;

  with qryLog do
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

    if (State = dsInsert) then
      FieldByName('WVL').AsDateTime := IncDay(frmMain.edtDatum.Date, 14)
    else
    begin
      if (frmMain.edtWVL.Date <> 0) then
        FieldByName('WVL').AsDateTime := frmMain.edtWVL.Date
      else
        FieldByName('WVL').AsDateTime := IncDay(frmMain.edtWVL.Date, 14);
    end;
  end;
end;

procedure TdmBewerbungen.qryLogAfterScroll(DataSet: TDataSet);
begin
  with frmMain do
  begin
    edtLogDatum.Date := DataSet.FieldByName('DATUM').AsDateTime;
    //edtLogTyp.Text := DataSet.FieldByName('TYP').AsString;
    //mmoText.Lines.Text := DataSet.FieldByName('BESCHREIBUNG').AsString;
  end;
end;

procedure TdmBewerbungen.qryLogBeforePost(DataSet: TDataSet);
begin
  DataSet.FieldByName('BEWERBUNG').AsInteger :=
    qryBewerbungen.FieldByName('ID').AsInteger;
  DataSet.FieldByName('DATUM').AsDateTime := frmMain.edtLogDatum.Date;
  //DataSet.FieldByName('TYP').AsString := frmMain.edtLogTyp.Text;
  //DataSet.FieldByName('BESCHREIBUNG').AsString := frmMain.mmoText.Lines.Text;
end;

end.

