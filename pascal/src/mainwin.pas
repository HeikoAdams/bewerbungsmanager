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

unit mainwin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls,
  Graphics, Dialogs, Grids, ComCtrls, ExtCtrls, StdCtrls, EditBtn,
  DBGrids, Menus, ActnList, IniFiles, DBCtrls, Buttons, types;

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
    actAllNoAbsage: TAction;
    actFind: TAction;
    actIgnore: TAction;
    actBefristet: TAction;
    actIgnoriert: TAction;
    actWriteMail: TAction;
    actRevoke: TAction;
    actSettings: TAction;
    actOnlineForm: TAction;
    actPost: TAction;
    actMail: TAction;
    actVorschlag: TAction;
    actVermittler: TAction;
    actWVL: TAction;
    actZusage: TAction;
    actNoResult: TAction;
    actNoFeedback: TAction;
    alFilter: TActionList;
    btnFileOpen: TBitBtn;
    btnBrowse: TBitBtn;
    chkVermittler: TDBCheckBox;
    cbFileType: TDBComboBox;
    cbbEmpfName: TDBComboBox;
    cbbEmpfMail: TDBComboBox;
    cbbJobTitel: TDBComboBox;
    chkBefristet: TDBCheckBox;
    chkIgnoriert: TDBCheckBox;
    cbbAnspr: TDBComboBox;
    edtFile: TDBEdit;
    DBGrid1: TDBGrid;
    dlgFindCompany: TFindDialog;
    cbbLogTyp: TDBComboBox;
    Label1: TLabel;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    miBefristet: TMenuItem;
    miVermittler: TMenuItem;
    miWVL: TMenuItem;
    miIgnorieren: TMenuItem;
    miAlleNoAbs: TMenuItem;
    miAlle: TMenuItem;
    miWriteMail: TMenuItem;
    miRevoke: TMenuItem;
    miSettings: TMenuItem;
    miSuche: TMenuItem;
    miOnlineForm: TMenuItem;
    miPost: TMenuItem;
    miMail: TMenuItem;
    miMedium: TMenuItem;
    navDocs: TDBNavigator;
    lblDokFilename: TLabel;
    lblDokDescr: TLabel;
    dlgDocuments: TOpenDialog;
    pnlDokBottom: TPanel;
    rgMedium: TDBRadioGroup;
    grdBewerbungen: TDBGrid;
    grdLog: TDBGrid;
    lblNotes: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    miVorschlag: TMenuItem;
    miAngebot: TMenuItem;
    miTyp: TMenuItem;
    miExport: TMenuItem;
    mmoNotes: TDBMemo;
    navData: TDBNavigator;
    mmoText: TDBMemo;
    navActions: TDBNavigator;
    edtDatum: TDateEdit;
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
    miAbsage: TMenuItem;
    miZusage: TMenuItem;
    miNoResult: TMenuItem;
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
    tsDokumente: TTabSheet;
    tsActions: TTabSheet;
    tsBewerbungData: TTabSheet;
    tsBewerbungen: TTabSheet;
    procedure actAbsageExecute(Sender: TObject);
    procedure actAlleExecute(Sender: TObject);
    procedure actAllNoAbsageExecute(Sender: TObject);
    procedure actAngebotExecute(Sender: TObject);
    procedure actBefristetExecute(Sender: TObject);
    procedure actEingangExecute(Sender: TObject);
    procedure actEinladungExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actIgnoreExecute(Sender: TObject);
    procedure actIgnoriertExecute(Sender: TObject);
    procedure actInitiativExecute(Sender: TObject);
    procedure actMailExecute(Sender: TObject);
    procedure actNoFeedbackExecute(Sender: TObject);
    procedure actNoResultExecute(Sender: TObject);
    procedure actOnlineFormExecute(Sender: TObject);
    procedure actPostExecute(Sender: TObject);
    procedure actRevokeExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actVermittlerExecute(Sender: TObject);
    procedure actVorschlagExecute(Sender: TObject);
    procedure actWriteMailExecute(Sender: TObject);
    procedure actWVLExecute(Sender: TObject);
    procedure actZusageExecute(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnFileOpenClick(Sender: TObject);
    procedure DBGrid1PrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure dlgFindCompanyFind(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure grdBewerbungenDblClick(Sender: TObject);
    procedure grdBewerbungenPrepareCanvas(Sender: TObject; DataCol: integer;
      Column: TColumn; AState: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure grdLogDblClick(Sender: TObject);
    procedure pmFilterPopup(Sender: TObject);
  private
    { private declarations }
    FConfigDir: string;
    FDataFile: string;
    FErrorMsg: string;
    {$IFDEF Unix}FLinuxLaunch: string;{$ENDIF}
    FLockFile: string;
    FConfigFile: TIniFile;

    FErrorCode: integer;
    {$IFDEF Unix}FLockHandle: integer;{$ENDIF}
    FGridFilter: word;

    procedure NotifyWVL;
  public
    { public declarations }
    property ConfigFile: TIniFile read FConfigFile;
    procedure HandleError;
  end;

var
  frmMain: TfrmMain;

implementation

uses LCLType, dateutils, Data, bewerbung_strings, Process, variants,
  exportdate, settings, DB, sqldb;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.HandleError;
begin
  FErrorCode := GetLastOSError;
  FErrorMsg := SysErrorMessage(FErrorCode);

  Application.MessageBox(PChar(rsFehler), PChar(FErrorMsg), MB_ICONWARNING + MB_OK);
end;

procedure TfrmMain.NotifyWVL;
var
  nCount: integer;
  sMessage: string;
begin
  with TSQLQuery.Create(nil) do
  begin
    DataBase := dmBewerbungen.conData;
    Transaction := dmBewerbungen.traData;

    with SQL do
    begin
      Add('SELECT COUNT(*) ANZAHL');
      Add('FROM BEWERBUNGEN');
      Add(Format('WHERE ' + rsWHEREWVLSAND, [FloatToStr(date)]));
    end;

    Open;
    nCount := FieldByName('ANZAHL').AsInteger;
    Close;
    Free;
  end;

  if (nCount > 0) then
  begin
    sMessage := Format(rsEsBefindenSi, [nCount]);
    Application.MessageBox(PChar(sMessage), 'Wiedervorlage', MB_ICONWARNING + MB_OK);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  sConfFileName: string;
  nCounter: Integer;
begin
  if (ParamStr(1) = 'portable') then
  begin
    FConfigDir := ExtractFilePath(Application.ExeName);
    sConfFileName := StringReplace(GetAppConfigFile(False, True),
      GetAppConfigDir(False), FConfigDir, [rfIgnoreCase, rfReplaceAll]);
  end
  else
  begin
    FConfigDir := GetAppConfigDir(False);
    sConfFileName := GetAppConfigFile(False, True);
  end;

  if DirectoryExists(ExtractFileDir(sConfFileName)) then
    if CreateDir(ExtractFileDir(sConfFileName)) then
      HandleError;

  FDataFile := IncludeTrailingPathDelimiter(FConfigDir) + 'bewerbungen.db';
  FConfigFile := TIniFile.Create(sConfFileName);
  FLockFile := IncludeTrailingPathDelimiter(FConfigDir) + '.lock';

  {$IFDEF Unix}
  FLockHandle := 0;

  // If a lock-file exists, abort start. Otherwise create it
  if FileExists(FLockFile) then
  begin
    Application.MessageBox(PChar(rsDasProgrammW),
      PChar(rsWarnung), MB_ICONWARNING + MB_OK);
    Application.Terminate;
    Exit;
  end
  else
    FLockHandle := FileCreate(FLockFile);
  {$ENDiF}

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

  with dmBewerbungen.conData do
  begin
    DatabaseName := FDataFile;
    Open;
  end;

  if FConfigFile.ReadBool('GENERAL', 'NOTIFY-WVL', True) then
    NotifyWVL;

  {$IFDEF Unix}
  FLinuxLaunch := FConfigFile.ReadString('LINUX', 'LAUNCHER',
    '/usr/bin/xdg-open "%s"');
  {$ENDIF}

  //actAllNoAbsage.Execute;
  FGridFilter := FConfigFile.ReadInteger('FILTER', 'LAST FILTER', 15);

  for nCounter := 0 to alFilter.ActionCount -1 do
    if alFilter.Actions[nCounter].Tag = FGridFilter then
    begin
      alFilter.Actions[nCounter].Execute;
      Break;
    end;

  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmMain.actNoFeedbackExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsFEEDBACKD + ' AND (RESULT = 0)', [0]));

  FGridFilter := 1;
end;

procedure TfrmMain.actNoResultExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsRESULTD, [0]));

  FGridFilter := 4;
