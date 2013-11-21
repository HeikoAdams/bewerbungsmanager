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

unit filterdate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  EditBtn, StdCtrls;

type

  { TfrmDateFilter }

  TfrmDateFilter = class(TForm)
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
    procedure GetDateRange(var aDateFrom, aDateDue: TDateTime);
    procedure GetDateRangeTxt(var aDateFrom, aDateDue: String);
  end; 

var
  frmDateFilter: TfrmDateFilter;

implementation

uses dateutils;

{$R *.lfm}

{ TfrmDateFilter }

procedure TfrmDateFilter.Button1Click(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TfrmDateFilter.Button2Click(Sender: TObject);
begin
  ModalResult:=mrAbort;
end;

procedure TfrmDateFilter.FormCreate(Sender: TObject);
begin
  edtDateFrom.Date:=StartOfTheMonth(Date);
  edtDateDue.Date:=EndOfTheMonth(Date);
end;

procedure TfrmDateFilter.GetDateRange(var aDateFrom, aDateDue: TDateTime);
begin
  aDateFrom := edtDateFrom.Date;
  aDateDue := edtDateDue.Date;
end;

procedure TfrmDateFilter.GetDateRangeTxt(var aDateFrom, aDateDue: String);
begin
  aDateFrom := edtDateFrom.Text;
  aDateDue := edtDateDue.Text;
end;

end.

