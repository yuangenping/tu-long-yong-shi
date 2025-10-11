class_name Enemy extends CharacterBody2D

signal direction_changed( new_direction: Vector2 )
signal enemy_damaged( hurt_box: HurtBox )
signal enemy_destroyed( hurt_box: HurtBox )


var DIR_4: Array = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var hp: int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player: Player
# 是否为无敌状态
var invulnerable : bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $HitBox
@onready var enemy_state_machine: EnemyStateMachine = $EnemyStateMachine



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_state_machine.initialize( self )
	player = PlayerManager.player
	hit_box.connect("Damaged", _task_damaged )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()
	

func SetDirection( _new_direction : Vector2) -> bool:
	var dir_index: int = UtilManager.get_dir_index(_new_direction,DIR_4.size(), cardinal_direction * 0.1 )
	direction = DIR_4[ dir_index ]
	if direction == Vector2.ZERO || _new_direction == cardinal_direction:
		return false
	cardinal_direction = direction
	emit_signal("direction_changed", direction)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func update_animation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection())


func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN :
		return "down"
	elif cardinal_direction == Vector2.UP :
		return "up"
	else :
		return "side"


func _task_damaged( hurt_box: HurtBox ) -> void:
	if invulnerable :
		return
	hp -= hurt_box.damage
	if hp > 0 :
		enemy_damaged.emit( hurt_box )
	else :
		enemy_destroyed.emit( hurt_box )
