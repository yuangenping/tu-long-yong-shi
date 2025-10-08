
@abstract
class_name State extends Node

static var player: Player
static var state_machine : PlayerStateMachine

func init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

 
func Enter() -> void:
	pass
	
func Exit() -> void:
	pass
	
func Process( _delta: float ) -> State:
	return null
	
func Physics( _delta: float ) -> State:
	return null

func event_attack() -> State:
	return null


func event_interact() -> void:
	pass
