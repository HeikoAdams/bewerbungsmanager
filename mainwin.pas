unit mainwin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, DB, sqlite3conn, sqldb, FileUtil, Forms, Controls,
  Graphics, Dialogs, Grids, ComCtrls, ExtCtrls, StdCtrls, EditBtn,
  DBGrids, Menus, ActnList, IniFiles, DBCtrls;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    actEingang: TAction;
    actEinladung: TAction;
    actAlle: TAction;
    actAbsage: TAction;
    actExport: TAction;
    actInitiativ: TAction;
    actAngebot: TAction;
    actVorschlag: TAction;
    actVermittler: TAction;
    actWVL: TAction;
    actZusage: TAction;
    actNoResult: TAction;
    actNoFeedback: TAction;
    alFilter: TActionList;
    chkVermittler: TDBCheckBox;
    edtLogTyp: TDBEdit;
    grdBewerbungen: TDBGrid;
    grdLog: TDBGrid;
    lblNotes: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    miVorschlag: TMenuItem;
    miAngebot: TMenuItem;
    miTyp: TMenuItem;
    miVermittler: TMenuItem;
    miExport: TMenuItem;
    mmoNotes: TDBMemo;
    DBNavigator1: TDBNavigator;
    mmoText: TDBMemo;
    navActions: TDBNavigator;
    edtDatum: TDateEdit;
    edtEmpfaenger: TDBEdit;
    edtEmpfMail: TDBEdit;
    edtJobTitel: TDBEdit;
    edtLogDatum: TDateEdit;
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
    PageControl1: TPageControl;
    pnlBottom: TPanel;
    pmFilter: TPopupMenu;
    rgErgebnis: TDBRadioGroup;
    rgFeedback: TDBRadioGroup;
    rgTyp: TRadioGroup;
    dlgExport: TSaveDialog;
    sbInfo: TStatusBar;
    tsActions: TTabSheet;
    tsBewerbungData: TTabSheet;
    tsBewerbungen: TTabSheet;
    procedure actAbsageExecute(Sender: TObject);
    procedure actAlleExecute(Sender: TObject);
    procedure actAngebotExecute(Sender: TObject);
    procedure actEingangExecute(Sender: TObject);
    procedure actEinladungExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure actInitiativExecute(Sender: TObject);
    procedure actNoFeedbackExecute(Sender: TObject);
    procedure actNoResultExecute(Sender: TObject);
    procedure actVermittlerExecute(Sender: TObject);
    procedure actVorschlagExecute(Sender: TObject);
    procedure actWVLExecute(Sender: TObject);
    procedure actZusageExecute(Sender: TObject);
    procedure grdBewerbungenDblClick(Sender: TObject);
    procedure grdBewerbungenPrepareCanvas(Sender: TObject; DataCol: integer;
      Column: TColumn; AState: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure grdLogDblClick(Sender: TObject);
    procedure pmFilterPopup(Sender: TObject);
  private
    { private declarations }
    FConfigDir: string;
    FDataFile: string;
    FErrorMsg: string;
    FConfigFile: TIniFile;

    FErrorCode: integer;
    FGridFilter: word;
  public
    { public declarations }
    property ConfigFile: TIniFile read FConfigFile;
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

uses LCLType, dateutils, Data;

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
  FConfigFile := TIniFile.Create(GetAppConfigFile(False, True));

  if FileExists(FConfigFile.FileName) then
  begin
    case FConfigFile.ReadInteger('UI', 'WINDOWSTATE', 0) of
      0: WindowState := wsNormal;
      1: WindowState := wsMaximized;
      2: WindowState := wsMinimized;
    end;

    if (WindowState <> wsMaximized) then
    begin
      Top := FConfigFile.ReadInteger('UI', 'TOP', 0);
      Left := FConfigFile.ReadInteger('UI', 'LEFT', 0);
      Height := FConfigFile.ReadInteger('UI', 'HEIGHT', 600);
      Width := FConfigFile.ReadInteger('UI', 'WIDTH', 800);
    end;
  end;

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

  with dmBewerbungen.conData do
  begin
    DatabaseName := FDataFile;
    Open;
  end;

  FGridFilter := 0;
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmMain.actNoFeedbackExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryFilterFeedback;

  with dmBewerbungen.qryFilterFeedback do
  begin
    Close;
    Params.ParamValues['WERT'] := 0;
    Filter := 'RESULT = 0';
    Filtered := True;
    Open;
  end;

  FGridFilter := 1;
end;

procedure TfrmMain.actNoResultExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryFilterResult;

  with dmBewerbungen.qryFilterResult do
  begin
    Close;
    Params.ParamValues['WERT'] := 0;
    Open;
  end;

  FGridFilter := 4;
end;

procedure TfrmMain.actVermittlerExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryFilterVermittler;

  with dmBewerbungen.qryFilterVermittler do
    Open;

  FGridFilter := 8;
end;

procedure TfrmMain.actVorschlagExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryFilterTyp;

  with dmBewerbungen.qryFilterTyp do
  begin
    Close;
    Params.ParamValues['WERT'] := 2;
    Open;
  end;

  FGridFilter := 11;
end;

procedure TfrmMain.actWVLExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryFilter;

  with dmBewerbungen.qryFilter do
  begin
    Close;
    Params.ParamValues['Datum'] := FormatDateTime('yyyy-mm-dd', Date);
    Open;
  end;

  FGridFilter := 7;
end;

procedure TfrmMain.actZusageExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryFilterResult;

  with dmBewerbungen.qryFilterResult do
  begin
    Close;
    Params.ParamValues['WERT'] := 1;
    Open;
  end;

  FGridFilter := 5;
end;

procedure TfrmMain.actEingangExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryFilterFeedback;

  with dmBewerbungen.qryFilterFeedback do
  begin
    Close;
    Params.ParamValues['WERT'] := 1;
    Filtered := False;
    Open;
  end;

  FGridFilter := 2;
end;

procedure TfrmMain.actAlleExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryBewerbungen;

  with dmBewerbungen.qryBewerbungen do
  begin
    Filter := EmptyStr;
    Filtered := False;
  end;

  FGridFilter := 0;
end;

procedure TfrmMain.actAngebotExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryFilterTyp;

  with dmBewerbungen.qryFilterTyp do
  begin
    Close;
    Params.ParamValues['WERT'] := 1;
    Open;
  end;

  FGridFilter := 10;
end;

procedure TfrmMain.actAbsageExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryFilterResult;

  with dmBewerbungen.qryFilterResult do
  begin
    Close;
    Params.ParamValues['WERT'] := 2;
    Open;
  end;

  FGridFilter := 6;
end;

procedure TfrmMain.actEinladungExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryFilterFeedback;

  with dmBewerbungen.qryFilterFeedback do
  begin
    Close;
    Params.ParamValues['WERT'] := 2;
    Filtered := False;
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

    with dmBewerbungen.qryCSVExport do
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

procedure TfrmMain.actInitiativExecute(Sender: TObject);
begin
  dmBewerbungen.dsData.DataSet := dmBewerbungen.qryFilterTyp;

  with dmBewerbungen.qryFilterTyp do
  begin
    Close;
    Params.ParamValues['WERT'] := 0;
    Open;
  end;

  FGridFilter := 9;
end;

procedure TfrmMain.grdBewerbungenDblClick(Sender: TObject);
begin
  dmBewerbungen.qryBewerbungen.Edit;
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

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  with FConfigFile do
  begin
    if (WindowState <> wsMaximized) then
    begin
      WriteInteger('UI', 'TOP', Top);
      WriteInteger('UI', 'LEFT', Left);
      WriteInteger('UI', 'HEIGHT', Height);
      WriteInteger('UI', 'WIDTH', Width);
    end;

    case WindowState of
      wsNormal: WriteInteger('UI', 'WINDOWSTATE', 0);
      wsMaximized: WriteInteger('UI', 'WINDOWSTATE', 1);
      wsMinimized: WriteInteger('UI', 'WINDOWSTATE', 2);
    end;
  end;

  dmBewerbungen.conData.Close;
end;

procedure TfrmMain.grdLogDblClick(Sender: TObject);
begin
  if (dmBewerbungen.qryBewerbungen.State = dsEdit) then
    dmBewerbungen.qryLog.Edit;
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

end.

