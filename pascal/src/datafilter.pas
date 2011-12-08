unit datafilter; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, exportdate; 

type
  TfrmFilterDate = class(TfrmExportDate)
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmFilterDate: TfrmFilterDate;

implementation

{$R *.lfm}

end.

