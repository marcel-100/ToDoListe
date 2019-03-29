Minimale ToDo-Liste in GnuCOBOL
============================

[![Build Status](https://api.travis-ci.org/marcel-100/ToDoListe.svg?branch=master)](https://travis-ci.org/marcel-100/ToDoListe)

Dieses Projekt bietet eine minimale To-do-Listenfunktionalität im Webbrowser mit
[GnuCOBOL](https://sourceforge.net/projects/open-cobol/) auf der Serverseite.

Die Einträge werden dabei serverseitig sequenziell in eine Textdatei geschrieben.

Features
--------

- Einzelne Einträge erstellen, bearbeiten und löschen
- Alle Einträge löschen
- Korrekte Darstellung langer Einträge
- Abschicken von Eingaben mit Enter
- Automatisches leeren der Eingabefelder
- Unterstützung höherer Unicode-Zeichen inklusive Emojis
- Unterbindung von HTML-Injection
- Verschieben einzelner Einträge

Setup
-----

### Mit Vagrant z. B. unter Windows ###

Dieses Projekt ist für den Einsatz von [Vagrant](https://www.vagrantup.com/)
vorbereitet. Nach der Installation von Vagrant und dem Clonen dieses Repositorys
kann aus der Kommandozeile des Host-Systems das Entwicklungssystem gestartet
werden:

```bash
vagrant up
vagrant ssh
make
make run-server
```

### Ohne Vagrant ###

Wer nicht den Weg über Vagrant gehen möchte, kann wie folgt vorgehen:

1. Installation von [GnuCOBOL 3.0 RC1](https://sourceforge.net/projects/open-cobol/files/gnu-cobol/3.0/gnucobol-3.0-rc1.tar.gz/download)
   über das Skript `installcobol3.sh` oder von Hand.
2. Vorbereitung des Webservers mit `bootstrap.sh`.

Kompilieren und Ausführen
-------------------------

Zum Kompilieren liegt dem Projekt ein Makefile bei:

| Befehl            | Beschreibung                                                     |
| ----------------- | ---------------------------------------------------------------- |
| `make run-server` | Kompiliert das Projekt und startet einen Webserver auf Port 8080 |
| `make`            | Kompiliert das Projekt                                           |

Die beiliegendende Vagrant-Konfiguration lässt den Webserver auch vom Hostsystem
aus unter [http://localhost:8080/](http://localhost:8080/) erreichen.
