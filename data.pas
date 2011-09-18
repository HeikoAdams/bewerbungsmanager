unit data;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, db, FileUtil;

type

  { TdmBewerbungen }

  TdmBewerbungen = class(TDataModule)
    qryBewerbungenDATUM: TDateField;
    qryBewerbungenFEEDBACK: TLongintField;
    qryBewerbungenID: TLongintField;
    qryBewerbungenJOBTITEL: TStringField;
    qryBewerbungenMAIL: TStringField;
    qryBewerbungenNAME: TStringField;
    qryBewerbungenREFNR: TStringField;
    qryBewerbungenRESULT: TLongintField;
    qryBewerbungenTYP: TLongintField;
    qryBewerbungenWVL: TDateField;
    qryFilterFeedbackDATUM: TDateField;
    qryFilterFeedbackFEEDBACK: TLongintField;
    qryFilterFeedbackID: TLongintField;
    qryFilterFeedbackJOBTITEL: TStringField;
    qryFilterFeedbackMAIL: TStringField;
    qryFilterFeedbackNAME: TStringField;
    qryFilterFeedbackREFNR: TStringField;
    qryFilterFeedbackRESULT: TLongintField;
    qryFilterFeedbackTYP: TLongintField;
    qryFilterFeedbackWVL: TDateField;
    qryFilterResultDATUM: TDateField;
    qryFilterResultFEEDBACK: TLongintField;
    qryFilterResultID: TLongintField;
    qryFilterResultJOBTITEL: TStringField;
    qryFilterResultMAIL: TStringField;
    qryFilterResultNAME: TStringField;
    qryFilterResultREFNR: TStringField;
    qryFilterResultRESULT: TLongintField;
    qryFilterResultTYP: TLongintField;
    qryFilterResultWVL: TDateField;
    qryFilterWVLDATUM: TDateField;
    qryFilterWVLFEEDBACK: TLongintField;
    qryFilterWVLID: TLongintField;
    qryFilterWVLJOBTITEL: TStringField;
    qryFilterWVLMAIL: TStringField;
    qryFilterWVLNAME: TStringField;
    qryFilterWVLREFNR: TStringField;
    qryFilterWVLRESULT: TLongintField;
    qryFilterWVLTYP: TLongintField;
    qryFilterWVLWVL: TDateField;
    qryLogBESCHREIBUNG: TStringField;
    qryLogBEWERBUNG: TLongintField;
    qryLogDATUM: TDateField;
    qryLogID: TLongintField;
    qryLogTYP: TStringField;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  dmBewerbungen: TdmBewerbungen;

implementation

{$R *.lfm}

end.

