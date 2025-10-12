class_name PlayerInteractionsHost extends Node2D

@onready var player: Player = $".."

func _ready() -> void:
	player.direction_changed.connect( _updage_deg_ )
	pass # Replace with function body.


func _updage_deg_( new_direction: Vector2 ) -> void:
	rotation_degrees = UtilManager.get_new_ratation_deg_by_dir( new_direction )
	pass 
