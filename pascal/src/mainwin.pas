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

unit mainwin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DBDateTimePicker, Forms, Controls,
  Graphics, Dialogs, Grids, ComCtrls, ExtCtrls, StdCtrls, EditBtn,
  DBGrids, Menus, ActnList, IniFiles, DBCtrls, Buttons, CheckLst;

type

  { TfrmMain }
  TJobApplication = packed record
    ApplicationID: integer;
    Vermittler: integer;
    Befristet: integer;
    Ignoriert: integer;
    Feedback: integer;
    Result: integer;
    RefNr: string;
    JobTitel: string;
    Mail: string;
    Datum: TDateTime;
    BisDatum: TDateTime;
    WVL: TDateTime;
  end;

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
    actFilter: TAction;
    actOpen: TAction;
    actNewWVL: TAction;
    actSilent: TAction;
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
    cbbEmpfName: TDBLookupComboBox;
    cbbJobTitel: TDBLookupComboBox;
    cbFileType: TDBComboBox;
    cbbEmpfMail: TDBComboBox;
    cbbAnspr: TDBComboBox;
    chkBefristet: TDBCheckBox;
    chkComVerm: TDBCheckBox;
    chkIgnoriert: TDBCheckBox;
    chkVermittler: TDBCheckBox;
    chkAktiv: TDBCheckBox;
    chkNoReaction: TDBCheckBox;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBText1: TDBText;
    Label5: TLabel;
    memNotes: TDBMemo;
    edtFile: TDBEdit;
    DBGrid1: TDBGrid;
    dlgFindCompany: TFindDialog;
    cbbLogTyp: TDBComboBox;
    edtEnde: TDateEdit;
    edtName: TDBEdit;
    edtName1: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblFristEnde: TLabel;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    miNewWVL: TMenuItem;
    miFilter: TMenuItem;
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
    navFirmen: TDBNavigator;
    navJobs: TDBNavigator;
    pnlDokBottom: TPanel;
    pnlCompanyData: TPanel;
    pnlJobData: TPanel;
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
    tsJobs: TTabSheet;
    tsFirmen: TTabSheet;
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
    procedure actFilterExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actIgnoreExecute(Sender: TObject);
    procedure actIgnoriertExecute(Sender: TObject);
    procedure actInitiativExecute(Sender: TObject);
    procedure actMailExecute(Sender: TObject);
    procedure actNewWVLExecute(Sender: TObject);
    procedure actNoFeedbackExecute(Sender: TObject);
    procedure actNoResultExecute(Sender: TObject);
    procedure actOnlineFormExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actPostExecute(Sender: TObject);
    procedure actRevokeExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actSilentExecute(Sender: TObject);
    procedure actVermittlerExecute(Sender: TObject);
    procedure actVorschlagExecute(Sender: TObject);
    procedure actWriteMailExecute(Sender: TObject);
    procedure actWVLExecute(Sender: TObject);
    procedure actZusageExecute(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnFileOpenClick(Sender: TObject);
    procedure cbbEmpfNameEditingDone(Sender: TObject);
    procedure chkBefristetChange(Sender: TObject);
    procedure DBGrid1PrepareCanvas(Sender: TObject; DataCol: integer;
      Column: TColumn; AState: TGridDrawState);
    procedure DBGrid2PrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure dlgFindCompanyFind(Sender: TObject);
    procedure edtDatumEditingDone(Sender: TObject);
    procedure edtEndeEditingDone(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure grdBewerbungenDblClick(Sender: TObject);
    procedure grdBewerbungenPrepareCanvas(Sender: TObject; DataCol: integer;
      Column: TColumn; AState: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure grdLogDblClick(Sender: TObject);
    procedure navDataClick(Sender: TObject; Button: TDBNavButtonType);
    procedure pmFilterPopup(Sender: TObject);
  private
    { private declarations }
    FConfigDir: string;
    FDataFile: string;
    FErrorMsg: string;
    {$IFDEF Unix}
    FLinuxLaunch: string;
    FXDGPath: string;
    {$ENDIF}
    FLockFile: string;
    FConfigFile: TIniFile;

    FErrorCode: integer;
    FUserID: integer;
    {$IFDEF Unix}FLockHandle: integer;{$ENDIF}
    FGridFilter: word;
    FApplication: TJobApplication;
    procedure NotifyWVL;
    {$IFDEF Unix}procedure CreateDesktopFile();{$ENDIF}
  public
    { public declarations }
    property ConfigFile: TIniFile read FConfigFile;
    property UserID: Integer read FUserID write FUserID;
    property JobApplication: TJobApplication read FApplication write FApplication;
    procedure HandleError;
  end;

var
  frmMain: TfrmMain;

implementation

uses LCLType, dateutils, Data, bewerbung_strings, Process, variants,
  exportdate, settings, DB, sqldb, viewfilter {$IFDEF Unix}, baseunix{$ENDIF};

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.HandleError;
begin
  FErrorCode := GetLastOSError;
  FErrorMsg := SysErrorMessage(FErrorCode);

  Application.MessageBox(PChar(rsFehler), PChar(FErrorMsg), MB_ICONWARNING + MB_OK);
end;

procedure TfrmMain.NotifyWVL;
{$IFDEF Windows}
const
  LineEnding = CRLF;
{$endif}
var
  nCount: integer;
  sWVLs: string;
  sMessage: string;
begin
  with TSQLQuery.Create(nil) do
  begin
    DataBase := dmBewerbungen.conData;
    Transaction := dmBewerbungen.traData;

    with SQL do
    begin
      Add('SELECT NAME');
      Add('FROM COMPANIES JOIN BEWERBUNGEN ON COMPANIES.ID = BEWERBUNGEN.COMPANY');
      Add(Format('WHERE %s', [rsWHEREWVLSAND]));
      Add('AND (UID = :pUserID)');
    end;

    Params.ParamByName('pUserID').AsInteger:= frmMain.UserID;

    Open;
    nCount := RecordCount;

    First;
    sWVLs:=LineEnding + LineEnding;
    while not EOF do
    begin
      sWVLs := sWVLs + FieldByName('NAME').AsString + LineEnding;
      Next;
    end;

    Close;
    Free;
  end;

  if (nCount > 0) then
  begin
    sMessage := Format(rsEsBefindenSi, [nCount, sWVLs]);
    Application.MessageBox(PChar(sMessage), 'Wiedervorlage', MB_ICONWARNING + MB_OK);
  end;
end;

procedure TfrmMain.CreateDesktopFile();
var
  DesktopFile: TIniFile;
  DFName: string;
  HomeDir: string;
begin
  HomeDir := IncludeTrailingPathDelimiter(GetUserDir);
  DFName :=  Format('%s.local/share/applications/%s.desktop', [HomeDir, Application.Title]);

  if not FileExists(DFName) then
  begin
    DesktopFile := TIniFile.Create(DFName);

    with DesktopFile do
    begin
      WriteString('Desktop Entry', 'Version', '1.0');
      WriteString('Desktop Entry', 'Type', 'Application');
      WriteString('Desktop Entry', 'Name', Application.Title);
      WriteString('Desktop Entry', 'Comment', 'Software zur Verwaltung eigener Bewerbungen');
      WriteString('Desktop Entry', 'Exec', Application.ExeName);
      WriteString('Desktop Entry', 'Icon', 'accessories-text-editor');
      WriteString('Desktop Entry', 'Path', ExtractFilePath(Application.ExeName));
      WriteString('Desktop Entry', 'Categories', 'GTK;Office;ContactManagement;');
      WriteString('Desktop Entry', 'Terminal', 'false');
      WriteString('Desktop Entry', 'StartupNotify', 'true');
      UpdateFile;
    end;

    if (FpChmod(DFName, S_IRWXU or S_IRWXG or S_IROTH or S_IXOTH) <> 0) then
      Application.MessageBox(PChar(SysErrorMessage(GetLastOSError)),
        PChar(rsWarnung), MB_ICONWARNING + MB_OK)
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  sConfFileName: string;
  nCounter: integer;
begin
  {$IFDEF Windows}
  FConfigDir := ExtractFilePath(Application.ExeName);
  sConfFileName := StringReplace(GetAppConfigFile(False, True),
    GetAppConfigDir(False), FConfigDir, [rfIgnoreCase, rfReplaceAll]);
  {$else}
  FConfigDir := GetAppConfigDir(False);
  sConfFileName := GetAppConfigFile(False, True);
  {$endif}

  if not DirectoryExists(FConfigDir) then
    if not CreateDir(FConfigDir) then
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
  FXDGPath := FConfigFile.ReadString('LINUX', 'XDG-PATH', '/usr/bin');
  {$ENDIF}

  FGridFilter := FConfigFile.ReadInteger('FILTER', 'LAST FILTER', 15);

  for nCounter := 0 to alFilter.ActionCount - 1 do
    if alFilter.Actions[nCounter].Tag = FGridFilter then
    begin
      alFilter.Actions[nCounter].Execute;
      Break;
    end;

  PageControl1.ActivePageIndex := 0;

  {$IFDEF Unix}
  CreateDesktopFile;
  {$ENDIF}
end;

procedure TfrmMain.actNoFeedbackExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsFEEDBACKDR, [0, 0]));

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

procedure TfrmMain.actOpenExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(rsRESULT3);

  FGridFilter := 19;
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

procedure TfrmMain.actSilentExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format(rsRESULTD, [4]));

  FGridFilter := 106;
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
  if (JobApplication.RefNr <> EmptyStr) then
    sSubject := Format(rsMeineBewerbu,
      [FormatDateTime(rsDateFormat, JobApplication.Datum), JobApplication.JobTitel,
      JobApplication.RefNr])
  else
    sSubject := Format(rsMeineBewerbu2,
      [FormatDateTime(rsDateFormat, JobApplication.Datum), JobApplication.JobTitel]);

  sCommand := Format(rsMailtoS, [JobApplication.Mail, sSubject]);

  { TODO 1 : Shell-Execute Code zum Erstellen einer Mail unter Windows einfügen }
  {$IFDEF Unix}
  with TProcess.Create(nil) do
  begin
    CommandLine := Format(rsUsrBinXdgOpe, [FXDGPath, sCommand]);
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
  dlgDocuments.InitialDir := ConfigFile.ReadString('GENERAL', 'DOC DIR', GetUserDir);

  if dlgDocuments.Execute then
    dmBewerbungen.qryDocuments.FieldByName('FILENAME').AsString := dlgDocuments.FileName;
