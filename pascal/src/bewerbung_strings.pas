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
  {$IFDEF Windows}
  CRLF = #13#10;
  CRLF2 = #13#10#13#10;
  {$endif}
  {$IFDEF Unix}
  CRLF = #10;
  CRLF2 = #10#10;
  {$endif}

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
  rsFEEDBACKDR = '(FEEDBACK = %d) AND (RESULT = %d)';
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
  rsRESULT2 = '(RESULT IN (0,4)) AND (IGNORIERT = 0) AND (MAN_ERL = 0)';
  rsRESULTD = '(RESULT = %d)';
  rsRESULT3 = '(RESULT IN (0,4)) AND (MAN_ERL = 0)';
  rsSuche = 'Suche';
  rsTYPD = '(TYP = %d)';
  {$IFDEF Unix}rsUsrBinXdgOpe = '%s/xdg-open "%s"';{$ENDIF}
  rsWarnung = 'Warnung';
  rsWERT = 'WERT';
  rsWHEREWVLSAND = '(((Date(WVL) <= Date(''now'')) AND (RESULT IN (0,4)))) AND (IGNORIERT = 0) AND (MAN_ERL = 0)';
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
  rsPurgeSQL = 'UPDATE BEWERBUNGEN SET MAN_ERL = -1 WHERE (UID = :pUserID) AND (DATE(DATUM) < DATE(''now'', ''-1 year'')) AND (RESULT <> 1);';
  rsCleanupSQL = 'DELETE FROM DOCUMENTS WHERE (BEWERBUNG = 0);';
  rsDeactiveComp = 'UPDATE COMPANIES SET AKTIV = 0 WHERE ID NOT IN (SELECT COMPANY FROM BEWERBUNGEN);';
  rsDeleteJobs = 'DELETE FROM JOBS WHERE ID NOT IN (SELECT DISTINCT JOB FROM BEWERBUNGEN);';
  rsInaktiveFirma = 'Der gewählte Empfänger ist als inaktiv gekennzeichnet!';
  rsPersonalvermittler = 'Personalvermittler!';
  rsNoReaction = 'Firma reagiert nicht auf Rückfragen!';
  rsMarkCompanies = 'UPDATE COMPANIES SET NOREACTION = -1 WHERE ID IN (SELECT DISTINCT COMPANY FROM BEWERBUNGEN WHERE UID = :pUserID AND WVLSTUFE >= 3)';
  rsYes = 'Ja';
  rsNo = 'Nein';
  rsEmptyDate = '  .  .    ';
  rsWriteMail = 'Mail geschrieben';
  rsContactMail = 'Per Mail Kontakt zum Arbeitgeber aufgenommen';
  rsEmpfangBest = 'EMPFANGBEST = -1';
  rsManErl = 'manuell erledigt';
  rsManErlTxt = 'Status der Bewerbung auf "manuell erledigt" geändert';
implementation

end.

