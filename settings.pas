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

unit settings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DbCtrls, ExtCtrls, Buttons, EditBtn;

type

  { TfrmSettings }

  TfrmSettings = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    chkNotifyWVL: TCheckBox;
    GroupBox1: TGroupBox;
    rgMedium: TDBRadioGroup;
    rgTyp: TRadioGroup;
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
  chkNotifyWVL.Checked := frmMain.ConfigFile.ReadBool('GENERAL', 'NOTIFY-WVL', TRUE);
  rgTyp.ItemIndex := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'TYP', 1);
  rgMedium.ItemIndex := frmMain.ConfigFile.ReadInteger('DEFAULTS', 'MEDIUM', 0);
end;

procedure TfrmSettings.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  if (ModalResult = mrOK) then
  begin
    frmMain.ConfigFile.WriteBool('GENERAL', 'NOTIFY-WVL', chkNotifyWVL.Checked);
    frmMain.ConfigFile.WriteInteger('DEFAULTS', 'TYP', rgTyp.ItemIndex);
    frmMain.ConfigFile.WriteInteger('DEFAULTS', 'MEDIUM', rgMedium.ItemIndex);

    Application.MessageBox(PChar(rsDieNderungen), PChar(rsEinstellunge),
      MB_ICONWARNING + MB_OK);
  end;
end;

end.