end;

procedure TfrmMain.actOnlineFormExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsMEDIUMD, [2]));

  FGridFilter := 14;
end;

procedure TfrmMain.actPostExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsMEDIUMD, [1]));

  FGridFilter := 13;
end;

procedure TfrmMain.actRevokeExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsRESULTD, [3]));

  FGridFilter := 16;
end;

procedure TfrmMain.actSettingsExecute(Sender: TObject);
begin
  Application.CreateForm(TfrmSettings, frmSettings);
  frmSettings.ShowModal;
  FreeAndNil(frmSettings);
end;

procedure TfrmMain.actVermittlerExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData('(CAST(VERMITTLER AS INTEGER) <> 0)');

  FGridFilter := 8;
end;

procedure TfrmMain.actVorschlagExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsTYPD, [2]));

  FGridFilter := 11;
end;

procedure TfrmMain.actWriteMailExecute(Sender: TObject);
var
  sCommand: string;
  sSubject: string;
begin
  if (dmBewerbungen.qryBewerbungen.FieldByName('REFNR').AsString <> EmptyStr) then
    sSubject := Format(rsMeineBewerbu,
      [FormatDateTime(rsDateFormat, dmBewerbungen.qryBewerbungen.FieldByName(
      'DATUM').AsDateTime), dmBewerbungen.qryBewerbungen.FieldByName(
      'JOBTITEL').AsString, dmBewerbungen.qryBewerbungen.FieldByName('REFNR').AsString])
  else
    sSubject := Format(rsMeineBewerbu2,
      [FormatDateTime(rsDateFormat, dmBewerbungen.qryBewerbungen.FieldByName(
      'DATUM').AsDateTime), dmBewerbungen.qryBewerbungen.FieldByName(
      'JOBTITEL').AsString]);

  sCommand := Format(rsMailtoS,
    [dmBewerbungen.qryBewerbungen.FieldByName('Mail').AsString, sSubject]);

  { TODO 1 : Shell-Execute Code zum Erstellen einer Mail unter Windows einfügen }
  {$IFDEF Unix}
  with TProcess.Create(nil) do
  begin
    CommandLine := Format(rsUsrBinXdgOpe, [sCommand]);
    Options := Options + [poWaitOnExit];
    Execute;
    Free;
  end;
  {$endif}
  {$IFDEF Windows}
  Beep;
  {$endif}
