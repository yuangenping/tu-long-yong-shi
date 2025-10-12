class_name Enemy extends CommonCharacter

@onready var sprite: Sprite2D = $Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var enemy_state_machine: CommonStateMachine = $EnemyStateMachine

@onready var hit_box: HitBox = $HitBox

@onready var hurt_box: HurtBox = $HurtBox


## 获取人物精灵:
func get_animation_player() -> AnimationPlayer:
	return animation_player

## 获取特效动画播放器:
func get_sprite() -> Sprite2D:
	return sprite

func get_state_machine() -> CommonStateMachine:
	return enemy_state_machine

func get_hit_box() -> HitBox:
	return hit_box

func get_hurt_box() -> HurtBox:
	return hurt_box

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.
