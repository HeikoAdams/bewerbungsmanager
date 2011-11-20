program bewerbungen;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, bewerbung_strings, Data, exportdate, mainwin, settings;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmBewerbungen, dmBewerbungen);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

