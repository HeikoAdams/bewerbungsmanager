unit login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    btnLogin: TBitBtn;
    leUserName: TLabeledEdit;
    lePassword: TLabeledEdit;
    procedure btnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
    if dmBewerbungen.qryBenutzer.Locate('NAME;PWD;ACTIVE', VarArrayOf([leUserName.Text, lePassword.Text, 1]), [loCaseInsensitive]) then
    begin
      frmMain.UserID:=dmBewerbungen.qryBenutzer.FieldByName('UID').AsInteger;
      frmLogin.Close;
    end
    else
    begin
      Inc(FLoginError);
      Application.MessageBox(PChar(rsFehler), PChar(rsUnknowUser), MB_ICONWARNING + MB_OK);
    end;
  end
  else
  begin
    Application.MessageBox(PChar(rsFehler), PChar(rsUnknowUser), MB_ICONWARNING + MB_OK);
    Application.Terminate;
  end;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  FLoginError := 0;
end;

end.

