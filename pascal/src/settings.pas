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
    chkIgnorePV: TCheckBox;
    chkPurgeData: TCheckBox;
    chkNewWVL: TCheckBox;
    chkNotifyWVL: TCheckBox;
    chkOldApplications: TCheckBox;
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
       chkPurgeData.Checked:= ReadBool('GENERAL', 'PURGE-DATA', False);
       chkIgnorePV.Checked:= ReadBool('GENERAL','IGNOREPV', False);
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
         WriteBool('GENERAL', 'PURGE-DATA', chkPurgeData.Checked);
         WriteInteger('DEFAULTS', 'TYP', rgTyp.ItemIndex);
         WriteInteger('DEFAULTS', 'MEDIUM', rgMedium.ItemIndex);
         WriteInteger('DEFAULTS', 'WVL', edtWVLTage.Value);
         WriteBool('GENERAL', 'HIGHLIGHT OLD APPLICATIONS', chkOldApplications.Checked);
         WriteString('GENERAL', 'DOC DIR', edtDocsDir.Directory);
         WriteBool('GENERAL','IGNOREPV', chkIgnorePV.Checked);
         UpdateFile;
    end;

    Application.MessageBox(PChar(rsDieNderungen), PChar(rsEinstellunge),
      MB_ICONWARNING + MB_OK);
  end;
end;

end.

