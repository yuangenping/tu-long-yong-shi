class_name PlayerStateStun extends PlayerState


@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

@onready var idle: PlayerState = $"../Idle"

var direction: Vector2
var invulnerable : bool = false
var hit_box : HitBox


func init() -> void:
	character.character_being_hurted.connect( _player_being_hurted_ )
	pass

### 
func enter() -> void:
	character.get_animation_player().animation_finished.connect( _animation_finished )
	direction = character.global_position.direction_to( hit_box.global_position )
	character.velocity = direction * -knockback_speed
	character.set_direction()
	character.update_animation("stun")
	character.make_invulnerable( invulnerable_duration )
	character.get_hurt_effect_anim_player().play("damaged")
	pass
	
func exit() -> void:
	character.get_animation_player().animation_finished.disconnect( _animation_finished )
	next_state = null
	pass
	
func _process_( _delta: float ) -> PlayerState:
	character.velocity -= character.velocity * decelerate_speed * _delta
	return next_state
	
func _physics_process_( _delta: float ) -> PlayerState:
	return null

func _player_being_hurted_( _hit_box: HitBox ) -> void:
	hit_box = _hit_box
	state_machine.change_state( self )
	pass
	
func _animation_finished( _a: String ) -> void:
	next_state = idle
