class_name HeartGUI extends Control
@onready var sprite: Sprite2D = $Sprite2D


var index : int

var value : int = 2 :
	set( _value ):
		value = _value
		update_sprite()


func _init():
	print("HeartGUI.gd script _init() called!")


func _ready():
	print("HeartGUI.gd script _ready() called!")
	update_sprite()

func update_sprite() -> void:
	sprite.frame = value
