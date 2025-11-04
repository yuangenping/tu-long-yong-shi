class_name PlayerStateIdle extends PlayerState

@onready var walk: PlayerState = $"../Walk"
@onready var attack: PlayerState = $"../Attack"

func init() -> void:
	pass

## 切换到当前state:
func enter() -> void:
	character.update_animation("idle")
	pass
	
func exit() -> void:
	pass
	
func _process_(_delta: float) -> PlayerState:
	if character.direction != Vector2.ZERO:
		return walk
	character.velocity = Vector2.ZERO
	return null
	
func _physics_process_(_delta: float) -> PlayerState:
	return null

func _event_attacked_() -> PlayerState:
	return attack
