class_name State_Attack extends State


@export var attack_sound: AudioStream
@export_range(1,20,0.5) var decelerate_speed : float = 5.0

#是否处于攻击状态
var attacking: bool = false
@onready var walk:State = $"../Walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var idle: State_Idle = $"../Idle"
@onready var attack_anim: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio: AudioStreamPlayer = $"../../Audio/AudioStreamPlayer"
@onready var hurt_box: HurtBox = %HurtBox



### 
func Enter() -> void:
	player.UpdateAnimation("attack")
	attack_anim.play('attack_' + player.AnimDirection())
	animation_player.connect("animation_finished", EndAttack )
	audio.stream = attack_sound
	audio.pitch_scale = randf_range( .9, 1.1 )
	audio.play()
	attacking = true
	
	await get_tree().create_timer( 0.075 ).timeout
	if attacking == true:
		hurt_box.monitoring = true
	pass
	
func Exit() -> void:
	animation_player.disconnect("animation_finished", EndAttack)
	hurt_box.monitoring = false
	pass
	
func Process( _delta: float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		return walk
	return null
	
func Physics( _delta: float ) -> State:
	return null

func EndAttack( _newAniName: String ) -> void:
	attacking = false
	pass
