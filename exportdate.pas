unit exportdate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtDlgs,
  EditBtn, StdCtrls;

type

  { TfrmExportDate }

  TfrmExportDate = class(TForm)
    Button1: TButton;
    Button2: TButton;
    edtDateFrom: TDateEdit;
    edtDateDue: TDateEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure GetDateRange(var aDateFrom, aDateDue: TDate);
  end; 

var
  frmExportDate: TfrmExportDate;

implementation

uses dateutils;

{$R *.lfm}

{ TfrmExportDate }

procedure TfrmExportDate.Button1Click(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TfrmExportDate.Button2Click(Sender: TObject);
begin
  ModalResult:=mrAbort;
end;

procedure TfrmExportDate.FormCreate(Sender: TObject);
begin
  edtDateFrom.Date:=StartOfTheMonth(Date);
  edtDateDue.Date:=EndOfTheMonth(Date);
end;

procedure TfrmExportDate.GetDateRange(var aDateFrom, aDateDue: TDate);
begin
  aDateFrom := edtDateFrom.Date;
  aDateDue := edtDateDue.Date;
end;

end.

