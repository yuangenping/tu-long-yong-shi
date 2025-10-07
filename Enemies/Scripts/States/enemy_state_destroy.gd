class_name EnemyStateDestroy extends EnemyState


const PICKUP = preload("uid://0gcebmwj7ii8")


@export var anim_name : String = "destroy"
# 击退速度
@export var knockback_speed : float = 200.0
# 击退减速速度
@export var decelerate_speed : float = 10.0


@export_category("Items Drops")
@export var drops : Array[ DropData ]

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
	disabled_hurt_box()
	drop_items()
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

func disabled_hurt_box() -> void:
	var hurt_box : HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box :
		print("关闭伤害区域,防止误伤")
		hurt_box.monitoring = false


func drop_items() -> void:
	if drops.is_empty():
		return
	
	for i in drops.size():
		if drops[ i ] == null || drops[ i ].item == null:
			continue
		
		var drop_count : int = drops[ i ].get_drop_count()
		for j in drop_count:
			var drop : ItemPickUp = PICKUP.instantiate() as ItemPickUp
			drop.item_data = drops[ i ].item
			enemy.get_parent().call_deferred( "add_child", drop)
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated( randf_range( -1.5, 1.5 ) ) * randf_range( 0.9, 1.5 )
	pass
