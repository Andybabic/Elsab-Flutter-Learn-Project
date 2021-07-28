# elsab

Feuerwehr OrganisationsApp

## Anforderungen

Die App soll den Mitgliedern der Feuerwehr erlauben auf Einsätze sowie Daten im Feuerwehrwesen zugreifen zu können.

Das wichtigste ist eine Liste aller aktuellen sowie vergangenen Einsätze. 
Dies werden von einer API geladen siehe: https://elsab.at/api/history/results.json

Jeder Eisatz soll anklickbar werden und eine Detailierte Ansicht des Einsatzes zeigen, wichtig ist dabei die möglichkeit eine Navigation mit der aktuellen Position zu starten. Es soll ebenfalls die möglichkeit geben, bei Einsätzen direkt untergeordnete Daten und Formulare darzustellen. Für den Release reicht ein einfacher upload von Fotos und Videos auf einen FTP Server. Diese Bilder sollen auch nach dem Hochladen in einer jeweiligen Galerie zu verfügung stehen.
Bei jedem Einsatz soll es auch die möglichkeit geben einen Text/ Kommentar zu schreiben, der bei dem Einsatz unten angehängt wird ( z.B Adresse falsch, Richtige Adresse ist ... )

Ein weiterer Part ist die Benachrichtigung zu einem Event/ Einsatz, dieser soll ein einfacher Push sein.

Es soll auch möglich sein miteinander zu chatten und einen direkten Partner oder Gruppe schreiben zu können.

Alle Anforderungen sind somit:

Firebase als Datenbank
- Automatisch Daten von der Json zu Firebase portieren 
- Nutzer mit Infos

FTP als Speicher für Fotos und Videos
- schreiben auf FTP ( Zugänge sollen nicht in der App gespeichert sein, deshalb wird eine PHP Schnittstelle genutzt )
- Lesen von FTP





Farben sollen nach diesem Schema gewählt werden.

![alt text](http://Elsab/Elsab colors.png)

