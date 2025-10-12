class_name EnemyStateWander extends EnemyState



@export var anim_name : String = "walk"

@export var wander_speed : float = 20	

@export_category("AI")
@export var state_animation_duration : float = 0.7
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3

var _timer : float = 0.0
var _direction : Vector2

func init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

 
func enter() -> void:
	_timer = randi_range( state_cycles_min, state_cycles_max ) * state_animation_duration
	var rand = randi_range( 0, CommonVar.CHARACTER_DIR.size() - 1)
	_direction = CommonVar.CHARACTER_DIR[ rand ]
	character.velocity = _direction * wander_speed
	character.direction = _direction
	character.set_direction()
	character.update_animation( anim_name )
	pass
	
func exit() -> void:
	pass
	
func _process_( _delta: float ) -> CommonState:
	_timer -= _delta
	if _timer <= 0 : 
		return next_state
	
	return null
	
func _physics_process_( _delta: float ) -> CommonState:
	return null
