class_name State_Walk extends State


var anim_name = 'walk'

@export var move_speed: float = 100.0
@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"



### 
func Enter() -> void:
	player.UpdateAnimation( anim_name )
	pass
	
func Exit() -> void:
	pass
	
func Process( _delta: float ) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation( anim_name)
	return null
	
func Physics( _delta: float ) -> State:
	return null

func event_attack() -> State:
	return attack
