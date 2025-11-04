class_name PlayerStateAttack extends PlayerState


@export var attack_sound: AudioStream
@export_range(1, 20, 0.5) var decelerate_speed: float = 5.0

#是否处于攻击状态
var attacking: bool = false
@onready var walk: PlayerState = $"../Walk"
@onready var idle: PlayerState = $"../Idle"

func init() -> void:
	pass

### 
func enter() -> void:
	character.update_animation("attack")
	character.update_animation("attack", CommonVar.AnimType.EFFECT)
	if character.get_animation_player():
		character.get_animation_player().animation_finished.connect( _end_attacked_ )
	
	if character.get_audio():
		character.get_audio().stream = attack_sound
		character.get_audio().pitch_scale = randf_range(.9, 1.1)
		character.get_audio().play()

	attacking = true
	await get_tree().create_timer(0.075).timeout
	if attacking == true:
		_open_and_close_hit_box()
	pass
	
func exit() -> void:
	if character.get_animation_player():
		character.get_animation_player().animation_finished.disconnect( _end_attacked_ )
	_open_and_close_hit_box()
	pass
	
func _process_(_delta: float) -> PlayerState:
	character.velocity -= character.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if character.direction == Vector2.ZERO:
			return idle
		return walk
	return null
	
func _physics_process_(_delta: float) -> PlayerState:
	return null

func _end_attacked_(_newAniName: String) -> void:
	attacking = false
	_open_and_close_hit_box()
	pass

func _open_and_close_hit_box() -> void:
	var hit_box = character.get_hit_box()
	if hit_box:
		## 关闭打击框能被受击框检测
		hit_box.monitoring = attacking
