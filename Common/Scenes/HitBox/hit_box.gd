class_name HitBox extends Area2D

@export var value: float = 1.0
@export var hit_desc: String = "伤害说明"


func _ready() -> void:
	area_entered.connect( _area_entered_ )
	pass

## 攻击有效
func _area_entered_( _hurt_box: HurtBox ) -> void:
	print(hit_desc + ":" + str(value))
	_hurt_box.hit_valid(self)
