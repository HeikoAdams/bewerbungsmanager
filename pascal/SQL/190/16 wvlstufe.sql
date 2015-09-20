ALTER TABLE BEWERBUNGEN ADD WVLSTUFE INTEGER;

UPDATE BEWERBUNGEN
SET WVLSTUFE = CAST(ROUND((JULIANDAY(WVL) - JULIANDAY(DATUM)) / 28) AS INT) - 1
WHERE JULIANDAY(WVL) - JULIANDAY(DATUM)  >= 28;

CREATE TRIGGER UPDATE_WVL_STUFE UPDATE OF WVL ON BEWERBUNGEN
BEGIN 
UPDATE BEWERBUNGEN
SET WVLSTUFE = CAST(ROUND((JULIANDAY(NEW.WVL) - JULIANDAY(NEW.DATUM)) / 28) AS INT) - 1
WHERE JULIANDAY(NEW.WVL) - JULIANDAY(NEW.DATUM)  >= 28;
END;
