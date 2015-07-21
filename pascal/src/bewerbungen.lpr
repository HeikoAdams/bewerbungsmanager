program bewerbungen;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, bewerbung_strings, Data, mainwin, settings, filterdate, exportdate,
  viewfilter, login;

{$R *.res}

begin
  Application.Title:='Bewerbungsmanager';
  Application.Initialize;
  Application.CreateForm(TdmBewerbungen, dmBewerbungen);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

