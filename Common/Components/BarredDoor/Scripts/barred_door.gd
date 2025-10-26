class_name BarredDoor extends Node


@export var pressure_plate: PressurePlate

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if pressure_plate != null:
		pressure_plate.activated.connect( _on_plate_actived_ )
		pressure_plate.deactivated.connect( _on_plate_deactived_ )
		animation_player.animation_finished.connect( _on_anime_finished_ )
	pass # Replace with function body.

func _exit_tree() -> void:
	pressure_plate.activated.disconnect( _on_plate_actived_ )
	pressure_plate.deactivated.disconnect( _on_plate_deactived_ )
	animation_player.animation_finished.disconnect( _on_anime_finished_ )
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_plate_actived_() -> void:
	open = true
	_open_or_close_door()
	pass

func _on_plate_deactived_() -> void:
	open = false
	_open_or_close_door()
	pass

func _on_anime_finished_(anim_name: StringName) -> void:
	print('动画播放完毕')
	if open == true:
		print('隐藏门')
		collision_shape_2d.set_deferred("disabled", true)
	pass

func _open_or_close_door() -> void:
	
	var curr_animate_position: float = 0.0
	if animation_player.current_animation != "":
		curr_animate_position = animation_player.get_section_start_time()
		
	if open == true :
		animation_player.play_section("open",curr_animate_position)
	else :
		collision_shape_2d.set_deferred("disabled", false)
		animation_player.play_section_backwards("open",curr_animate_position)
	pass
