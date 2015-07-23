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
  aDateFrom := 'strftime(''%s'',''' + FormatDateTime('yyyy-mm-dd',edtDateFrom.Date) + ''')';
  aDateDue := 'strftime(''%s'',''' + FormatDateTime('yyyy-mm-dd',edtDateDue.Date) + ''')';
end;

end.

