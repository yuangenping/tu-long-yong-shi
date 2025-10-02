class_name Enemy extends CharacterBody2D

signal direction_changed( new_direction: Vector2 )
signal enemy_damaged()

var DIR_4: Array = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var hp: int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player: Player
# 是否为无敌状态
var invulnerable : bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_state_machine: EnemyStateMachine = $EnemyStateMachine



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_state_machine.initialize( self )
	player = PlayerManager.player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()
	

func SetDirection( _new_direction : Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
		
	
	
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	#print("cardinal_direction", cardinal_direction)
	#print("direction_id", direction_id)
	
	var new_dir = DIR_4[ direction_id ]
	
	#if direction.y == 0:
		#new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	#elif direction.x == 0:
		#new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	emit_signal("direction_changed", new_dir)
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
