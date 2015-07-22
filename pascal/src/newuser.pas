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

    dmBewerbungen.traData.Commit;
    dmBewerbungen.qryBenutzer.Close;
    dmBewerbungen.qryBenutzer.Open;
    ModalResult:=mrOK;
  end;
end;

procedure TfrmNewUser.lePassword2Exit(Sender: TObject);
begin
  btnOK.Enabled:=((leUsername.Text <> EmptyStr) and (lePassword.Text <> EmptyStr)
    and (lePassword.Text = lePassword2.Text));
end;

end.

