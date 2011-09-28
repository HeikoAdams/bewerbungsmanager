#! /bin/bash

mkdir ~/.config/bewerbungen
cat ./bewerbungen.sql |sqlite3 ~/.config/bewerbungen/bewerbungen.db