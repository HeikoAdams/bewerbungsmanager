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
    chkOldApplications: TCheckBox;
    chkNotifyWVL: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
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
  chkNotifyWVL.Checked := frmMain.ConfigFile.ReadBool('GENERAL', 'NOTIFY-WVL', True);
  rgTyp.ItemIndex := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'TYP', 1);
  rgMedium.ItemIndex := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'MEDIUM', 0);
  edtWVLTage.Value := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'WVL', 14);
  chkOldApplications.Checked := frmMain.ConfigFile.ReadBool('GENERAL', 'HIGHLIGHT OLD APPLICATIONS', false);
end;

procedure TfrmSettings.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if (ModalResult = mrOk) then
  begin
    frmMain.ConfigFile.WriteBool('GENERAL', 'NOTIFY-WVL', chkNotifyWVL.Checked);
    frmMain.ConfigFile.WriteInteger('DEFAULTS', 'TYP', rgTyp.ItemIndex);
    frmMain.ConfigFile.WriteInteger('DEFAULTS', 'MEDIUM', rgMedium.ItemIndex);
    frmMain.ConfigFile.WriteInteger('DEFAULTS', 'WVL', edtWVLTage.Value);
    frmMain.ConfigFile.WriteBool('GENERAL', 'HIGHLIGHT OLD APPLICATIONS', chkOldApplications.Checked);

    Application.MessageBox(PChar(rsDieNderungen), PChar(rsEinstellunge),
      MB_ICONWARNING + MB_OK);
  end;
end;

end.

