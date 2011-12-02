{
  Copyright 2011 Heiko Adams

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}

unit bewerbung_strings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

const
  nVersion = 100;
  nInitVer = 100; //Konstante für die Initialisierung der Datenbank. NICHT ÄNDERN!

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
  rsRECEIPENTS = 'RECEIPENTS';
  rsRESULT2 = '(RESULT <> 2)';
  rsRESULTD = '(RESULT = %d)';
  rsSuche = 'Suche';
  rsTYPD = '(TYP = %d)';
  {$IFDEF Unix}rsUsrBinXdgOpe = '/usr/bin/xdg-open "%s"';{$ENDIF}
  rsWarnung = 'Warnung';
  rsWERT = 'WERT';
  rsWHEREWVLSAND = '(WVL <= %s) AND (FEEDBACK = 0) AND (RESULT = 0) AND (IGNORIERT = 0)';

implementation

end.

