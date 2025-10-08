extends Node
## 输入全局监听


signal event_attack ## 触发攻击的信号
signal event_pause ## 触发暂停的信号
signal event_interact ## 触发交互的信号


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(event: InputEvent) -> void:
	#print("按下按键了--->")
	if event.is_action_pressed("attack"): 
		event_attack.emit()
	
	if event.is_action_pressed("pause"):
		#print("发送信号： event_pause")
		event_pause.emit()
	
	if event.is_action_pressed("interact"):
		event_interact.emit()
	
	# 问题所在：这里无条件地处理了任何到达 _unhandled_input 的事件
	#get_viewport().set_input_as_handled() 
	pass
