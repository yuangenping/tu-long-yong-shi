class_name Player extends CharacterBody2D

# 玩家最终保持的朝向
var cardinal_direction: Vector2 = Vector2.DOWN
# 玩家按下键盘时,人物的朝向
var direction: Vector2 = Vector2.ZERO
# 无敌状态
var invulnerable : bool = false


var DIR_4: Array = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox

signal DirectionChanged( new_direction: Vector2 )
signal player_damaged( hurt_box : HurtBox )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initalize(self)
	hit_box.Damaged.connect( _take_damage )
	update_hp(PlayerManager.max_hp)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = GlobalUtil.get_normalized_dir()
	
	

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
	
func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable :
		return
	update_hp( -hurt_box.damage )
	player_damaged.emit( hurt_box )
	#if PlayerManager.hp > 0 :
		#player_damaged.emit( hurt_box )
	#else :
		#player_damaged.emit( hurt_box )
		
	pass
	

func update_hp( delta : int ) -> void:
	PlayerManager.hp = clamp(PlayerManager.hp + delta, 0, PlayerManager.max_hp)
	PlayerHud.update_hp()
	pass
	

func make_invulnerable( _duration : float  = 1.0 ) -> void:
	invulnerable = true
	hit_box.set_deferred("monitorable", false)
	await get_tree().create_timer( _duration ).timeout
	invulnerable = false
	hit_box.set_deferred("monitorable", true)
	pass
