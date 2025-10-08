@tool
class_name  LevelTranstion extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file( "*.tscn" ) var level

@export var id : String

@export_category("Collition Area Settings")

@export_range(1, 12, 1, "or_greater") var size : int = 2 :
	set( _new_value ):
		size = _new_value
		_update_area()

@export var side : SIDE = SIDE.LEFT :
	set( _new_value ):
		side = _new_value
		_update_area()

@export var snap_to_grid : bool = false : 
	set( _new_value ):
		snap_to_grid = _new_value
		if snap_to_grid :
			_update_area()

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert( id !=null, "id 不能为空")
	_update_area()
	# 如果处于编辑器当中
	if Engine.is_editor_hint():
		return
	
	monitoring = false
	_place_player() 
	
	await  LevelManager.level_loaded
	
	monitoring = true
	
	body_entered.connect( _player_entered )	
	
	pass # Replace with function body.


func _place_player() -> void:
	if id != LevelManager.transition_id:
		return 
	PlayerManager.set_player_position( get_player_new_pos() )

func get_player_new_pos() -> Vector2:
	var new_pos : Vector2 = Vector2.ZERO
	var size : Vector2 = collision_shape_2d.shape.size
	if side == SIDE.LEFT || side == SIDE.RIGHT : 
		new_pos.y = global_position.y 
		new_pos.x = global_position.x + size.x if side == SIDE.LEFT else global_position.x - size.x
	else:
		new_pos.x = global_position.x
		new_pos.y = global_position.y + size.y if side == SIDE.TOP else global_position.y - size.y
	print("=====================================")
	print("new_pos", new_pos)
	print("=====================================")
	return new_pos
			

func _update_area() -> void:
	var new_rect : Vector2 = Vector2( 32, 32)
	var new_position : Vector2 = Vector2.ZERO
	
	match side:
		SIDE.TOP:
			new_rect.x = new_rect.x * size
			#new_position.y -= 16
		SIDE.BOTTOM:
			new_rect.x = new_rect.x * size
			#new_position.y += 16
		SIDE.LEFT:
			new_rect.y = new_rect.y * size
			#new_position.x += 16
		SIDE.RIGHT:
			new_rect.y = new_rect.y * size
			#new_position.x -= 16
	if collision_shape_2d == null :
		collision_shape_2d = $CollisionShape2D
	collision_shape_2d.shape.size = new_rect
	collision_shape_2d.position = new_position
	if snap_to_grid :
		_snap_to_grid()
	pass


func _snap_to_grid() -> void:
	position.x = roundi( position.x / 16 ) * 16
	position.y = roundi( position.y / 16 ) * 16
	pass

func _player_entered( _p : Node2D) -> void:
	# TODO
	LevelManager.load_new_level(level, id )	
	pass
