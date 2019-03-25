[![Build Status](https://api.travis-ci.org/marcel-100/ToDoListe.svg?branch=master)](https://travis-ci.org/marcel-100/ToDoListe)

### Minimale ToDo-Liste in COBOL
Dieses Projekt bietet eine minimale ToDo-Listen Funktionlität in COBOL:
Es ist möglich:
 * einen ToDo-Eintrag zu erstellen
 * alle Einträge zu löschen.

Die Einträge werden dabei in eine Datei geschrieben.

### Setup
Am einfachsten ist wohl ein Setup mittels [Vagrant](https://www.vagrantup.com/).
Nach der Installation von Vagrant das git-Repo clonen und in der Kommandozeile
```
vagrant up
```
eingeben.

Verbindet man sich anschließend per
```
vagrant ssh
```
und führt im Verzeichnis ```/vagrant``` nacheinander
```
make
```
und
```
make run-server
```
aus, sollte die ToDo-Liste unter http://localhost:8080 erreichbar sein.

#### Manuelle Installation
Wer schon Linux benutzt und nicht den Umweg über Vagrant gehen möchte, kann folgendes machen:
 * Installation von GnuCOBOL 3.0 RC1. Z.Bsp. über das Skript ```installcobol3.sh```.
 * Anschließend Ausführen der ```bootstrap.sh```, um den Apache zu konfigurieren.
