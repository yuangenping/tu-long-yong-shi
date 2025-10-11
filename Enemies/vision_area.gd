class_name VisionArea extends Area2D

signal player_entered
signal player_exited


func _ready() -> void:
	body_entered.connect( _on_body_entered_ )
	body_exited.connect( _on_body_exited_ )
	
	var _p = get_parent()
	if _p is Enemy:
		_p.direction_changed.connect( _on_direction_change )
		
	
func _on_body_entered_( _b: Node2D ) -> void:
	if _b is Player:
		player_entered.emit()
	pass

func _on_body_exited_( _b: Node2D ) -> void:
	if _b is Player:
		player_exited.emit()
	pass

func _on_direction_change( new_direction : Vector2 ) -> void:
	rotation_degrees = UtilManager.get_new_ratation_deg_by_dir( new_direction )
	pass