end;

procedure TfrmMain.btnFileOpenClick(Sender: TObject);
begin
  { TODO 1 : Shell-Execute Code zum Öffnen der Dokumente unter Windows einfügen }
  {$IFDEF Unix}
  with TProcess.Create(nil) do
  begin
    CommandLine := Format(FLinuxLaunch, [edtFile.Text]);
    Options := Options + [poWaitOnExit];
    Execute;
    Free;
  end;
  {$endif}
end;

procedure TfrmMain.cbbEmpfNameEditingDone(Sender: TObject);
var
  sNote: string;
  bewerbungen: TSQLQuery;
  companies: TSQLQuery;
begin
  bewerbungen := dmBewerbungen.qryBewerbungen;
  companies := dmBewerbungen.qryCompanies;

  if (bewerbungen.State in dsWriteModes) then
  begin
    if companies.Locate('ID', (Sender as TDBLookupComboBox).KeyValue, []) then
      if not companies.FieldByName('AKTIV').AsBoolean then
      begin
        Application.MessageBox(PChar(rsInaktiveFirma), PChar(rsWarnung), MB_ICONWARNING + MB_OK);
        (Sender as TDBLookupComboBox).KeyValue := 0;
        Exit;
      end;

      if companies.FieldByName('VERMITTLER').AsBoolean then
      begin
        bewerbungen.FieldByName('VERMITTLER').AsInteger:= companies.FieldByName('VERMITTLER').AsInteger;
        Application.MessageBox(PChar(rsPersonalvermittler), PChar(rsWarnung), MB_ICONWARNING + MB_OK);
        if frmMain.ConfigFile.ReadBool('GENERAL', 'IGNOREPV', False) then
          bewerbungen.FieldByName('IGNORIERT').AsInteger:=1;
      end
      else
      begin
        bewerbungen.FieldByName('VERMITTLER').AsInteger:= 0;
        bewerbungen.FieldByName('IGNORIERT').AsInteger:=0;
      end;

      if companies.FieldByName('NOREACTION').AsBoolean then
        Application.MessageBox(PChar(rsNoReaction), PChar(rsWarnung), MB_ICONWARNING + MB_OK);

      sNote := companies.FieldByName('NOTES').AsString;
      if (sNote <> EmptyStr) then
        Application.MessageBox(PChar(sNote), PChar(rsWarnung), MB_ICONASTERISK + MB_OK);
  end;
