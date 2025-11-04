class_name Plant extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HurtBox.being_hurted.connect( take_damage )
	pass # Replace with function body.

func take_damage( _damage: HitBox ) -> void:
	queue_free()
