class_name PlayerCamera extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.connect("tilemap_bounds_changed", UpdateLimits)
	UpdateLimits( LevelManager.current_tilemap_bounds )
	pass # Replace with function body.



func UpdateLimits( bounds: Array[ Vector2 ] ) -> void:
	print("bounds", bounds)
	if( bounds.is_empty() ): return
	limit_left = int( bounds[0].x )
	limit_top = int( bounds[0].y )
	limit_right = int( bounds[1].x )
	limit_bottom = int( bounds[1].y )