end;

procedure TfrmMain.chkBefristetChange(Sender: TObject);
begin
  if (dmBewerbungen.qryBewerbungen.State in dsWriteModes) then
  begin
    if frmMain.ConfigFile.ReadBool('GENERAL', 'IGNOREPV', False) then
      if dmBewerbungen.qryBewerbungen.FieldByName('BEFRISTET').AsBoolean then
        dmBewerbungen.qryBewerbungen.FieldByName('IGNORIERT').AsInteger:=1;
  end;
end;

procedure TfrmMain.DBGrid1PrepareCanvas(Sender: TObject; DataCol: integer;
  Column: TColumn; AState: TGridDrawState);
begin
  with (Sender as TDBGrid) do
  begin
    btnFileOpen.Enabled := FileExists(DataSource.DataSet.FieldByName(
      'FILENAME').AsString);

    if not btnFileOpen.Enabled then
    begin
      Canvas.Font.Color := clMaroon;
      Canvas.Font.Style := [fsBold];
    end;
  end;
end;

procedure TfrmMain.DBGrid2PrepareCanvas(sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
  with (Sender as TDBGrid) do
  begin
    if DataSource.DataSet.FieldByName('VERMITTLER').AsBoolean then
      Canvas.Font.Color := clMaroon;

    if DataSource.DataSet.FieldByName('NOREACTION').AsBoolean then
      Canvas.Font.Color := clRed;

    if not DataSource.DataSet.FieldByName('AKTIV').AsBoolean then
      Canvas.Font.Style := [fsItalic];

    if (DataSource.DataSet.FieldByName('NOTES').AsString <> EmptyStr) or
      DataSource.DataSet.FieldByName('VERMITTLER').AsBoolean then
      Canvas.Font.Style := [fsBold];
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
  if not dmBewerbungen.qryCompanies.Locate('NAME',
    VarArrayOf([dlgFindCompany.FindText]), [loCaseInsensitive, loPartialKey]) then
    if not dmBewerbungen.qryBewerbungen.Locate('REFNR',
      VarArrayOf([dlgFindCompany.FindText]), [loPartialKey]) then
        Application.MessageBox(PChar(rsKeineBereins), PChar(rsSuche),
          MB_OK + MB_ICONWARNING)
  else
  begin
    dmBewerbungen.qryBewerbungen.Locate('COMPANY', dmBewerbungen.qryCompanies.FieldByName('ID').AsInteger,[]);
    dlgFindCompany.CloseDialog;
  end;
end;

procedure TfrmMain.edtDatumEditingDone(Sender: TObject);
begin
  if (dmBewerbungen.dsData.State in dsWriteModes) and (edtWVL.Text <> '  .  .    ')
    and (edtDatum.Date <> JobApplication.Datum) then
     if (Application.MessageBox(PChar(rsRecalcWVL), PChar(rsWVL), MB_YESNO or
        MB_DEFBUTTON2 or MB_ICONQUESTION) = ID_YES) then
        if (edtEnde.Text <> '  .  .    ') then
          edtWVL.Date := IncDay(edtEnde.Date, ConfigFile.ReadInteger('DEFAULTS', 'WVL', 14))
        else
          edtWVL.Date := IncDay(edtWVL.Date, ConfigFile.ReadInteger('DEFAULTS', 'WVL', 14));
  (Sender as TDateEdit).ValidateEdit;
end;

procedure TfrmMain.edtEndeEditingDone(Sender: TObject);
begin
  if (dmBewerbungen.dsData.State in [dsInsert, dsEdit]) and (edtEnde.Text <> '  .  .    ')
    and (edtEnde.Date <> JobApplication.BisDatum) then
      edtWVL.Date := IncDay(edtEnde.Date, ConfigFile.ReadInteger('DEFAULTS', 'WVL', 14));
  (Sender as TDateEdit).ValidateEdit;
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

    WriteInteger('FILTER', 'LAST FILTER', FGridFilter);

    {$IFDEF Unix}
    WriteString('LINUX', 'XDG-PATH', FXDGPath);
    {$ENDIF}

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
  sDateFrom, sDateDue: string;
  dtDateFrom, dtDateDue: TDateTime;
  nRecordCount: integer;
begin
  dtDateFrom := date;
  dtDateDue := date;

  Application.CreateForm(TfrmExportDate, frmExportDate);

  if (frmExportDate.ShowModal = mrAbort) then
  begin
    FreeAndNil(frmExportDate);
    Exit;
  end;

  frmExportDate.GetDateRange(dtDateFrom, dtDateDue);

  if (dtDateFrom > date) or (dtDateDue > Endofthemonth(date)) then
  begin
    Application.MessageBox(PChar(rsDateInFuture), PChar(rsCSVExport),
      MB_ICONINFORMATION + MB_OK);
    FreeAndNil(frmExportDate);
    exit;
  end;

  dlgExport.InitialDir := GetUserDir;

  if dlgExport.Execute then
  begin
    sFileName := dlgExport.FileName;

    frmExportDate.GetDateRangeTxt(sDateFrom, sDateDue);
    FreeAndNil(frmExportDate);
    AssignFile(ExportFile, sFileName);
    dmBewerbungen.FetchExportData('WHERE (UID = :pUserID) AND (strftime(''%s'', DATUM)' +
      Format(' BETWEEN %s AND %s', [sDateFrom, sDateDue]) +')');
    nRecordCount := dmBewerbungen.qryCSVExport.RecordCount;

    if (nRecordCount = 0) then
    begin
      Application.MessageBox(PChar(rsNoExportData), PChar(rsCSVExport),
        MB_ICONINFORMATION + MB_OK);
      exit;
    end;

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
            sLine := sLine + '"' + Fields[nCount].DisplayText + '";'
          else if (Fields[nCount].DataType in [ftDate, ftDateTime]) then
            if (Fields[nCount].Value > 0) then
              sLine := sLine + FormatDateTime('dd.mm.yyyy', Fields[nCount].Value) + ';'
            else
              sLine := sLine + ';'
          else
            sLine := sLine + Fields[nCount].DisplayText + ';';

        WriteLn(ExportFile, UTF8ToSys(sLine));
        Next;
      end;

      Close;
    end;

    CloseFile(ExportFile);

    Application.MessageBox(PChar(Format(rsExportBeende, [nRecordCount])),
      PChar(rsCSVExport),
      MB_ICONINFORMATION + MB_OK);
  end;
end;

procedure TfrmMain.actFilterExecute(Sender: TObject);
var
  dtDateFrom, dtDateDue: TDate;
begin
  dtDateFrom := date;
  dtDateDue := date;

  Application.CreateForm(TfrmViewFilter, frmViewFilter);

  if (frmViewFilter.ShowModal = mrAbort) then
  begin
    FreeAndNil(frmViewFilter);
    Exit;
  end;

  frmViewFilter.GetDateRange(dtDateFrom, dtDateDue);
  FreeAndNil(frmViewFilter);

  dmBewerbungen.FetchData(Format('(DATUM >= %d) AND (DATUM <= %d)',
    [trunc(dtDateFrom), trunc(dtDateDue)]));

  FGridFilter := 18;
end;

procedure TfrmMain.actFindExecute(Sender: TObject);
begin
  actAlle.Execute;
  dlgFindCompany.Execute;
end;

procedure TfrmMain.actIgnoreExecute(Sender: TObject);
begin
  dmBewerbungen.SetIgnoreState(grdBewerbungen.DataSource.DataSet.FieldByName(
    'ID').AsInteger);
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

procedure TfrmMain.actNewWVLExecute(Sender: TObject);
var
  nID: integer;
  nDays: integer;
begin
  nDays := FConfigFile.ReadInteger('DEFAULTS', 'WVL', 14);
  nID := JobApplication.ApplicationID;
  dmBewerbungen.UpdateWVL(nID, nDays);
end;

procedure TfrmMain.grdBewerbungenDblClick(Sender: TObject);
begin
  dmBewerbungen.qryBewerbungen.Edit;
end;

procedure TfrmMain.grdBewerbungenPrepareCanvas(Sender: TObject;
  DataCol: integer; Column: TColumn; AState: TGridDrawState);
var
  bIgnoriert: boolean;
  CurrApp: TDataSet;
begin
  with (Sender as TDBGrid) do
  begin
    CurrApp := DataSource.DataSet;
    bIgnoriert := (CurrApp.FieldByName('IGNORIERT').AsInteger = 1);

    // Ignorierte Bewerbungen
    if bIgnoriert then
      Canvas.Font.Style := [fsItalic]
    // Kein Feedback und WVL-Termin überschritten
    else if (CurrApp.FieldByName('FEEDBACK').AsInteger = 0) and
      (CurrApp.FieldByName('RESULT').AsInteger in [0, 4]) and
      (CurrApp.FieldByName('WVL').AsDateTime <= Date) then
    begin
      Canvas.Font.Color := clMaroon;
      Canvas.Font.Style := [fsBold];
    end;

    // Bewerbung liegt mehr als 6 Wochen zurück und noch kein Ergebnis
    if FConfigFile.ReadBool('GENERAL', 'HIGHLIGHT OLD APPLICATIONS', False) and
      (CurrApp.FieldByName('FEEDBACK').AsInteger in [0, 1]) and
      (CurrApp.FieldByName('RESULT').AsInteger in [0, 4]) and
      (CurrApp.FieldByName('DATUM').AsDateTime <= IncWeek(Date, -6)) then
      Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];

    case CurrApp.FieldByName('RESULT').AsInteger of
      0:
        begin
          if (CurrApp.FieldByName('FEEDBACK').AsInteger = 1) and
            (CurrApp.FieldByName('WVL').AsDateTime >= Date) then
            Canvas.Font.Color := clNavy    // Eingangsbestätigung liegt vor und WVL ist noch nicht überschritten
          else if (CurrApp.FieldByName('FEEDBACK').AsInteger = 2) then
            Canvas.Font.Color := clPurple; // Einladung liegt vor
        end;
      1: Canvas.Font.Color := clGreen; // Zusage erhalten
      2: Canvas.Font.Color := clRed;   // Absage erhalten
      3: Canvas.Font.Color := clGray;  // Bewerbung zurückgezogen
      4: Canvas.Font.Color := clTeal;  // keine Antwort auf Nachfragen
    end
  end;
