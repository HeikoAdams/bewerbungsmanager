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

unit bewerbung_strings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

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
  rsEsBefindenSi = 'Es befinden sich aktuell %d Bewerbungen in der '
    +'Wiedervorlage!';
  rsExportBeende = 'Export beendet';
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
  rsRESULT2 = '(RESULT <> 2) AND (IGNORIERT = 0)';
  rsRESULTD = '(RESULT = %d)';
  rsSuche = 'Suche';
  rsTYPD = '(TYP = %d)';
  {$IFDEF Unix}rsUsrBinXdgOpe = '/usr/bin/xdg-open "%s"';{$ENDIF}
  rsWarnung = 'Warnung';
  rsWERT = 'WERT';
  rsWHEREWVLSAND = '(WVL <= %s) AND (FEEDBACK = 0) AND (RESULT = 0) AND (IGNORIERT = 0)';

implementation

end.

