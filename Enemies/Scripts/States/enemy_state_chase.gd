class_name EnemyStateChase extends EnemyState


@export var anim_name: String = "chase"

## 追击速度
@export var chase_speed: float = 20

## 转向速度
@export var turn_rate: float = 0.25

@export_category("AI")
@export var vision_area: VisionArea
@export var attack_area: HurtBox
## 失去视野后还继续追击多长时间
@export var state_aggro_duration: float = 10.0

var _timer: float = 0.0
var _direction: Vector2
var _can_see_player: bool = false


func init() -> void:
	if vision_area:
		vision_area.player_entered.connect(_on_player_entered)
		vision_area.player_exited.connect(_on_player_exited)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

 
func enter() -> void:
	_timer = state_aggro_duration
	character.update_animation(anim_name)
	if attack_area:
		attack_area.monitoring = true
	pass
	
func exit() -> void:
	if attack_area:
		attack_area.monitoring = false
	pass
	
func _process_(_delta: float) -> EnemyState:
	# var new_dir : Vector2 = character.global_position.direction_to( PlayerManager.player.global_position )
	# _direction =   _direction.lerp( new_dir, turn_rate )
	# character.velocity = _direction * chase_speed
	# if character.SetDirection( _direction ):
	# 	character.update_animation( anim_name )
	character.pursuit_other_character(PlayerManager.player, turn_rate, chase_speed)
		
	if _can_see_player == false:
		_timer -= _delta
		if _timer <= 0:
			return next_state
	else:
		_timer = state_aggro_duration
	return null
	
func _physics_process_(_delta: float) -> EnemyState:
	return null


func _on_player_entered() -> void:
	_can_see_player = true
	if state_machine.current_state is EnemyStateStun:
		return
	state_machine.change_state(self)
	pass

func _on_player_exited() -> void:
	_can_see_player = false
	pass