end;

procedure TfrmMain.grdLogDblClick(Sender: TObject);
begin
  if (dmBewerbungen.qryBewerbungen.State = dsEdit) then
    dmBewerbungen.qryLog.Edit;
end;

procedure TfrmMain.navDataClick(Sender: TObject; Button: TDBNavButtonType);
begin
  frmMain.PageControl1.ActivePageIndex := 1;
end;

procedure TfrmMain.pmFilterPopup(Sender: TObject);
var
  nCount, nCount2: integer;
  TempItem: TMenuItem;
  bItemEnabled: boolean;
begin
  actWriteMail.Enabled := not (Length(JobApplication.Mail) = 0);
  bItemEnabled := (dmBewerbungen.qryBewerbungen.RecordCount > 0);

  for nCount := 0 to pmFilter.Items.Count - 1 do
  begin
    TempItem := pmFilter.Items[nCount];

    if bItemEnabled then
    begin
      if (TempItem.Count > 0) then
      begin
        for nCount2 := 0 to TempItem.Count - 1 do
          TempItem.Items[nCount2].Checked :=
            (TempItem.Items[nCount2].Tag = FGridFilter) and
            (TempItem.Items[nCount2].Tag < 100);
      end
      else
        TempItem.Checked := (TempItem.Tag = FGridFilter) and (TempItem.Tag < 100);
    end
    else
    begin
      if not (TempItem.Action = actSettings) then
        TempItem.Enabled := bItemEnabled;
    end;
  end;
end;

end.
