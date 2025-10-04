extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_deferred("visible", false)
	if PlayerManager.player_spawned == false :
		PlayerManager.set_player_position( global_position )
		PlayerManager.player_spawned = true
		
	pass # Replace with function body.
