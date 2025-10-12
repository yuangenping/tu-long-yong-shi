class_name PlayerStateWalk extends PlayerState

var anim_name = 'walk'

@export var move_speed: float = 100.0
@onready var idle: PlayerState = $"../Idle"
@onready var attack: PlayerState = $"../Attack"

func init() -> void:
	pass

### 
func enter() -> void:
	character.update_animation(anim_name)
	pass
	
func exit() -> void:
	pass


func _process_(_delta: float) -> PlayerState:
	if character.direction == Vector2.ZERO:
		return idle
	
	character.velocity = character.direction * move_speed
	
	if character.set_direction():
		character.update_animation(anim_name)
	return null
	
func _physics_process_(_delta: float) -> PlayerState:
	return null

func _event_attacked_() -> PlayerState:
	return attack
