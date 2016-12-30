--[[
HoloFriends addon created by Holo, continued by Zappster, followed by Andymon

Get the latest version at wow.curse.com

See HoloFriends_change.log for more informations  
]]

--[[

This file defines the german localisation data

]]

if( GetLocale() == "deDE" ) then

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGDATEFORMAT = [=[Format des Datum im Tooltip:
(%%Y=Jahr, %%m=Monat, %%d=Tag des Monats, %%H=Stunde {max. 24}, %%I=Stunde {max. 12}, %%M=Minute, %%p=am or pm, %%A=Wochentag)]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONASKMERGEFRIENDGROUPS = [=[Für alle Freunde, welche in der Freundesliste von |cffffd200%s|r enthalten sind:
Soll die Gruppeneinteilung der faktionsweiten Freundesliste mit dieser überschrieben werden?]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONASKMERGEIGNOREGROUPS = [=[Für alle Ignorierten, welche in der Ignorierenliste von |cffffd200%s|r enthalten sind:
Soll die Gruppeneinteilung der faktionsweiten Ignorierenliste mit dieser überschrieben werden?]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONMERGEFRIENDWARNING = [=[Sie sind im Begriff, alle Freunde von
|cffffd200%s|r
in die fraktionsweite Freundesliste einzufügen.

|cffffd200WARNUNG|r
Die individuelle Freundesliste wird gelöscht!
Dieser Schritt kann nicht rückgängig gemacht werden!
Abhängig von den Optionen, kann es zu Datenverlust kommen!
Die Daten der Freundesliste sind nur lokal auf der Festplatte gespeichert.

|cffffd200EMPFEHLUNG|r
Machen Sie eine Sicherheitskopie (z.B. auf ihren USB-Stik) von der HoloFriends Freundeslisten-Datei:
{WoW dir}/WTF/Account/{Your ACC}/SavedVariables/HoloFriends.lua

|cffffd200Haben Sie eine Sicherheitskopie?|r]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONMERGEIGNOREWARNING = [=[Sie sind im Begriff, alle Ignorierten von
|cffffd200%s|r
in die fraktionsweite Ignorierenliste einzufügen.

|cffffd200WARNUNG|r
Die individuelle Ignorierenliste wird gelöscht!
Dieser Schritt kann nicht rückgängig gemacht werden!
Abhängig von den Optionen, kann es zu Datenverlust kommen!
Die Daten der Ignorierenliste sind nur lokal auf der Festplatte gespeichert.

|cffffd200EMPFEHLUNG|r
Machen Sie eine Sicherheitskopie (z.B. auf ihren USB-Stik) von der HoloFriends Freundeslisten-Datei:
{WoW dir}/WTF/Account/{Your ACC}/SavedVariables/HoloFriends.lua

|cffffd200Haben Sie eine Sicherheitskopie?|r]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONPRIORITYFRIENDWARNING = [=[|cffffd200WARNUNG|r
Die Benutzung der fraktionsweiten Freundesliste gibt ihr Priorität über die spielinterne Freundesliste.

Das Hinzufügen oder Entfernen von Freunden mit anderen Addons zu oder von der Freundesliste deiner Charaktere, welche die fraktionsweite Freundesliste verwenden, wird von HoloFriends rückgängig gemacht.
Das Hinzufügen oder Entfernen von Freunden ohne das HoloFriends geladen ist, wird beim nächsten Start von HoloFriends rückgängig gemacht.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFACTIONPRIORITYIGNOREWARNING = [=[|cffffd200WARNUNG|r
Die Benutzung der fraktionsweiten Ignorierenliste gibt ihr Priorität über die spielinterne Ignorierenliste.

Das Hinzufügen oder Entfernen von Ignorierten mit anderen Addons zu oder von der Ignorierenliste deiner Charaktere, welche die fraktionsweite Ignorierenliste verwenden, wird von HoloFriends rückgängig gemacht.
Das Hinzufügen oder Entfernen von Ignoriereten ohne das HoloFriends geladen ist, wird beim nächsten Start von HoloFriends rückgängig gemacht.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGFRIENDSLISTCHANGED = "FEHLER: Der ausgewählte Freundeslisteneintrag ist kein RealID Freund. Die spielinterne Freundesliste hat sich während des Dialogs verändert.";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGGETREALIDNAMEBNETID = [=[Die Namen der RealID Freunde sind im Speicher verschlüsselt.
Um erweiterte HoloFriends Funktionen (Gruppen, Suche) nutzen zu können, muss HoloFriends den Namen aber im Klartext kennen.
Zur eindeutigen Identifizierung wird die bnetIDAccount des Freundes genutzt, da dein Freund keinen BattleTag gesetzt hat.
Mir ist bisher nicht bekannt, ob die bnetIDAccount stabiel ist, aber eine andere ID gibt es in dem Fall nicht.

Bitte den Namen des Freundes eintippen:
%s]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGGETREALIDNAMEBTAG = [=[Die Namen der RealID Freunde sind im Speicher verschlüsselt.
Um erweiterte HoloFriends Funktionen (Gruppen, Suche) nutzen zu können, muss HoloFriends den Namen aber im Klartext kennen.
Zur eindeutigen Identifizierung wird der BattleTag des Freundes genutzt. Dein Freund kann den BattleTag einmalig ändern.

Bitte den Namen des Freundes eintippen:
%s]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGINVITEALLOFGROUP = "Wirklich alle %s Online-Freunde aus der Gruppe %s einladen ?";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGREALIDNAMEEXIST = "FEHLER: Der eingegebene RealID Name existiert bereits in der HoloFriends liste. Nichts geändert.";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_DIALOGREALIDNAMEWRONG = "FEHLER: Der eingegebene Name lässt sich keinem Namensschlüssel zuordnen. Möglicherweise wurde ein falscher Buchstabe eingegeben. Nichts geändert.";

-- ####################################################################

HOLOFRIENDS_FAQ000TITLE = [=[HoloFriends FAQ

Wichtige Information für asiatische Clients:
Beim ersten umherschieben eines RealID-Freundes in der HoloFriends Freundesliste zu einer anderen Gruppe, wird man aufgefordert, den Namen des RealID-Freundes einzugeben.
Asisatische Namen erfordern evtl. ein nachfolgendes Leerzeichen am Namen.
Das ist so, da EU und US Namen aus zwei Teilen bestehen, dem Vor- und Nachnamen. Beide Teile werden durch ein Leerzeichen auf dem Server getrennt. Einige asiatische Namen haben keinen separaten Teil, aber der Server erfordert die Eingabe des Leerzeichens als Separator zum nicht genutzten Nachnamen.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ011QUESTION = "Zeigt dieses Addon, wann deine Freunde das letzte mal online waren? Ich finde das eine sehr nützliche Sache.";
HOLOFRIENDS_FAQ012ANSWER = "HoloFriends zeigt für deine Freunde das Datum an denen du sie das letzte mal gesehen hast. So viel ich weis, ist es nur möglich das Datum des letzten Login für Gildenmitglieder zu erhalten.";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ021QUESTION = "Weis jemand, was das Markieren der kleinen Boxen bewirkt?";
HOLOFRIENDS_FAQ022ANSWER = [=[Es gibt kleine Markierungsfelde vor den Namen der Freunde (schaue auf den Screenshot "Display all friends"). Wenn dieses Kontrollkästchen markiert ist, ist der Freund in der spielinternen Freundesliste von WoW enthalten, ansonsten steht der Freund nur in der Freundesliste von HoloFriends.
Freunde in der spielinternen Freundesliste von WoW werden online durch das Spiel aktualisiert und man sieht immer den aktuellen Status. Aber die spielinterne Freundesliste hat ein Limit von max. 100 Freunden.
Freunde ohne Markierung im Kontrollkästchen (nur in der Freundesliste von HoloFriends enthalten) werden nicht durch das Spiel überwacht. Der Status dieser Freunde muss mit Hilfe des "/who" Kommandos von WoW überprüft werden (Klick auf den "/who Scan"-Knopf). Diese Überprüfung ist relativ langsam, da das Spiel eine Pause zwischen den Ausführungen von zwei "/who" Kommandos erzwingt.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ031QUESTION = "Da steht \"Aktualisiere den Status von Freunden (>100), welche nicht online von WoW überwacht werden, mit nur einem Klick\"; aber das ist nicht sehr verständlich.";
HOLOFRIENDS_FAQ032ANSWER = [=[Wegen dem langsamen Scan mit "/who" für die Freunde, welche nicht in der spielinternen Freundesliste von WoW enthalten sind (Box vor dem Freund nicht markiert), wird eine Aktualisierung des Status nicht automatisch ausgeführt. Du hast den "/who Scan" manuell durch einen Klick auf den roten Knopf "/who Scan" in der oberen rechten Ecke des Freundeslistenfensters zu starten.
Beachte: Während der "/who Scan" läuft, wird das "/who" Kommando nicht funktionieren.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ041QUESTION = "Weshalb ist \"Focus setzen\" in einigen Pulldown-Menüs deaktiviert?";
HOLOFRIENDS_FAQ042ANSWER = [=[Ich musste das deaktivieren, da sonst mit normalen Menüeinträgen die Fehlermeldung "function blocked by blizzard" erscheint.
Das Setzen des Fokus scheint eine generell geschützte Funktion im Spiel zu sein. Es ist eine Eigenschaft des Spiels, dass eine geschützt Funktion nicht funktioniert, wenn am Fenster dieser Funktion eine nicht signierte Änderung vorgenommen wurde, in diesem Fall am Pulldown-Menü.
Deshalb habe ich eine Option im HoloFriends Optionen Fenster hinzugefügt, welche alle Menümodifikationen von HoloFriends deaktiviert, damit der Eintrag "Fokus setzen" in allen Pulldown-Menüs funktioniert.
Optional habe ich eine neue Methode zum Modifizieren der Pulldown-Menüs ohne dieses Problem (Schutzverletzung, engl.tainting) eingebaut. Aber diese Methode benutzt Basisfunktionen, welche sich in Zukunft wieder Ändern können oder auch geschützt werden.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ051QUESTION = "Weshalb ist in einem Raid im Kampf das Raid-Fenster leer, wenn HoloFriends geladen ist?";
HOLOFRIENDS_FAQ052ANSWER = [=[Das sollte nicht mehr auftreten, da HoloFriends jetzt sein eigenes unabhängiges Fenster benutzt.
Es ist eine Eigenschaft des Spiels, dass ein geschütztes Fenster im Kampf nicht funktioniert, wenn eine unsignierte Änderung an irgendeinem Teil des Fensters vorgenommen wurde.
Das Raid-Fenster ist ein Teil des Freund-Fensters, wo auch das Freundeslisten-Fenster ein Teil davon ist. Das Freundeslisten-Fenster war in der Vergangenheit durch HoloFriends modifiziert. Und HoloFriends ist nicht durch Blizz signiert.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ061QUESTION = "Gibt es einen Weg, Gruppen und Mitglieder der Gruppen zwischen den Charakteren zu synchronisieren?";
HOLOFRIENDS_FAQ062ANSWER = [=[Ja.
Man kann die fraktionsweite Freundesliste für einige oder alle seine Charaktere verwenden, wobei alle diese Charaktere die selbe Freundesliste in HoloFriends verwenden. Auch die spielinterne Freundesliste auf dem Server wird synchronisiert.
Oder man synchronisiert manuell einzelne Gruppen zwischen seinen Charakteren.

Das Hinzufügen zur fraktionsweiten Freundesliste und auch das Synchronisieren von einzelnen Gruppen wird im Übertragen-Fenster von HoloFriends durchgeführt. Man erreicht es über den untersten mittleren Knopf im Freundeslistenfenster, oder durch das Navigieren zu "Hauptmenü -> Interface -> Addons -> HoloFriends -> Freunde übertragen".

Um einen seiner Charaktere zur fraktionsweiten Freundesliste hinzuzufügen, wählt man ihn am Aufklappmenü im oberen Teil des Fensters aus und klicke auf den "Hinzufügen"-Knopf im unteren Teil des Fensters, in der Sektion der fraktionsweiten Freundesliste. Man darf keine Einträge in den 2 Listen markieren.

Um eine Gruppe zu/mit anderen seiner Charaktere zu Übertragen/Aktualisieren, wählt man den "Quellen"-Charakter am Aufklappmenü im oberen Teil des Fensters aus, markiert die zu übertragenden/aktualisierenden Gruppen im Markierungsfeld der Gruppe in der linken Liste, markiere die Empfänger-Charaktere in der rechten Liste und klickt auf den "Hinzufügen"/"Aktualisieren"-Knopf direkt unter den Listen. "Hinzufügen" fügt nur noch nicht existierende Freunde zu den Gruppen der "Ziel"-Charaktere hinzu und "Aktualisieren" synchronisiert die Daten von allen Freunden der ausgewählten Gruppen mit den "Ziel"-Charakteren.
Es gibt eine Option im HoloFriends-Optionenfenster, welche es erlaubt, gelöschte Freunde aus den "Quell"-Gruppen in den "Ziel"-Gruppen zu markieren. Freunde werden automatisch zu anderen ausgewählten Gruppen verschoben, aber nicht aus Gruppen gelöscht. Das Löschen von Freunden hat man selbst vorzunehmen.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ071QUESTION = "Danke für die Einführung. Wird das auch die Gruppen und Mitglieder synchron halten, oder muss ich die Prozedur jedes mal ausführen, wenn ich ein neues Mitglied zu einer Gruppe hinzufüge, oder eine neue Gruppe erstelle? Es wäre besser, wenn es eine Option gäbe, um das synchron zu halten, ohne den beschriebenen \"Aktualisieren\"-Prozess.";
HOLOFRIENDS_FAQ072ANSWER = [=[Die fraktionsweite Freundesliste von HoloFriends ist das gesuchte Feature. Zu deren Benutzung, siehe die Beschreibung weiter oben.

Die fraktionsweite Freundesliste ist eine einzige Freundesliste für einige oder alle deine Charaktere der selben Fraktion auf einem Realm. Es ist hier kein Synchronisieren mehr erforderlich. Alle Änderungen zur Freundesliste werden für alle Charaktere gemacht und die spielinterne Freundesliste auf dem WoW-Server deiner anderen Charaktere wird während des Login aktualisiert.
Aber, es gibt eine Einschränkung mit der fraktionsweiten Freundesliste: HoloFriends braucht die Priorität über die Freundesliste von WoW. Das Bedeutet für die Charaktere, welche die fraktionsweite Freundesliste verwenden, dass kein anderer Freundeslisten-Addon mit HoloFriends zusammen arbeitet.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ081QUESTION = "Ich frage mich, ob es möglich ist, einen Freund von einem Chatakter zu löschen und dann dieses Löschen mit anderen Charakteren zu synchronisieren. Z.B. wenn ich einen Freund X von meinen Charakter lösche und dann die anderen Charaktere auswähle, wird der Freund auch von ihren Listen entfernt?";
HOLOFRIENDS_FAQ082ANSWER = [=[Wenn die fraktionsweite Freundesliste benutzt wird, werden die spielinternen Freundeslisten der anderen Charaktere während des Login mit HoloFriends auf den Stand der HoloFriends-Freundesliste aktualisiert. Wenn ein Freund von der fraktionsweiten Freundesliste entfernt wurde, wird er deshalb automatisch von der spielinternen Freundesliste deiner anderen Charaktere während des Login entfernt.

Wenn der normale Modus mit einzelnen Freundeslisten für alle Charaktere benutzt wird, muss die Gruppe im "Freunde übertragen"-Fenster von HoloFriends zu den anderen Charakteren übertragen werden. Wenn ein Freund in der übertragenen Gruppe entfernt wurde, wird er in der Freundesliste der anderen Charaktere optional nur markiert (Durchgestrichen), aber nicht entfernt. Er muss manuell nach dem Login zu den anderen Charakteren entfernt werden. (Das soll das zusammenarbeiten mit anderen Addons ermöglichen.)]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ091QUESTION = "Gibt es einen Weg, die Freundesliste automatisch zu syncronisieren, oder einen Weg alle Namen beim manuellen Synchronisieren auszuwählen? Wenn ich nichts übersehen habe, bin ich nur in der Lage zu synchronisieren, wenn ich jeden Namen einzeln anklicke.";
HOLOFRIENDS_FAQ092ANSWER = "Durch Markieren der Gruppen, können sie auch ganze Gruppen übertragen. Nach dem Markieren klappt die Gruppe zusammen, aber die Markierungsbox ist noch markiert.";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ101QUESTION = "Mein anderer Freundeslisten-Addon funktioniert nicht wie erwartet, wenn ich HoloFriends benutze. Ist HoloFriends nicht kompatibel?";
HOLOFRIENDS_FAQ102ANSWER = [=[Ja / Nein
HoloFriends sollte mit anderen Addons kompatibel sein, wenn jeder Charakter eine eigene Freundesliste benutzt.

Die fraktionsweite Freundesliste von HoloFriends ist mit einigen anderen Freundeslisten-Addons nicht kompatibel. Vor allem das Hinzufügen und Entfernen von Freunden durch andere Addons wird durch die fraktionsweite Freundesliste von HoloFriends ignoriert, da die fraktionsweite Freundesliste Priorität über die spielinterne Freundesliste braucht. Deswegen werden Änderungen an der spielinternen Freundesliste, ohne das HoloFriends geladen ist, durch die fraktionsweite Freundesliste von HoloFriends rückgängig gemacht, wenn HoloFriends das nächste mal geladen wird. Deshalb sollte die fraktionsweite Freundesliste von HoloFriends nicht benutzt werden, wenn man an verschiedenen Computern spielt oder HoloFriends nicht die ganze Zeit benutzt.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_FAQ111QUESTION = "Vor einiger Zeit habe ich HoloFriends mit einer fraktionsweiten Freundesliste benutzt, aber in der Zwischenzeit spielte ich ohne es. Wenn ich nun HoloFriends wieder lade, wird es alle meine Änderungen zur Freundesliste, welche ich in der Zwischenzeit gemacht habe, wieder entfernen?";
HOLOFRIENDS_FAQ112ANSWER = "Wenn eine fraktionsweite Freundesliste über einen Zeitraum von mehr als 30 Tagen nicht benutzt wurde, wird HoloFriends während des Ladens fragen, ob sie geladen und alle Änderungen rückgängig gemacht werden sollen, oder ob mit der aktuellen spielinternen Freundesliste gestartet werden soll. Die fraktionsweite Freundesliste bleibt weiter bestehen und es kann über das \"Freunde übertragen\"-Fenster auf sie zugegriffen werden.";

-- ####################################################################

HOLOFRIENDS_LISTFEATURES0TITLE = "Fähigkeiten";

HOLOFRIENDS_LISTFEATURES11 = "Handhabung einer fraktionsweiten Freundes- und Ignorierenliste für einige oder alle deine Charaktere";
HOLOFRIENDS_LISTFEATURES12 = "Ordne die Freundes- und die Ignorierenliste in Gruppen";
HOLOFRIENDS_LISTFEATURES13 = "Verwalte mehr als 100 Freunde und 50 Ignorierte";
HOLOFRIENDS_LISTFEATURES14 = "Aktualisiere den Status von Freunden (>100), welche nicht online von WoW überwacht werden, mit nur einem Klick";
HOLOFRIENDS_LISTFEATURES15 = "Ignoriert alle Chat-Nachrichten und Einladungen in Gruppe, Gilde und Duell für offline Ignorierte";
HOLOFRIENDS_LISTFEATURES16 = "Zeigt eine Nachricht, wenn einer deiner Freunde oder Ignorierten von der spielinternen Freundesliste verschwindet";
HOLOFRIENDS_LISTFEATURES17 = "RealID Freunde werden mit einer optionalen Anzeige des Charakternamens hinter/vor dem realen Namen unterstützt";
HOLOFRIENDS_LISTFEATURES18 = "Es kann auch auf die spielinterne Freundes- und Ignorierenliste zugegriffen werden";
HOLOFRIENDS_LISTFEATURES19 = "Konfigurierbare Knöpfe im unteren Teil der Fenster der Freundes- und Ignorierenliste";

HOLOFRIENDS_LISTFEATURES21 = "Füge lange Kommentare (bis zu 500 Zeichen) zur Freundes- und zur Ignorierenliste hinzu";
HOLOFRIENDS_LISTFEATURES22 = "Die ersten 48 Buchstaben der Kommentare werden in die spielinternen Freundnotizen geschrieben";
HOLOFRIENDS_LISTFEATURES23 = "Überwacht Notizen der spielinternen Freundesliste (Unterstützung anderer Addons)";
HOLOFRIENDS_LISTFEATURES24 = "Optionales Verbinden der spielinternen Freundnotizen mit den HoloFriends-Kommentaren";
HOLOFRIENDS_LISTFEATURES25 = "Zeigt die Position, den Kommentar oder die BCast-Nachricht und optional das Level hinter dem Freundesnamen";
HOLOFRIENDS_LISTFEATURES26 = "Zeigt erweiterte Informationen in einem Tooltip seitlich des Freundeslisteneintrages";
HOLOFRIENDS_LISTFEATURES27 = "Durchsuche die Freundes- und Ignorierenliste nach Namen und Kommentaren (Verstecke Schlagworte mit dem #-Zeichen)";

HOLOFRIENDS_LISTFEATURES31 = "Optional zeige nur online Freunde an";
HOLOFRIENDS_LISTFEATURES32 = "Optional zeige nur Gruppen mit Online-Freunden in der Freundesliste";
HOLOFRIENDS_LISTFEATURES33 = "Optional sortiere alle online Freunde nach oben in den Gruppenlisten";
HOLOFRIENDS_LISTFEATURES34 = "Optionale Anzeige von Klassenpiktogrammen zu den Freunden";
HOLOFRIENDS_LISTFEATURES35 = "Optionale Anzeige der Freundesnamen in ihren Klassenfarben";
HOLOFRIENDS_LISTFEATURES36 = "Speichert das Datum, an dem die Freunde zuletzt gesehen wurden";
HOLOFRIENDS_LISTFEATURES37 = "Speichert und zeigt Daten deiner eigenen Charaktere (wenn sie in der Freundesliste enthalten sind)";
HOLOFRIENDS_LISTFEATURES38 = "Zeigt die Anzahl von online/offline Freunden und Ignorierten (optional bei Gruppen)";
HOLOFRIENDS_LISTFEATURES39 = "Markiere einen Freund, um seinen Status zu überwachen und zeige ein Nachrichtenfenster, wenn er Online kommt";

HOLOFRIENDS_LISTFEATURES41 = "Optional nutze die Pulldown-Menüs, um Spieler zur Freundes- oder Ignorierenliste hinzuzufügen (Das Freunde-Fenster wird nicht benötigt)";
HOLOFRIENDS_LISTFEATURES42 = "Optional fügt eine /who-Anfrage zu einigen Pulldown-Menüs hinzu";
HOLOFRIENDS_LISTFEATURES43 = "Optionaler schwarzer undurchsichtiger Hintergrund für Pulldown-Menüs";
HOLOFRIENDS_LISTFEATURES44 = "Optionale neue Methode der Pulldown-Menü-Modifikation (keine Schutzverletzung, engl. tainting)";
HOLOFRIENDS_LISTFEATURES45 = "Rechtsklickoption um alle Freunde in einer Gruppe auf einmal einzuladen";
HOLOFRIENDS_LISTFEATURES46 = "Rechtsklickmenü um Freunde direkt in eine andere Gruppe zu verschieben";

HOLOFRIENDS_LISTFEATURES51 = "Verteile deine Freunde/Ignorierte inklusive den Kommentaren zu deinen anderen Charakteren";
HOLOFRIENDS_LISTFEATURES52 = "Aktualisiere Freundes- und Ignorierendaten zwischen deinen Charakteren";
HOLOFRIENDS_LISTFEATURES53 = "Optionales Verbinden von HoloFriends Kommentaren während dem Übertragenen";
HOLOFRIENDS_LISTFEATURES54 = "Übertrage und Aktualisiere ganze Gruppen von Freunden und Ignorierten";
HOLOFRIENDS_LISTFEATURES55 = "Die Aktualisierung von Gruppen optional markiert nicht existierende Freunde/Ignorierte in der Liste des Ziels";
HOLOFRIENDS_LISTFEATURES56 = "Verbinde die Listen von einigen oder allen deinen Chatakteren zu einer fraktionsweiten Freundes- oder Ignorierenliste";
HOLOFRIENDS_LISTFEATURES57 = "Erlaubt das Separieren von deinen Charakteren von der fraktionsweiten Freundes- oder Ignorierenliste";

HOLOFRIENDS_LISTFEATURES61 = "HoloFriends Hilfe (FAQ) in der Interface-Optionenliste";
HOLOFRIENDS_LISTFEATURES62 = "Optional zeige Liste mit online Freunden im Chat-Fenster beim Login";
HOLOFRIENDS_LISTFEATURES63 = "Substituiere die Namen aller Freunde und deiner Charaktere, z.B. im Briefkasten";

-- ####################################################################

HOLOFRIENDS_HOMEPAGEACTUAL = [=[Neue Funktionen in dieser Version:
* HoloFriends hat eine Suchfunktion bekommen (Masseneinladung in der Suchen-Gruppe)
* Hinweisfenster, wenn ein überwachter Freund online kommt

Korrekturen in dieser Version:
* die "Umbenennen" und "Entfernen" Pulldown Menü Knöpfe für die Gruppen FRIENDS, IGNORE, SEARCH sind deaktiviert
* Fehlerbehebung für einige Editierboxen, wo die ENTER-Taste nicht funktioniert hat
* Fehlerbehebung für eine nicht reagierende Freundesliste nach den Entfernen des Online-Status von einem Freund (Nach dem Entfernen eines Freundes von der spielinternen Freundesliste sendet der Server keine Bestätigung mehr)]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGEADDRESS = [=[Das Projekt ist zu Hause auf:
http://wow.curseforge.com/projects/holo-friends-continued/
Hier ist auch ein Ticket-System für das Anfordern von Neuerungen und Fehlermeldungen vorhanden:
http://wow.curseforge.com/projects/holo-friends-continued/tickets/]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGEAIM = [=[Dieses Addon implementiert ein erweitertes Freundefenster in WoW, um ein besseres Management der Freundes- und Ignorierenliste zu ermöglichen.
Eine Übersicht und etwas Hilfe findet man bei den Screenshots: http://wow.curseforge.com/addons/holo-friends-continued/images/]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGELOCALIZATION = [=[Übersetzungen von
Andymon - Deutsch (deDE)
zwlong9069 - Einfaches Chinesisch (zhCN)
Aladdinn, zwlong9069, skywalkertw - Traditionelles Chinesisch (zhTW)
marturo77 - Lateinamerikanisches Spanisch (esMX)
oXid_FoX - Französisch (frFR)]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGEREMARKSTITLE = "Hinweise";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGESEARCH = [=[Du möchtest HoloFriends auch in deiner Sprache haben?
Ich suche nach Übersetzern von HoloFriends und dem Inhalt der WEB-Seite.
Sende mir eine Notiz in curse, wenn du dem Team als Übersetzer beitreten möchtest. Die Übersetzung wird einfach über ein WEB-Oberfläche bedient.
Öffentliche Übersetzungen sind in curse geschlossen.]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_HOMEPAGETITLE = "HoloFriends (continued) v0.462";

-- ####################################################################

HOLOFRIENDS_INITADDONLOADED = "HoloFriends Addon v%.3f wurde geladen";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_INITINVALIDLISTVERSION = "Die HoloFriends Daten wurden mit einer neueren Version von HoloFriends (%s) erzeugt - um die Daten nicht zu beschädigen, werden keine Informationen geladen oder gespeichert";
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_INITLOADFACTIONSFRIENDSLIST = [=[|cffffd200WARNUNG:|r Die fraktionsweite Freundesliste von diesem Charakter war seit langem nicht geladen.
Möglicherweise wurde gespielt, ohne das HoloFriends geladen war und nun soll die spielinterne Freundesliste für diesen Charakter geladen werden.
Das Fortfahren mit dem Laden der fraktionsweiten Freundesliste für diesen Charakter wird alle Änderungen an der spielinternen Freundesliste, welche ohne geladenes HoloFriends gemacht wurden, rückgängig machen.
Soll die fraktionsweite Freundesliste geladen werden?]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_INITLOADFACTIONSIGNORELIST = [=[|cffffd200WARNUNG:|r Die fraktionsweite Ignorierenliste von diesem Charakter war seit langem nicht geladen.
Möglicherweise wurde gespielt, ohne das HoloFriends geladen war und nun soll die spielinterne Ignorierenliste für diesen Charakter geladen werden.
Das Fortfahren mit dem Laden der fraktionsweiten Ignorierenliste für diesen Charakter wird alle Änderungen an der spielinternen Ignorierenliste, welche ohne geladenes HoloFriends gemacht wurden, rückgängig machen.
Soll die fraktionsweite Ignorierenliste geladen werden?]=];
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
HOLOFRIENDS_INITSHOWONLINEATLOGIN = "Liste deiner Online-Freunde:";

-- ####################################################################

HOLOFRIENDS_WINDOWMAINADDCOMMENT = "Kommentar bearbeiten";
HOLOFRIENDS_WINDOWMAINADDGROUP = "Gruppe hinzufügen";
HOLOFRIENDS_WINDOWMAINBUTTONSCAN = "/who Scan";
HOLOFRIENDS_WINDOWMAINBUTTONSTOP = "Scan stoppen";
HOLOFRIENDS_WINDOWMAINIGNOREONLINE = "Online Ignorierte:";
HOLOFRIENDS_WINDOWMAINMOVETOGROUP = "Verschiebe zu Gruppe";
HOLOFRIENDS_WINDOWMAINNUMBERONLINE = "Freunde Online:";
HOLOFRIENDS_WINDOWMAINONWARNING = "Ist Online Warnung";
HOLOFRIENDS_WINDOWMAINREMOVEGROUP = "Gruppe entfernen";
HOLOFRIENDS_WINDOWMAINRENAMEGROUP = "Gruppe umbenennen";
HOLOFRIENDS_WINDOWMAINSHOWOFFLINE = "Offline-Freunde anzeigen";
HOLOFRIENDS_WINDOWMAINWHOREQUEST = "Who Abfrage";

-- ####################################################################

HOLOFRIENDS_MSGDELETECHARDIALOG = "Willst Du wirklich alle Daten von |cffffd200%s|r löschen?";
HOLOFRIENDS_MSGDELETECHARDONE = "Alle Daten von %s wurden gelöscht";
HOLOFRIENDS_MSGDELETECHARNOTFOUND = "%s wurde nicht gefunden, bitte überprüfe die genaue Schreibweise";

HOLOFRIENDS_MSGFACTIONMERGEDONE = "%s zur fraktionsweiten Liste hinzugefügt";
HOLOFRIENDS_MSGFACTIONNOMERGE = "ABGEBROCHEN: Kein Hinzufügen zur fraktionsweiten Liste durchgeführt";

HOLOFRIENDS_MSGFRIENDLIMITALERT = "Sie können nur %d Freunde Überwachen!";
HOLOFRIENDS_MSGFRIENDMISSINGONLINE = "Dein Freund %s ist von der Online-Freundesliste verschwunden.";
HOLOFRIENDS_MSGFRIENDNOBNETNOFRIEND = "BNet im Moment nicht verfügbar. Keine BNet-Freundes-Einladung gesendet.";
HOLOFRIENDS_MSGFRIENDNOBNETNOREMOVE = "BNet im Moment nicht verfügbar. Der BNet-Freund konnte nicht entfernt werden.";
HOLOFRIENDS_MSGFRIENDNOBTAGNOFRIEND = "BattleTags sind deaktiviert. Keine BNet-Freundes-Einladung gesendet.";
HOLOFRIENDS_MSGFRIENDNOREALIDNOFRIEND = "RealIDs sind deaktiviert. Keine BNet-Freundes-Einladung gesendet.";
HOLOFRIENDS_MSGFRIENDONLINEDISABLED = "Online Status Überwachung des Freundes %s deaktiviert.";
HOLOFRIENDS_MSGFRIENDONLINEENABLED = "Online Status Überwachung des Freundes %s aktiviert.";

HOLOFRIENDS_MSGIGNOREDUEL = "Duell abgebrochen - %s ist in der offline Ignorierenliste";
HOLOFRIENDS_MSGIGNOREINVITEGUILD = "Gildeneinladung abgelehnt - %s ist in der offline Ignorierenliste";
HOLOFRIENDS_MSGIGNORELIMITALERT = "Sie können nur %d Spieler online ignorieren!";
HOLOFRIENDS_MSGIGNOREMISSINGONLINE = "Der Spieler %s ist von der Online-Ignorierenliste verschwunden.";
HOLOFRIENDS_MSGIGNOREONLINEDISABLED = "Online ignorieren Überwachung von %s deaktiviert.";
HOLOFRIENDS_MSGIGNOREONLINEENABLED = "Online ignorieren Überwachung von %s aktiviert.";
HOLOFRIENDS_MSGIGNOREPARTY = "Gruppeneinladung abgelehnt - %s ist in der offline Ignorierenliste";
HOLOFRIENDS_MSGIGNORESIGNGUILD = "Unterschrift der Gildensatzung abgelehnt - %s ist in der offline Ignorierenliste";

HOLOFRIENDS_MSGSCANDONE = "Scan der zusätzlichen Freunde beendet";
HOLOFRIENDS_MSGSCANSTART = "%d Einträge werden überprüft. Der Vorgang dauert ca. %f Sekunden. /who wird während dieser Zeit nicht funktionieren.";
HOLOFRIENDS_MSGSCANSTOP = "Scan abgebrochen";

-- ####################################################################

HOLOFRIENDS_OPTIONS0BUTTONORDER = "(Die Reihenfolge des Markierens der Kontrollkästchen bestimmt die Anordnung der Knöpfe von links nach rechts und oben nach unten)";
HOLOFRIENDS_OPTIONS0LISTENTRY = "HoloFriends";
HOLOFRIENDS_OPTIONS0NEEDACCEPT = "Um im Übertrage-Fenster wirksam zu werden, müssen die Optionen erst akzeptiert werden !";
HOLOFRIENDS_OPTIONS0NEEDRELOAD = "Um wirksam zu werden, muss man den Charakter neu laden !";
HOLOFRIENDS_OPTIONS0NOTFACTION = "Diese Option ist für Charactere, welche die fraktionsweite Freundsliste benutzen, immer aus !";
HOLOFRIENDS_OPTIONS0REALID = "Diese Option ist für BNet Freunde immer aktiv !";
HOLOFRIENDS_OPTIONS0RELATEABOVE = "Diese Option wird nur beachtet, wenn die Option eins davor nicht gesetzt oder nicht aktiv ist !";
HOLOFRIENDS_OPTIONS0RELATEBEFORE = "Diese Option wird nur beachtet, wenn die Option direkt davor gesetzt und aktiv ist !";
HOLOFRIENDS_OPTIONS0WINDOWTITLE = "HoloFriends Optionen";

HOLOFRIENDS_OPTIONS1BNCHARNAMEFIRST = "Ändere die Reihenfolge von Charactername und BettleNet-Name";
HOLOFRIENDS_OPTIONS1BNCHARNAMEFIRSTTT = "Wenn aktiviert, wird der reale Name des RealID-Freundes hinter dem Charakternamen angezeigt.";
HOLOFRIENDS_OPTIONS1BNSHOWCHARNAME = "Zeige Charactername hinter BettleNet-Name";
HOLOFRIENDS_OPTIONS1BNSHOWCHARNAMETT = "Wenn aktiviert, wird der Charaktername der RealID-Freunde hinter dem realen Namen angezeigt. Der reale Name bekommt die Farbe seiner Fraktion.";
HOLOFRIENDS_OPTIONS1DISABLEWHO = "Schalte die Auslöser von Statusabfragen der Offline-Freunde ab (schaltet Who aus)";
HOLOFRIENDS_OPTIONS1DISABLEWHOTT = "Wenn aktiviert, werden alle automatischen Statusabfragen für Offline-Freunde deaktiviert, einschließlich des /who-Scans. Nur manuell ausgeführte who-Kommandos werden zum Setzen des Status von Offline-Freunden genutzt.";
HOLOFRIENDS_OPTIONS1GROUPSSHOWONLINE = "Zeige die Anzahl der Online-Freunde hinter dem Gruppennamen";
HOLOFRIENDS_OPTIONS1GROUPSSHOWONLINETT = "Wenn aktiviert, wird die momentane Anzahl von Freunden, welche online sind, in Klammern hinter dem Gruppennamen angezeigt.";
HOLOFRIENDS_OPTIONS1SECTIONFLW = "Fenster der Freundesliste";
HOLOFRIENDS_OPTIONS1SETDATEFORMAT = "Ändere das standardmäßige Format für Datum und Uhrzeit";
HOLOFRIENDS_OPTIONS1SETDATEFORMATTT = "Wenn aktiviert, wird man zur Änderung des standardmäßigen Formats von Datum und Uhrzeit aufgefordert, welches zur Anzeige der Zeit von \"Zuletzt gesehen\" in den Tooltips der Freundesliste benutzt wird.";
HOLOFRIENDS_OPTIONS1SHOWCLASSCOLOR = "Zeige die Namen der Freunde in ihren Klassenfarben in der Freundesliste";
HOLOFRIENDS_OPTIONS1SHOWCLASSCOLORTT = "Wenn aktiviert, wird der Name der Freunde in ihren Klassenfarben in der Freundesliste angezeigt.";
HOLOFRIENDS_OPTIONS1SHOWCLASSICONS = "Zeige Klassenpiktogramme in der Freundesliste";
HOLOFRIENDS_OPTIONS1SHOWCLASSICONSTT = "Wenn aktiviert, wird vor dem Namen der Freunde ein Klassenpiktogramm in der Freundesliste angezeigt.";
HOLOFRIENDS_OPTIONS1SHOWGROUPS = "Zeige auch leere Gruppen im kompakten Modus der Freundesliste";
HOLOFRIENDS_OPTIONS1SHOWGROUPSTT = "Wenn aktiviert, werden alle Gruppen immer angezeigt, ansonsten werden im kompakten Modus (|cffffd200Offline-Freunde anzeigen|r ist im Fenster der Freundesliste nicht aktiviert) nur Gruppen mit Online-Freunden angezeigt.";
HOLOFRIENDS_OPTIONS1SHOWLEVEL = "Zeige das Level der Freunde in der Freundesliste";
HOLOFRIENDS_OPTIONS1SHOWLEVELTT = "Wenn aktiviert, wird das Level der Freundes hinter dem Freundesnamen in der Freundesliste angezeigt.";
HOLOFRIENDS_OPTIONS1SORTONLINE = "Sortiere Online-Freunde nach oben";
HOLOFRIENDS_OPTIONS1SORTONLINETT = "Wenn aktiviert, werden alle Online-Freunde in den Gruppen oben aufgelistet, gefolgt von allen Offline-Freunden.";

HOLOFRIENDS_OPTIONS2MERGENOTES = "Verbinde HoloFriends Kommentare mit den spielinternen Freund-Notizen";
HOLOFRIENDS_OPTIONS2MERGENOTESTT = "Wenn aktiviert, werden die HoloFriends Kommentare an die spielinternen Freund-Notizen angehängt oder umgekehrt, abhängig vom folgenden Prioritätenschalter.";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYOFF = "Spielinterne Freund-Notizen haben Priorität";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYOFFTT = "Wenn aktiviert, ersetzt eine geänderte spielinterne Freund-Notiz den HoloFriends Kommentar, ansonsten werden Änderungen zur spielinternen Freund-Notiz immer wieder durch den HoloFriends Kommentar ersetzt. Die HoloFriends Kommentarbearbeitung setzt allerdings immer Beides.";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYON = "HoloFriends Kommentare an spielinterne Freund-Notizen anhängen";
HOLOFRIENDS_OPTIONS2NOTESPRIORITYONTT = "Wenn aktiviert, wird die Reihenfolge des Anhängens zu spielinterne Freund-Notiz + HoloFriends Kommentar festgelgt, ansonsten ist die Reihenfolge HoloFriends Kommentar + spielinterne Freund-Notiz. (Spielinterne Freund-Notizen haben eine max. Länge von 48 Buchstaben.)";
HOLOFRIENDS_OPTIONS2SECTIONNOTES = "Handhabung spielinterner Freundesnotizen";

HOLOFRIENDS_OPTIONS3MARKREMOVE = "Markiere in der Zielliste die Gruppeneinträge, welche in der Quellenliste nicht existieren";
HOLOFRIENDS_OPTIONS3MARKREMOVETT = "Wenn aktiviert, markiert das Übertragen ganzer Gruppen die Einträge in der Zielliste, welche in der Gruppe in der Quellenliste nicht existieren. So können diese, nach dem einwählen mit dem Zielcharakter, bearbeitet (Löschen, Verschieben, ...) werden. Das Verteilen von HoloFriends löscht auf jeden Fall nichts.";
HOLOFRIENDS_OPTIONS3MERGECOMMENTS = "Verbinde HoloFriends Kommentare während dem Übertragen von Freunden";
HOLOFRIENDS_OPTIONS3MERGECOMMENTSTT = "Wenn aktiviert, werden HoloFriends Kommentare an existierende HoloFriends Kommentare während des Übertragens von deinen Freunden zu deinen anderen Charakteren angehängt.";
HOLOFRIENDS_OPTIONS3SECTIONSHARE = "Fenster zum Freunde übertragen";

HOLOFRIENDS_OPTIONS4MENUMODF = "Modifiziere die Pulldown-Menüs der verschiedenen Freund-Fenster (Chat, Who, ...)";
HOLOFRIENDS_OPTIONS4MENUMODP = "Modifiziere die Pulldown-Menüs der Gruppen-Fenster";
HOLOFRIENDS_OPTIONS4MENUMODR = "Modifiziere die Pulldown-Menüs des Raid-Fensters";
HOLOFRIENDS_OPTIONS4MENUMODT = "Modifiziere das Pulldown-Menüs des Spieler-Fensters";
HOLOFRIENDS_OPTIONS4MENUMODTT = "Wenn aktiviert, werden Einträge zu den Pulldown-Menüs hinzugefügt, um den ausgewählten Spieler in die Freundes- oder Ignorieren-Liste einzutragen oder einen WHO-Check durchzuführen.";
HOLOFRIENDS_OPTIONS4MENUNOTAINT = "Ergänze Einträge zu den Pulldown-Menüs ohne Schutzverletzung";
HOLOFRIENDS_OPTIONS4MENUNOTAINTTT = "Wenn aktiviert, werden die Ergänzungen zu den Pulldown-Menüs (siehe darunter) direkt zum Menüfenster hinzugefügt. Dadurch bleibt das original Menü ohne Schutzverletzung erhalten. Wenn nicht aktiviert, werden die Menüeinträge (siehe darunter) auf normalem Wege hinzugefügt. |cffffd200Das deaktiviert aber den Eintrag zum setzen des Fokus und Tank.|r";
HOLOFRIENDS_OPTIONS4SECTIONMENU = "Modifikationen an Pulldown-Menüs";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNALLBG = "Undurchsichtiger Hintergrund bei allen Standard-Pulldown-Menüs";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNALLBGTT = "Wenn aktiviert, wird allen Pulldown-Menüs im Spiel, welche die Standard-Vorlage für Pulldown-Menüs verwenden, ein schwarzer undurchsichtiger Hintergrund hinzugefügt.";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNBG = "Undurchsichtiger Hintergrund bei Pulldown-Menüs";
HOLOFRIENDS_OPTIONS4SHOWDROPDOWNBGTT = "Wenn aktiviert, wird allen Pulldown-Menüs von HoloFriends ein schwarzer undurchsichtiger Hintergrund hinzugefügt.";

HOLOFRIENDS_OPTIONS5SECTIONSTART = "Modifikationen des Starts";
HOLOFRIENDS_OPTIONS5SHOWONLINEATLOGIN = "Zeige die Online-Freunde während des Login";
HOLOFRIENDS_OPTIONS5SHOWONLINEATLOGINTT = "Wenn aktiviert, wird eine Liste aller aktiven Online-Freunde im Chat-Fenster während des Login angezeigt.";

HOLOFRIENDS_OPTIONS6MSGIGNOREDWHISPER = "Sende eine Notiez zu offline ignorierten Flüsterern";
HOLOFRIENDS_OPTIONS6MSGIGNOREDWHISPERTT = "Wenn aktiviert, wird automatisch eine Notiez, dass du sie ignorierst, zu offline ignorierten Spielern gesendet, welche dich anflüstern, ansonsten wird der gesamte Chat stumm ignoriert.";
HOLOFRIENDS_OPTIONS6SECTIONIGNORE = "Ignorieren von Spielern";

HOLOFRIENDS_OPTIONS7ADDFRIENTTT = "Füge den anvisierten Spieler zu deiner Freundesliste hinzu oder ohne etwas Anvisiertes tippe den Namen";
HOLOFRIENDS_OPTIONS7INVITETT = "Lade den hervorgehobenen Freund in deine Gruppe ein";
HOLOFRIENDS_OPTIONS7REMOVEFRIENDTT = "Entferne den hervorgehobenen Freund von der Freundesliste";
HOLOFRIENDS_OPTIONS7SECTIONFLBUTTONS = "Angezeigte Knöpfe in der Freundes-Liste";
HOLOFRIENDS_OPTIONS7WHISPERTT = "Sende dem hervorgehobenen Freund eine Flüsternachricht";
HOLOFRIENDS_OPTIONS7WHOTT = "Fordere erweiterte Informationen über den hervorgehobenen Freund an (Wird im Chat angezeigt)";

HOLOFRIENDS_OPTIONS87ADDCOMMENTTT = "Füge einen Kommentar zum hervorgehobenen Listeneintrag hinzu";
HOLOFRIENDS_OPTIONS87ADDGROUPTT = "Füge eine Gruppe zur Liste hinzu";
HOLOFRIENDS_OPTIONS87REMOVEGROUPTT = "Entferne die hervorgehobene Gruppe";
HOLOFRIENDS_OPTIONS87RENAMEGROUPTT = "Benenne die hervorgehobene Gruppe um";

HOLOFRIENDS_OPTIONS8ADDIGNORETT = "Füge den anvisierten Spieler zu deiner Inorierenliste hinzu oder ohne etwas Anvisiertes tippe den Namen";
HOLOFRIENDS_OPTIONS8REMOVEIGNORETT = "Entferne den hervorgehobenen Spieler fon der Ignorierenliste";
HOLOFRIENDS_OPTIONS8SECTIONILBUTTONS = "Angezeigte Knöpfe in der Ignorieren-Liste";

-- ####################################################################

HOLOFRIENDS_SHAREFRIENDSWINDOWTITLE = "Freunde übertragen";
HOLOFRIENDS_SHAREIGNOREWINDOWTITLE = "Ignorierte übertragen";
HOLOFRIENDS_SHAREWINDOWBUTTONSEPARATE = "Separieren";
HOLOFRIENDS_SHAREWINDOWDELETENOTE = [=[HINWEIS: Um Daten von bereits gelöschten Charakteren zu entfernen, benutze:
|cffffd200/holofriends delete {name} [at {realm}]|r]=];
HOLOFRIENDS_SHAREWINDOWFACTIONNOTEADD = "Wähle einen Charakter, um ihn hinzuzufügen";
HOLOFRIENDS_SHAREWINDOWFACTIONNOTEPULLDOWN = "Am Pulldown-Menü:";
HOLOFRIENDS_SHAREWINDOWFACTIONNOTESEPARATE = "Wähle deine Fraktion und markiere einen |cff999999(Charakter)|r deiner Charakerliste, um ihn zu separieren";
HOLOFRIENDS_SHAREWINDOWFACTIONTITLE = "Bedienung der fraktionsweiten Liste";
HOLOFRIENDS_SHAREWINDOWNOTE = "Das Übertragen wird direkt nach dem Klick auf die Knöpfe \"Hinzufügen\" oder \"Aktualisieren\" ausgeführt";
HOLOFRIENDS_SHAREWINDOWSOURCE = "Freunde auswählen:";
HOLOFRIENDS_SHAREWINDOWTARGET = "Übertrage an:";

-- ####################################################################

HOLOFRIENDS_TOOLTIPBROADCAST = "BNet-Nachricht an alle Freunde:";
HOLOFRIENDS_TOOLTIPDATEFORMAT = "%A %d.%m.%Y %H:%M";
HOLOFRIENDS_TOOLTIPDISABLEDMENUENTRYHINT = [=[Um diesen Menüeintrag zu aktivieren,
müssen die HoloFriends Menümodifikationen
für dieses Menü im HoloFriends
Optionenfenster deaktivieren.]=];
HOLOFRIENDS_TOOLTIPDISABLEDMENUENTRYTITLE = "HoloFriends-Addon";
HOLOFRIENDS_TOOLTIPLASTSEEN = "Zuletzt gesehen";
HOLOFRIENDS_TOOLTIPNEVERSEEN = "bisher nicht gesehen";
HOLOFRIENDS_TOOLTIPSHAREBUTTON = "Übertrage diese Liste zu anderen Charakteren";
HOLOFRIENDS_TOOLTIPTURNINFOTEXT = "Wechselt die Info, welche hinter den Freundesnamen gezeigt wird zum Kommentar und zurück zur Region";
HOLOFRIENDS_TOOLTIPTURNINFOTITLE = "Info wechseln";
HOLOFRIENDS_TOOLTIPUNKNOWN = "?";

end
