@abstract
class_name CommonState extends Node

@export var current_state_name: String
@export var next_state: CommonState

var character: CommonCharacter
var state_machine: CommonStateMachine

## State初始化
@abstract func init() -> void

## 切换到当前state
@abstract func enter() -> void

## 退出当前state
@abstract func exit() -> void

@abstract func _process_(delta: float) -> CommonState
	 
@abstract func _physics_process_(delta: float) -> CommonState


func _event_attacked_() -> CommonState:
	return null

func _event_interacted_() -> CommonState:
	return null