end;

procedure TfrmMain.actWVLExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsWHEREWVLSAND, [FloatToStr(date)]));

  FGridFilter := 7;
end;

procedure TfrmMain.actZusageExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsRESULTD, [1]));

  FGridFilter := 5;
end;

procedure TfrmMain.btnBrowseClick(Sender: TObject);
begin
  if dlgDocuments.Execute then
    dmBewerbungen.qryDocuments.FieldByName('FILENAME').AsString := dlgDocuments.FileName;
end;

{$IFDEF Unix}
procedure TfrmMain.btnFileOpenClick(Sender: TObject);
begin
  { TODO 1 : Shell-Execute Code zum Öffnen der Dokumente unter Windows einfügen }
  with TProcess.Create(nil) do
  begin
    CommandLine := Format(FLinuxLaunch, [edtFile.Text]);
    Options := Options + [poWaitOnExit];
    Execute;
    Free;
  end;
end;
{$endif}

procedure TfrmMain.DBGrid1PrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
  with (Sender as TDBGrid) do
  begin
    btnFileOpen.Enabled := FileExists(DataSource.DataSet.FieldByName('FILENAME').AsString);

    if not btnFileOpen.Enabled then
    begin
      Canvas.Font.Color := clMaroon;
      Canvas.Font.Style := [fsBold];
    end;
  end;
end;

{$IFDEF Windows}
procedure TfrmMain.btnFileOpenClick(Sender: TObject);
begin
  { TODO 1 : Shell-Execute Code zum Öffnen der Dokumente unter Windows einfügen }
  Beep;
end;
{$endif}

procedure TfrmMain.dlgFindCompanyFind(Sender: TObject);
begin
  if not dmBewerbungen.qryBewerbungen.Locate('NAME',
    VarArrayOf([dlgFindCompany.FindText]), [loCaseInsensitive, loPartialKey]) then
    Application.MessageBox(PChar(rsKeineBereins), PChar(rsSuche),
      MB_OK + MB_ICONWARNING)
  else
    dlgFindCompany.CloseDialog;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
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

    WriteInteger('FILTER', 'LAST FILTER', FGridFilter);

    UpdateFile;
  end;

  dmBewerbungen.conData.Close;

  {$IFDEF Unix}
  // If a lock-file is created delete it
  if (FLockHandle <> 0) then
    DeleteFile(FLockFile);
  {$ENDIF}
end;

procedure TfrmMain.actEingangExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsFEEDBACKD, [1]));

  FGridFilter := 2;
end;

procedure TfrmMain.actAlleExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(EmptyStr);

  FGridFilter := 0;
end;

procedure TfrmMain.actAllNoAbsageExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(rsRESULT2);

  FGridFilter := 15;
end;

procedure TfrmMain.actAngebotExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsTYPD, [1]));

  FGridFilter := 10;
end;

procedure TfrmMain.actBefristetExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData('(CAST(BEFRISTET AS INTEGER) <> 0)');

  FGridFilter := 16;
end;

procedure TfrmMain.actAbsageExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsRESULTD, [2]));

  FGridFilter := 6;
end;

procedure TfrmMain.actEinladungExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsFEEDBACKD, [2]));

  FGridFilter := 3;
