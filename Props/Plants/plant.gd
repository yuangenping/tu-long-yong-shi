class_name Plant extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitBox.connect("Damaged", TakeDamage)
	pass # Replace with function body.


func TakeDamage( _damage: int ) -> void:
	queue_free()
