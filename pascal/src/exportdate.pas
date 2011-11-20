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

