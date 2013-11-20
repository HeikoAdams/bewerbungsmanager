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

unit settings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBCtrls, ExtCtrls, Buttons, EditBtn, Spin;

type

  { TfrmSettings }

  TfrmSettings = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    chkNewWVL: TCheckBox;
    chkOldApplications: TCheckBox;
    chkNotifyWVL: TCheckBox;
    edtDocsDir: TDirectoryEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    rgMedium: TDBRadioGroup;
    rgTyp: TRadioGroup;
    edtWVLTage: TSpinEdit;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

uses mainwin, LCLType, bewerbung_strings;

{$R *.lfm}

{ TfrmSettings }

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  with frmMain.ConfigFile do
  begin
       chkNotifyWVL.Checked := ReadBool('GENERAL', 'NOTIFY-WVL', True);
       rgTyp.ItemIndex := ReadInteger('DEFAULTS', 'TYP', 1);
       rgMedium.ItemIndex := ReadInteger('DEFAULTS', 'MEDIUM', 0);
       edtWVLTage.Value := ReadInteger('DEFAULTS', 'WVL', 14);
       chkOldApplications.Checked := ReadBool('GENERAL', 'HIGHLIGHT OLD APPLICATIONS', false);
       edtDocsDir.Directory := ReadString('GENERAL', 'DOC DIR', GetUserDir);
       chkNewWVL.Checked := ReadBool('GENERAL', 'MODIFY-APPLICATION-RESULT', True);
  end;
end;

procedure TfrmSettings.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if (ModalResult = mrOk) then
  begin
    with frmMain.ConfigFile do
    begin
         WriteBool('GENERAL', 'NOTIFY-WVL', chkNotifyWVL.Checked);
         WriteBool('GENERAL', 'MODIFY-APPLICATION-RESULT', chkNewWVL.Checked);
         WriteInteger('DEFAULTS', 'TYP', rgTyp.ItemIndex);
         WriteInteger('DEFAULTS', 'MEDIUM', rgMedium.ItemIndex);
         WriteInteger('DEFAULTS', 'WVL', edtWVLTage.Value);
         WriteBool('GENERAL', 'HIGHLIGHT OLD APPLICATIONS', chkOldApplications.Checked);
         WriteString('GENERAL', 'DOC DIR', edtDocsDir.Directory);
         UpdateFile;
    end;

    Application.MessageBox(PChar(rsDieNderungen), PChar(rsEinstellunge),
      MB_ICONWARNING + MB_OK);
  end;
end;

end.

