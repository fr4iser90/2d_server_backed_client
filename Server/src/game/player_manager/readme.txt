1. Server-Komponenten
A. Instance Manager

	Funktion: Verwaltung der Instanzen, Zuordnung der Spieler zu Instanzen.
	Daten:
		instance_key: Eindeutiger Schlüssel für jede Instanz.
		players: Eine Liste von Spielern, die der Instanz zugeordnet sind.
		scene_name: Name der Szene, die in der Instanz geladen ist.

B. Instance Movement Manager

	Funktion: Verfolgt und synchronisiert die Bewegungsdaten der Spieler innerhalb einer Instanz.
	Daten:
		player_positions: Speichert die Positionen und Bewegungsdaten aller Spieler nach peer_id.
		players_in_instances: Eine Zuordnung von Spielern zu ihren Instanzen (peer_id zu instance_key).
		channels: Definiert Kommunikationskanäle (z. B. für Bewegungsdaten).

C. Netzwerk-Handler (PlayerMovementHandler)

	Funktion: Verarbeitet eingehende Bewegungsdaten und verteilt sie an andere Spieler in der gleichen Instanz.
	Daten:
		peer_id: Identifikation des Spielers.
		position, velocity: Bewegungsdaten, die empfangen und weitergeleitet werden.
		instance_key: Prüft, in welcher Instanz der Spieler sich befindet und sendet die Daten an die Spieler der gleichen Instanz.

2. Client-Komponenten
A. Client Movement Manager

	Funktion: Sendet Bewegungsdaten des Spielers an den Server und verarbeitet die Bewegungsdaten anderer Spieler, die vom Server empfangen werden.
	Daten:
		peer_id: Eindeutige Identifikation des Spielers.
		position, velocity: Bewegungsdaten, die an den Server gesendet oder von anderen Spielern empfangen werden.
		instance_key: Informationen darüber, in welcher Instanz der Spieler sich befindet.

B. Client Packet Manager

	Funktion: Verarbeitet Pakete, die vom Server empfangen werden, und verteilt sie an die entsprechenden Handler (z. B. Bewegungen, Nachrichten).
	Daten:
		handler_name: Bezeichnet den spezifischen Handler (z. B. PlayerMovementHandler).
		data: Die eigentlichen Daten (z. B. Bewegungsdaten, Nachrichten) zur weiteren Verarbeitung.

3. Kommunikationsstruktur (Client <-> Server)
A. Datenpaketstruktur

	Bewegungsdatenpaket:
		peer_id: Identifiziert den Spieler.
		position: Position des Spielers.
		velocity: Geschwindigkeit und Richtung.
		instance_key: Die Instanz, in der der Spieler sich befindet.

B. Kommunikation über Kanäle (Channels)

	Bewegungskanal (z. B. Channel 1): Überträgt Bewegungsdaten innerhalb einer Instanz.
	Nachrichtenkanal (z. B. Channel 2): Überträgt Nachrichten und Statusupdates über Instanzen hinweg.

4. Zusammenfassung der Schritte

	Bewegungsdaten an den Server senden: Jeder Client sendet seine Bewegungsdaten an den Server, zusammen mit seiner peer_id und dem instance_key.

	Server verarbeitet Bewegungsdaten: Der Server empfängt die Daten und leitet sie an alle Spieler weiter, die sich in derselben Instanz befinden.

	Client empfängt und verarbeitet Daten: Jeder Client erhält die Bewegungsdaten der anderen Spieler in seiner Instanz und aktualisiert ihre Positionen entsprechend.

Diese Struktur sorgt dafür, dass die Bewegungen der Spieler korrekt innerhalb ihrer Instanzen synchronisiert und nur an relevante Spieler verteilt werden.
