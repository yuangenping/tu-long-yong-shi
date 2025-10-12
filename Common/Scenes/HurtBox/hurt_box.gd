class_name HurtBox extends Area2D

signal being_hurted( hit_box: HitBox )

## 攻击有效，受到了伤害
func hit_valid( hit_box: HitBox ) -> void:
	being_hurted.emit( hit_box )
