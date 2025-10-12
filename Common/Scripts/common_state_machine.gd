@abstract
class_name CommonStateMachine extends Node

var states: Array[CommonState]
var prev_state: CommonState
var current_state: CommonState

## 初始化
func initalize(_character: CommonCharacter) -> void:
	states = []
	for c in get_children():
		if c is CommonState:
			states.append(c)
	
	if states.is_empty():
		return
	
	#states[0].character = _character
	#states[0].state_machine = self

	_init_call_back()

	for c in states:
		c.character = _character
		c.state_machine = self
		c.init()
	
	# 初始化state状态机
	change_state(states[0])
	print("states size->" + str(states.size()))
	process_mode = Node.PROCESS_MODE_INHERIT
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	InputManager.event_attack.connect(_event_attacked_)
	InputManager.event_interact.connect(_event_interacted_)
	pass

## 初始化state后回调函数
func _init_call_back() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_state(current_state._process_(delta))
	pass


func _physics_process(delta: float) -> void:
	change_state(current_state._physics_process_(delta))

## 变更state
func change_state(new_state: CommonState) -> void:
	if new_state == null || new_state == current_state:
		return
	if current_state:
		current_state.exit()
	prev_state = current_state
	current_state = new_state
	current_state.enter()

## 响应发起攻击的信号
func _event_attacked_() -> void:
	if current_state != null:
		change_state(current_state._event_attacked_())
	pass

## 响应互动的信号
func _event_interacted_() -> void:
	if current_state != null:
		change_state(current_state._event_interacted_())
	pass
