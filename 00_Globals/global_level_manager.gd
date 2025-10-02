extends Node

var current_tilemap_bounds : Array[ Vector2 ]
signal tilemap_bounds_changed( bounds : Array[ Vector2 ] )

func ChangeTileMapBounds( bounds : Array[ Vector2 ] ) -> void:
	current_tilemap_bounds = bounds
	emit_signal("tilemap_bounds_changed", bounds )
