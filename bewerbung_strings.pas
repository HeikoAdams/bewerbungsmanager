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
  rsCOMPANIES = 'COMPANIES';
  rsCSVExport = 'CSV-Export';
  rsDatenbankSKo = 'Datenbank (%s) konnte nicht gefunden werden!';
  rsDDatensTze = '%d Datensätze';
  rsExportBeende = 'Export beendet';
  rsFehler = 'Fehler';
  rsDateFormat = 'dd.mm.yyyy';
  rsJOBS = 'JOBS';
  rsMAILS = 'MAILS';
  rsUnixLauncher = '/usr/bin/xdg-open "%s"';
  rsWERT = 'WERT';

implementation

end.

