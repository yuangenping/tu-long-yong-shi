class_name EnemyStateStun extends EnemyState


@export var anim_name : String = "stun"
# 击退速度
@export var knockback_speed : float = 200.0
# 减速速度
@export var decelerate_speed : float = 10.0


@export_category("AI")
@export var next_state : EnemyState


var _damage_position : Vector2
var _direction : Vector2
var _animation_finished: bool = false


func init() -> void:
	enemy.connect("enemy_damaged", _on_enemy_damaged)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

 
func Enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false
	
	# 获取玩家的全局坐标	
	_direction = enemy.global_position.direction_to( _damage_position )
	
	enemy.SetDirection( _direction )
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_animation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	pass
	
func Exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect( _on_animation_finished )
	pass
	
func Process( _delta: float ) -> EnemyState:
	if _animation_finished :
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func Physics( _delta: float ) -> EnemyState:
	return null


func _on_enemy_damaged( hurt_box: HurtBox ) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state( self )


func _on_animation_finished( _a : String) -> void:
	_animation_finished = true
	pass
