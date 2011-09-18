CREATE TABLE "BEWERBUNGEN"(ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, DATUM DATETIME NOT NULL, NAME VARCHAR(255) NOT NULL, MAIL VARCHAR(255), JOBTITEL VARCHAR(255) NOT NULL, REFNR VARCHAR(255), TYP INT NOT NULL, FEEDBACK INT NOT NULL, RESULT INT NOT NULL, WVL DATETIME NOT NULL, NOTES VARCHAR(8000), VERMITTLER BOOLEAN NOT NULL DEFAULT 0, "MEDIUM" INTEGER NOT NULL  DEFAULT 0);
CREATE TABLE "LOG"(
ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
DATUM DATETIME NOT NULL,
BEWERBUNG INT NOT NULL REFERENCES BEWERBUNGEN(ID),
TYP VARCHAR(255) NOT NULL,
BESCHREIBUNG VARCHAR(8000));
CREATE TRIGGER "AI_BEWERBUNGEN" AFTER INSERT ON "BEWERBUNGEN" BEGIN INSERT INTO LOG(BEWERBUNG, DATUM, TYP, BESCHREIBUNG)
SELECT NEW.ID, NEW.DATUM, "VERSAND", "BEWERBUNGSUNTERLAGEN VERSCHICKT"; END;
CREATE TRIGGER "BD_BEWERBUNGEN" BEFORE DELETE ON "BEWERBUNGEN" BEGIN DELETE FROM LOG WHERE BEWERBUNG = OLD.ID; END;