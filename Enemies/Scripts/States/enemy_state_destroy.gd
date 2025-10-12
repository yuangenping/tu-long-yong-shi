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
	character.character_destroyed.connect( _on_enemy_destroy )
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

 
func enter() -> void:
	character.invulnerable = true
	# 获取玩家的全局坐标	
	_direction = character.global_position.direction_to( _damage_position )
	
	character.direction = _direction
	character.set_direction()
	character.velocity = _direction * -knockback_speed
	
	character.update_animation( anim_name )
	character.animation_player.animation_finished.connect( _on_animation_finished )
	disabled_hurt_box()
	drop_items()
	pass
	
func exit() -> void:
	pass
	
func _process_( _delta: float ) -> EnemyState:
	character.velocity -= character.velocity * decelerate_speed * _delta
	return null
	
func _physics_process_( _delta: float ) -> EnemyState:
	return null


func _on_enemy_destroy( hit_box: HitBox ) -> void:
	_damage_position = hit_box.global_position
	state_machine.change_state( self )


func _on_animation_finished( _a : String) -> void:
	character.queue_free()
	pass

func disabled_hurt_box() -> void:
	var hit_box : HitBox = character.get_node_or_null("HitBox")
	if hit_box :
		print("关闭伤害区域,防止误伤")
		hit_box.monitoring = false


## 掉落物品
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
			character.get_parent().call_deferred( "add_child", drop)
			drop.global_position = character.global_position
			drop.velocity = character.velocity.rotated( randf_range( -1.5, 1.5 ) ) * randf_range( 0.9, 1.5 )
	pass
