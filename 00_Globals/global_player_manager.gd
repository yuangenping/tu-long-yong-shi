extends Node


const PLAYER = preload("uid://crc7qu7pjljfx")
const PLAYER_INVENTORY_DATA = preload("uid://c1kskxxje5w3q")

## 游戏玩家对象
var player : CommonCharacter
var player_spawned : bool = false


var hp : int = 6
var  max_hp : int  = 6
# 每颗星代表多少颗血
var hp_length : int = 2


func _ready() -> void: 
	add_player_instance()

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child( player )
	pass

func set_player_position( _new_pos : Vector2 ) -> void:
	player.global_position = _new_pos
	pass

func set_as_parent( _p : Node2D ) -> void:
	if player.get_parent():
		player.get_parent().remove_child( player )
	_p.add_child(player)
	pass

func unparent_player( _p : Node2D ) -> void:
	_p.remove_child( player )
