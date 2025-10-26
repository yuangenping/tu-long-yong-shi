class_name  LevelTileMap extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rendering_quadrant_size = 32
	z_index = -9 # 地图的zIndex设置为-9，使其在最底层
	LevelManager.ChangeTileMapBounds( GetTilemapBounds() )
	pass # Replace with function body.

func GetTilemapBounds() -> Array[ Vector2 ]:
	var bounds : Array[ Vector2 ] = []
	print("tilemap position", get_used_rect().position)
	print("tilemap end", get_used_rect().end)
	bounds.append(
		Vector2( get_used_rect().position * rendering_quadrant_size )
	)
	bounds.append(
		Vector2( get_used_rect().end * rendering_quadrant_size )
	)
	return bounds
