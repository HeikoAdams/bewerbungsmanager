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

unit newuser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons;

type

  { TfrmNewUser }

  TfrmNewUser = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    leUsername: TLabeledEdit;
    lePassword: TLabeledEdit;
    lePassword2: TLabeledEdit;
    procedure btnOKClick(Sender: TObject);
    procedure lePassword2Exit(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmNewUser: TfrmNewUser;

implementation

uses data, md5, bewerbung_strings, variants, db, LCLType, sqldb;

{$R *.lfm}

{ TfrmNewUser }

procedure TfrmNewUser.btnOKClick(Sender: TObject);
begin
  if dmBewerbungen.qryBenutzer.Locate('NAME', VarArrayOf([leUserName.Text]), [loCaseInsensitive]) then
  begin
    Application.MessageBox(PChar(rsUserExists), PChar(rsFehler), MB_ICONWARNING + MB_OK);
    ModalResult:=mrNone;
    Exit;
  end
  else
  begin
    with TSQLQuery.Create(self) do
    begin
      DataBase := dmBewerbungen.conData;
      Transaction := dmBewerbungen.traData;

      with SQL do
      begin
        Add('INSERT INTO BENUTZER(NAME, PWD, ACTIVE)');
        Add('SELECT :pName, :pPassword, 1')
      end;

      with Params do
      begin
        Clear;
        ParseSQL(SQL.Text, True);

        ParamValues['pName'] := leUserName.Text;
        ParamValues['pPassword'] := MD5Print(MD5String(lePassword.Text));
      end;

      ExecSQL;
      Free;
    end;

    with dmBewerbungen do
    begin
      traData.Commit;
      qryBenutzer.Close;
      qryBenutzer.Open;
    end;
    ModalResult:=mrOK;
  end;
end;

procedure TfrmNewUser.lePassword2Exit(Sender: TObject);
begin
  btnOK.Enabled:=((leUsername.Text <> EmptyStr) and (lePassword.Text <> EmptyStr)
    and (lePassword.Text = lePassword2.Text));
end;

end.

