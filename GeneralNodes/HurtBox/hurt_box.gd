class_name HurtBox extends Area2D

@export var damage: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect( AreaEnterd )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func AreaEnterd( target: Area2D ) -> void:
	if target is HitBox:
		target.TakeDamage( damage )
	pass
