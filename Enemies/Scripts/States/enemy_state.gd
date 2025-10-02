class_name EnemyState extends Node

var enemy : Enemy
var state_machine : EnemyStateMachine

func init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

 
func Enter() -> void:
	pass
	
func Exit() -> void:
	pass
	
func Process( _delta: float ) -> EnemyState:
	return null
	
func Physics( _delta: float ) -> EnemyState:
	return null
