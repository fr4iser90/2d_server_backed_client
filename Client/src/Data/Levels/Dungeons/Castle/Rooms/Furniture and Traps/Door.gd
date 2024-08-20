extends StaticBody2D

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

func open() -> void:
	if is_multiplayer_authority():  # Nur auf dem Server ausführen
		animation_player.play("open")
		# Falls notwendig, hier ein Signal oder RPC senden, um die Clients zu informieren
		rpc("play_open_animation_on_clients")

# RPC-Funktion, um die Animation auf den Clients zu synchronisieren
@rpc
func play_open_animation_on_clients() -> void:
	animation_player.play("open")
