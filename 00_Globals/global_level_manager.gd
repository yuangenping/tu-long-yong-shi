extends Node

signal level_load_started
signal level_loaded

signal tilemap_bounds_changed( bounds : Array[ Vector2 ] )

var current_tilemap_bounds : Array[ Vector2 ]
var transition_id : String
var position_offset : Vector2


func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()


func ChangeTileMapBounds( bounds : Array[ Vector2 ] ) -> void:
	current_tilemap_bounds = bounds
	emit_signal("tilemap_bounds_changed", bounds )


func load_new_level(
	level_path : String,
	_transition_id : String
) -> void:
	
	get_tree().paused = true
	transition_id = _transition_id
	
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file( level_path )
	
	get_tree().paused = false
	
	await SceneTransition.fade_in()
	
	level_loaded.emit()
	
	pass