end;

procedure TfrmMain.actExportExecute(Sender: TObject);
var
  ExportFile: TextFile;
  sFileName: string;
  sLine: string;
  nCount: integer;
  dtDateFrom, dtDateDue: TDate;
begin
  Application.CreateForm(TfrmExportDate, frmExportDate);

  if (frmExportDate.ShowModal = mrAbort) then
  begin
    FreeAndNil(frmExportDate);
    Exit;
  end;

  dlgExport.InitialDir := GetUserDir;

  if dlgExport.Execute then
  begin
    sFileName := dlgExport.FileName;

    frmExportDate.GetDateRange(dtDateFrom, dtDateDue);
    FreeAndNil(frmExportDate);
    AssignFile(ExportFile, sFileName);
    dmBewerbungen.FetchExportData(Format('WHERE (DATUM >= %d) AND (DATUM <= %d)',
      [trunc(dtDateFrom), trunc(dtDateDue)]));

    if FileExists(sFileName) then
      DeleteFile(sFileName);

    Rewrite(ExportFile);

    with dmBewerbungen.qryCSVExport do
    begin
      sLine := EmptyStr;
      for nCount := 0 to Fields.Count - 1 do
        sLine := sLine + Fields[nCount].FieldName + ';';

      WriteLn(ExportFile, UTF8ToSys(sLine));

      while not EOF do
      begin
        sLine := EmptyStr;

        for nCount := 0 to Fields.Count - 1 do
          if (Fields[nCount].DataType = ftString) then
            sLine := sLine +  '"' +Fields[nCount].DisplayText + '";'
          else if (Fields[nCount].DataType in [ftDate, ftDateTime]) then
            sLine := sLine + FormatDateTime('dd.mm.yyyy', Fields[nCount].Value) + ';'
          else
            sLine := sLine + Fields[nCount].DisplayText + ';';

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

procedure TfrmMain.actFindExecute(Sender: TObject);
begin
  actAlle.Execute;
  dlgFindCompany.Execute;
end;

procedure TfrmMain.actIgnoreExecute(Sender: TObject);
begin
  dmBewerbungen.SetIgnoreState(grdBewerbungen.DataSource.DataSet.FieldByName('ID').AsInteger);
end;

procedure TfrmMain.actIgnoriertExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData('(CAST(IGNORIERT AS INTEGER) <> 0)');

  FGridFilter := 17;
end;

procedure TfrmMain.actInitiativExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsTYPD, [0]));

  FGridFilter := 9;
end;

procedure TfrmMain.actMailExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsMEDIUMD, [0]));

  FGridFilter := 12;
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
    if (not DataSource.DataSet.FieldByName('IGNORIERT').AsBoolean) and
      (DataSource.DataSet.FieldByName('FEEDBACK').AsInteger = 0) and
      (DataSource.DataSet.FieldByName('RESULT').AsInteger = 0) and
      (DataSource.DataSet.FieldByName('WVL').AsDateTime <= Date) then
      Canvas.Font.Color := clMaroon;

    // Bewerbung liegt mehr als 6 Wochen zurück und noch kein Ergebnis
    if FConfigFile.ReadBool('GENERAL', 'HIGHLIGHT OLD APPLICATIONS', false) and
      (DataSource.DataSet.FieldByName('FEEDBACK').AsInteger < 2) and
      (DataSource.DataSet.FieldByName('RESULT').AsInteger = 0) and
      (DataSource.DataSet.FieldByName('DATUM').AsDateTime <= IncWeek(Date, -6)) then
      Canvas.Font.Style := [fsBold];

    // Eingangsbestätigung liegt vor
    if (DataSource.DataSet.FieldByName('FEEDBACK').AsInteger = 1) and
      (DataSource.DataSet.FieldByName('RESULT').AsInteger = 0) then
      Canvas.Font.Color := clNavy;

    // Einladung liegt vor
    if (DataSource.DataSet.FieldByName('FEEDBACK').AsInteger = 2) and
      (DataSource.DataSet.FieldByName('RESULT').AsInteger = 0) then
      Canvas.Font.Color := clPurple;

    // Zusage erhalten
    if (DataSource.DataSet.FieldByName('RESULT').AsInteger = 1) then
      Canvas.Font.Color := clGreen;

    // Absage erhalten
    if (DataSource.DataSet.FieldByName('RESULT').AsInteger = 2) then
      Canvas.Font.Color := clRed;

    // Bewerbung zurückgezogen
    if (DataSource.DataSet.FieldByName('RESULT').AsInteger = 3) then
      Canvas.Font.Color := clGray;
  end;
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
  actWriteMail.Enabled := not (Length(dmBewerbungen.qryBewerbungen.FieldByName(
    'Mail').AsString) = 0);

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

