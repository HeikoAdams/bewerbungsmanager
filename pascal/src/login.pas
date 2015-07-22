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
    procedure btnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbUserNameChange(Sender: TObject);
  private
    { private declarations }
    FLoginError: Integer;
  public
    { public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses data, mainwin, variants, db, bewerbung_strings, LCLType;

{$R *.lfm}

{ TfrmLogin }

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  if (FLoginError <= 3) then
  begin
    if dmBewerbungen.qryBenutzer.Locate('NAME;PWD;ACTIVE', VarArrayOf([cbUserName.Text, lePassword.Text, 1]), [loCaseInsensitive]) then
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

end.

