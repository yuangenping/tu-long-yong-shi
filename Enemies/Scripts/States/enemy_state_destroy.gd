class_name EnemyStateDestroy extends EnemyState


@export var anim_name : String = "destroy"
# 击退速度
@export var knockback_speed : float = 200.0
# 击退减速速度
@export var decelerate_speed : float = 10.0


# 伤害区域的全局坐标
var _damage_position : Vector2
var _direction : Vector2

func init() -> void:
	enemy.enemy_destroyed.connect( _on_enemy_destroy )
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

 
func Enter() -> void:
	enemy.invulnerable = true
	# 获取玩家的全局坐标	
	_direction = enemy.global_position.direction_to( _damage_position )
	
	enemy.SetDirection( _direction )
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_animation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	pass
	
func Exit() -> void:
	pass
	
func Process( _delta: float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func Physics( _delta: float ) -> EnemyState:
	return null


func _on_enemy_destroy( hurt_box: HurtBox ) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state( self )


func _on_animation_finished( _a : String) -> void:
	enemy.queue_free()
	pass
