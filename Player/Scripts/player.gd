class_name Player extends CommonCharacter


@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var attack_effect_animation_player: AnimationPlayer = $Sprite2D/AttackEffectSprite/AnimationPlayer
@onready var hurt_effect_animation_player: AnimationPlayer = $EffectAnimationPlayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $Sprite2D/HitBox
@onready var hurt_box: HurtBox = $HurtBox
@onready var audio_stream_player: AudioStreamPlayer = $Audio/AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_is_player_control_ = true
	PlayerManager.player = self
	update_hp(PlayerManager.max_hp)
	pass # Replace with function body.

func get_animation_player() -> AnimationPlayer:
	return animation_player

func get_sprite() -> Sprite2D:
	return sprite

## 获取特效动画播放器
func get_attack_effect_anim_player() -> AnimationPlayer:
	return attack_effect_animation_player

## 受击特效动画播放器
func get_hurt_effect_anim_player() -> AnimationPlayer:
	return hurt_effect_animation_player

## 获取音频播放器
func get_audio() -> AudioStreamPlayer:
	return audio_stream_player

## 获得受击框
func get_hurt_box() -> HurtBox:
	return hurt_box

## 获得打击框
func get_hit_box() -> HitBox:
	return hit_box

func get_state_machine() -> CommonStateMachine:
	return state_machine

func update_hp(value: float) -> void:
	super.update_hp(value)
	PlayerHud.update_hp()
	pass
