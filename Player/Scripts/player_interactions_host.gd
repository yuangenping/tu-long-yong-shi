class_name PlayerInteractionsHost extends Node2D

@onready var player: Player = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect( "DirectionChanged" , UpdateDirection )
	pass # Replace with function body.


func UpdateDirection( new_direction: Vector2 ) -> void:
	rotation_degrees = UtilManager.get_new_ratation_deg_by_dir( new_direction )
	pass 
