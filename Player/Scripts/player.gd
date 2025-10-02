class_name Player extends CharacterBody2D

# 玩家最终保持的朝向
var cardinal_direction: Vector2 = Vector2.DOWN
# 玩家按下键盘时,人物的朝向
var direction: Vector2 = Vector2.ZERO

var DIR_4: Array = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

signal DirectionChanged( new_direction: Vector2 )


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.Initalize(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	direction = Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down")
	)
	direction = direction.normalized()
	

func _physics_process(delta: float) -> void:
	move_and_slide()

func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
		
	var new_dir: Vector2 = cardinal_direction
	
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	#print("cardinal_direction", cardinal_direction)
	#print("direction_id", direction_id)
	
	new_dir = DIR_4[ direction_id ]
	
	#if direction.y == 0:
		#new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	#elif direction.x == 0:
		#new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	emit_signal("DirectionChanged", cardinal_direction)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
func UpdateAnimation( state: String ) -> void:
	animation_player.play( state + "_" + AnimDirection() )
	pass
	
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN :
		return "down"
	elif cardinal_direction == Vector2.UP :
		return "up"
	else :
		return "side"
	
