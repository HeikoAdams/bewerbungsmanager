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

unit bewerbung_strings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

const
  nVersion = 190;
  nInitVer = 100; //Konstante für die Initialisierung der Datenbank. NICHT ÄNDERN!
  {$IFDEF Windows}CRLF = #13#10;{$endif}

resourcestring
  rsACTION = 'ACTION';
  rsCOMPANIES = 'COMPANIES';
  rsCSVExport = 'CSV-Export';
  rsDasProgrammW = 'Das Programm wird bereits ausgeführt!';
  rsDatenbankSKo = 'Datenbank (%s) konnte nicht gefunden werden!';
  rsDDatensTze = '%d Datensätze in der Datenbank';
  rsDieNderungen = 'Die Änderungen werden zum Teil erst nach einem Neustart '
    +'wirksam!';
  rsEinstellunge = 'Einstellungen';
  rsEsBefindenSi = 'Es befinden sich aktuell %d Bewerbung(en) in der '
    +'Wiedervorlage: %s';
  rsExportBeende = 'Export beendet. Es wurden %d Datensätze exportiert';
  rsNoExportData = 'In dem angegebenen Zeitraum existieren keine Daten, '+
    'die exportiert werden können';
  rsDateInFuture = 'Der Exportzeitraum darf nicht in der Zukunft liegen';
  rsFEEDBACKD = '(FEEDBACK = %d)';
  rsFehler = 'Fehler';
  rsDateFormat = 'dd.mm.yyyy';
  rsJOBS = 'JOBS';
  rsKeineBereins = 'keine Übereinstimmung gefunden';
  rsMailtoS = 'mailto:%s?subject=%s';
  rsMEDIUMD = '(MEDIUM = %d)';
  rsMAILS = 'MAILS';
  rsMeineBewerbu = 'Meine Bewerbung vom %s als %s (Ref.Nr. %s)';
  rsMeineBewerbu2 = 'Meine Bewerbung vom %s als %s';
  rsRECEIPENTS = 'RECEIPENTS';
  rsRESULT2 = '(RESULT <> 2)';
  rsRESULTD = '(RESULT = %d)';
  rsRESULT3 = '(RESULT IN (0,4))';
  rsSuche = 'Suche';
  rsTYPD = '(TYP = %d)';
  {$IFDEF Unix}rsUsrBinXdgOpe = '%s/xdg-open "%s"';{$ENDIF}
  rsWarnung = 'Warnung';
  rsWERT = 'WERT';
  rsWHEREWVLSAND = '(((Date(WVL) <= Date(''now'')) AND (RESULT IN (0,4)))) AND (IGNORIERT = 0)';
  rsNewWVL = 'WVL verlängert';
  rsNewWVLTxt = 'Datum der Wiedervorlage neu gesetzt';
  rsIgnored = 'Ignoriert';
  rsIgnoredTxt = 'Status der Bewerbung auf "Ignoriert" geändert';
  rsRecalcWVL = 'Soll das Wiedervolagedatum neu berechnet werden?';
  rsWVL = 'Wiedervolage';
  rsUnknowUser = 'Der angegebene Benutzer existiert nicht oder wurde deaktiviert!';
  rsTooManyLogin = 'Sie haben 3x eine falsches Login angegeben. Die Anwendung wird beendet!';
  rsUSER = 'BENUTZER';
  rsUserExists = 'Der angegbene Benutzer existiert bereits!';
  rsOldDataPurged = '%d alte Bewerbungen wurden aus dem System entfernt';
  rsPurging = 'Datenbank-Bereinigung';
implementation

end.

