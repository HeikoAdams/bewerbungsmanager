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

unit mainwin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, DB, sqlite3conn, sqldb, FileUtil, Forms, Controls,
  Graphics, Dialogs, Grids, ComCtrls, ExtCtrls, StdCtrls, EditBtn,
  DBGrids, Menus, ActnList, IniFiles, DBCtrls, Buttons;

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
    edtFile: TDBEdit;
    DBGrid1: TDBGrid;
    miAlleNoAbsagen: TMenuItem;
    MenuItem4: TMenuItem;
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
    tsDokumente: TTabSheet;
    tsActions: TTabSheet;
    tsBewerbungData: TTabSheet;
    tsBewerbungen: TTabSheet;
    procedure actAbsageExecute(Sender: TObject);
    procedure actAlleExecute(Sender: TObject);
    procedure actAllNoAbsageExecute(Sender: TObject);
    procedure actAngebotExecute(Sender: TObject);
    procedure actEingangExecute(Sender: TObject);
    procedure actEinladungExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure actInitiativExecute(Sender: TObject);
    procedure actMailExecute(Sender: TObject);
    procedure actNoFeedbackExecute(Sender: TObject);
    procedure actNoResultExecute(Sender: TObject);
    procedure actOnlineFormExecute(Sender: TObject);
    procedure actPostExecute(Sender: TObject);
    procedure actVermittlerExecute(Sender: TObject);
    procedure actVorschlagExecute(Sender: TObject);
    procedure actWVLExecute(Sender: TObject);
    procedure actZusageExecute(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnFileOpenClick(Sender: TObject);
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

implementation

uses LCLType, dateutils, Data, bewerbung_strings, Process;

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

  dmBewerbungen.FetchData(rsRESULT2);

  FGridFilter := 15;
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

procedure TfrmMain.actWVLExecute(Sender: TObject);
begin
  dmBewerbungen.FetchData(Format('(WVL <= %s) AND (FEEDBACK = 0) AND (RESULT = 0)',
    [FloatToStr(date)]));

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

procedure TfrmMain.btnFileOpenClick(Sender: TObject);
begin
  { TODO 1 : Shell-Execute Code zum Öffnen der Dokumente unter Windows einfügen }
  {$IFDEF Unix}
  with TProcess.Create(nil) do
  begin
    CommandLine := Format(rsUnixLauncher, [edtFile.Text]);
    Options := Options + [poWaitOnExit];
    Execute;
    Free;
  end;
  {$endif}
  {$IFDEF Windows}

  {$endif}
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

