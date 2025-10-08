class_name PlayerStateMachine extends Node

var states: Array[ State ]
var prev_state: State
var current_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	InputManager.event_attack.connect( event_attack )
	InputManager.event_interact.connect( event_interact )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ChangeState( current_state.Process(  delta ) )
	
func _physics_process(delta: float) -> void:
	ChangeState( current_state.Physics( delta ))

func event_attack() -> void:
	ChangeState( current_state.event_attack( ) )

func event_interact() -> void:
	current_state.event_interact()

func Initalize( _player: Player ) -> void:
	states = []
	for c in get_children():
		if c is State:
			states.append(c)
	
	if states.is_empty() :
		return
	
	states[0].player = _player
	states[0].state_machine = self
	
	for c in states:
		c.init()
	
	ChangeState( states[0] )
	process_mode = Node.PROCESS_MODE_INHERIT
		

func ChangeState( new_state : State) -> void:
	if new_state == null || new_state == current_state:
		return
	if current_state:
		current_state.Exit()
	
	prev_state = current_state
	current_state = new_state
	current_state.Enter()
