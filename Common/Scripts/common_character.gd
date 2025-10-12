@abstract
class_name CommonCharacter extends CharacterBody2D

## 方向发生变化的信号
signal direction_changed(new_direction: Vector2)
## 受到伤害发送的信号
signal character_being_hurted(hit_box: HitBox)
## 角色销毁发送的信号
signal character_destroyed(hit_box: HitBox)

@export var hp: int = 6
@export var max_hp: int = 6

## 玩家最终保持的朝向
var cardinal_direction: Vector2 = Vector2.DOWN

## 玩家按下键盘时,人物的朝向
var direction: Vector2 = Vector2.ZERO

## 无敌状态
var invulnerable: bool = false

## 是否响应方向键控制
var _is_player_control_ = false

## 获取动画播放器
@abstract func get_animation_player() -> AnimationPlayer

## 获取人物精灵
@abstract func get_sprite() -> Sprite2D

## 获取攻击特效动画播放器
func get_attack_effect_anim_player() -> AnimationPlayer:
	print(self.name + "未重写get_effect_anim_player方法")
	return null

## 受击特效动画播放器
func get_hurt_effect_anim_player() -> AnimationPlayer:
	print(self.name + "未重写get_hurt_effect_anim_player方法")
	return null

## 获取音频播放器
func get_audio() -> AudioStreamPlayer:
	print(self.name + "未重写get_audio方法")
	return null

## 获得受击框
func get_hurt_box() -> HurtBox:
	print(self.name + "未重写get_hurt_box方法")
	return null

## 获得打击框
func get_hit_box() -> HitBox:
	print(self.name + "未重写get_hit_box方法")
	return null

func get_state_machine() -> CommonStateMachine:
	print(self.name + "未重写get_state_machine方法")
	return null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_state_machine():
		get_state_machine().initalize(self)
	if get_hurt_box():
		get_hurt_box().being_hurted.connect(being_hurted)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _is_player_control_:
		direction = UtilManager.get_normalized_dir()
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass

## 追击目标character
## [br]
## [param character]: 被追击对象
## [br]
## [param turn_rate]: 转向速率，0.0~1.0之间
## [br]
## [param chase_speed]: 追击速度，接近对接角色的速度，越大越快
func pursuit_other_character(character: CommonCharacter,
		turn_rate: float = 0.0,
		chase_speed: float = 10) -> void:
	var new_dir: Vector2 = global_position.direction_to(character.global_position)
	direction = direction.lerp(new_dir, turn_rate)
	velocity = direction * chase_speed
	if set_direction():
		update_animation("chase")
	pass

## 设置人物方向
func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var new_dir: Vector2 = cardinal_direction
	var direction_id: int = UtilManager.get_dir_index(direction, CommonVar.CHARACTER_DIR.size(), cardinal_direction * 0.1)
	new_dir = CommonVar.CHARACTER_DIR[direction_id]
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	emit_signal("direction_changed", cardinal_direction)
	if get_sprite():
		get_sprite().scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

## 更新动画
## [br]
## [param state]: 动画名称
## [br]
## [param anim_type]: 动画类型
func update_animation(state: String, anim_type: CommonVar.AnimType = CommonVar.AnimType.ACTION) -> void:
	var anim_player: AnimationPlayer = null
	if anim_type == CommonVar.AnimType.ACTION:
		anim_player = get_animation_player()
	
	elif anim_type == CommonVar.AnimType.EFFECT:
		anim_player = get_attack_effect_anim_player()
	
	var anim_name: String = state + "_" + get_anim_direction()
	if anim_player != null:
		if anim_player.has_animation(anim_name):
			anim_player.play(anim_name)
		else:
			print(name + "没有动画：" + anim_name)
	pass


## 获取动画的方向
func get_anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func make_invulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	var _hurt_box: HurtBox = get_hurt_box()
	if _hurt_box:
		_hurt_box.monitoring = false
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	if _hurt_box:
		_hurt_box.monitoring = true
	pass

## 受到伤害
func being_hurted(hit_box: HitBox) -> void:
	print("Player受到伤害-->" + hit_box.hit_desc + ',伤害值：' + str(hit_box.value))
	if invulnerable:
		return
	update_hp(-int(hit_box.value))
	if hp > 0:
		character_being_hurted.emit(hit_box)
	else:
		character_destroyed.emit(hit_box)
	pass

## 更新血量
func update_hp(value: float) -> void:
	if invulnerable :
		return
	hp = clamp(hp + int(value), 0, max_hp)
	pass
