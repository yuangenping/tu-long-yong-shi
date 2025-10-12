class_name EnemyStateStun extends EnemyState


@export var anim_name: String = "stun"
# 击退速度
@export var knockback_speed: float = 200.0
# 减速速度
@export var decelerate_speed: float = 10.0


@export_category("AI")

var _damage_position: Vector2
var _direction: Vector2
var _animation_finished: bool = false


func init() -> void:
	character.character_being_hurted.connect(_on_enemy_damaged)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

 
func enter() -> void:
	character.invulnerable = true
	_animation_finished = false
	
	# 获取玩家的全局坐标	
	_direction = character.global_position.direction_to(_damage_position)
	
	character.direction = _direction
	character.set_direction()
	character.velocity = _direction * -knockback_speed
	
	character.update_animation(anim_name)
	character.animation_player.animation_finished.connect(_on_animation_finished)
	pass
	
func exit() -> void:
	character.invulnerable = false
	character.animation_player.animation_finished.disconnect(_on_animation_finished)
	pass
	
func _process_(_delta: float) -> EnemyState:
	if _animation_finished:
		return next_state
	character.velocity -= character.velocity * decelerate_speed * _delta
	return null
	
func _physics_process_(_delta: float) -> EnemyState:
	return null


func _on_enemy_damaged(hit_box: HitBox) -> void:
	_damage_position = hit_box.global_position
	state_machine.change_state(self)

func _on_animation_finished(_a: String) -> void:
	_animation_finished = true
	pass
