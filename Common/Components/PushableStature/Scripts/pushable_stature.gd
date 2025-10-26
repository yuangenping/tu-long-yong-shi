class_name PushableStature extends RigidBody2D


@export var push_speed : float = 30

var push_direction : Vector2 = Vector2.ZERO : set = _set_push

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	area_2d.body_entered.connect( _on_body_entered )
	area_2d.body_exited.connect( _on_body_exited )
	pass

func _exit_tree() -> void:
	area_2d.body_entered.disconnect( _on_body_entered )
	area_2d.body_exited.disconnect( _on_body_exited )
	pass

func _physics_process(delta: float) -> void:
	linear_velocity = push_direction * push_speed
	pass


func _set_push( value : Vector2 ) -> void:
	push_direction = value
	pass


func _on_body_entered( b: Node2D ) -> void:
	print('接触到了角色11')
	if b is CommonCharacter:
		push_direction = b.direction
		audio.play()
		print('接触到了角色')
		
	
func _on_body_exited( b: Node2D ) -> void:
	if b is CommonCharacter:
		push_direction = Vector2.ZERO
		audio.stop()
		print('离开了角色')
	pass
