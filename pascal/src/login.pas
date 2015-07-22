unit login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    btnLogin: TBitBtn;
    Label1: TLabel;
    lePassword: TLabeledEdit;
    cbUserName: TComboBox;
    SpeedButton1: TSpeedButton;
    procedure btnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbUserNameChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
    FLoginError: Integer;
  public
    { public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses data, mainwin, variants, db, bewerbung_strings, LCLType, md5, newuser;

{$R *.lfm}

{ TfrmLogin }

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  if (FLoginError <= 3) then
  begin
    if dmBewerbungen.qryBenutzer.Locate('NAME;PWD;ACTIVE', VarArrayOf([cbUserName.Text,
      MD5Print(MD5String(lePassword.Text)), 1]), [loCaseInsensitive]) then
    begin
      frmMain.UserID:=dmBewerbungen.qryBenutzer.FieldByName('UID').AsInteger;
      frmLogin.Close;
    end
    else
    begin
      Inc(FLoginError);
      Application.MessageBox(PChar(rsUnknowUser), PChar(rsFehler), MB_ICONWARNING + MB_OK);
    end;
  end
  else
  begin
    Application.MessageBox(PChar(rsTooManyLogin), PChar(rsFehler), MB_ICONWARNING + MB_OK);
    Application.Terminate;
  end;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  FLoginError := 0;
end;

procedure TfrmLogin.cbUserNameChange(Sender: TObject);
begin
  btnLogin.Enabled:=(Length(cbUserName.Text) > 0);
end;

procedure TfrmLogin.SpeedButton1Click(Sender: TObject);
begin
  Application.CreateForm(TfrmNewUser, frmNewUser);
  if (frmNewUser.ShowModal = mrOK) then
    cbUserName.Items.Add(frmNewUser.leUsername.Text);
end;

end.

