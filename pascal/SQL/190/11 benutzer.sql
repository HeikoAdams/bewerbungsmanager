CREATE TABLE "BENUTZER" ("UID" INTEGER PRIMARY KEY  NOT NULL ,
"NAME" VARCHAR(255) NOT NULL ,
"PWD" VARCHAR(255),
"ACTIVE" BOOLEAN NOT NULL DEFAULT 1);

INSERT INTO "BENUTZER" (NAME, ACTIVE) 
VALUES ("ADMINISTRATOR", 1);

ALTER TABLE "BEWERBUNGEN"
ADD UID INTEGER NOT NULL REFERENCES BENUTZER(UID);

UPDATE BEWERBUNGEN SET UID = 0;
