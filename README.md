## ArchiVista
ArchiVista pubblica le descrizioni archivistiche prodotte con Archimista.
Versione corrente: **2.2.0**

Sito ufficiale: www.archimista.it

## Requisiti

* Ruby 2.1.5
* Rails 4.2.1
* Sphinx 2.2.10 (motore di ricerca testuale)
* Database Archimista 2.1.0 in MySQL >= 5.1
* Webserver configurato per applicazioni Rails

## Installazione
Creare un file di configurazione per il database: config/database.yml.

Installare le dipendenze Rails:

    bundle install

Attivare il motore di ricerca testuale:

    rake ts:configure
    rake ts:rebuild

## Crediti
ArchiVista è un'evoluzione di ArchimistaWeb 1.0.

## Autori (ArchimistaWeb)
Codex Società Cooperativa, Pavia
* [http://www.codexcoop.it](http://www.codexcoop.it)

La versione attuale è stata sviluppata da TAI S.a.s.
* [http://www.taisas.com](http://www.taisas.com)

## Licenza
ArchiVista è rilasciato sotto licenza GNU General Public License v2.0 o successive.
