extends Node

signal event_attack
signal event_pause
signal event_interact


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(event: InputEvent) -> void:
	#print("按下按键了--->")
	if event.is_action_pressed("attack"): # 假设这里仍然是旧的判断方式
		event_attack.emit()
	
	if event.is_action_pressed("pause"):
		#print("发送信号： event_pause")
		event_pause.emit()
	
	if event.is_action_pressed("interact"):
		event_interact.emit()
	
	# 问题所在：这里无条件地处理了任何到达 _unhandled_input 的事件
	#get_viewport().set_input_as_handled() 
	pass


func get_normalized_dir() -> Vector2:
	return Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down")
	).normalized()
