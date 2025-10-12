extends CanvasLayer


var hearts : Array[ HeartGUI ] = []

@export var heart_gui_tscn : PackedScene 

@onready var heart_container: HFlowContainer = $Control/HeartContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var heart_count = int( PlayerManager.max_hp / PlayerManager.hp_length ) + int ( PlayerManager.max_hp % PlayerManager.hp_length )
	for i in range(heart_count):
		var _heart_gui = heart_gui_tscn.instantiate() as HeartGUI
		heart_container.add_child(_heart_gui)
		hearts.append(_heart_gui)
		_heart_gui.index = i
		#_heart_gui.visible = false
	update_hp()
	pass


func update_hp() -> void:
	var light_heart_end_index = int( PlayerManager.hp / PlayerManager.hp_length ) if PlayerManager.hp > 0 else 0
	var half_heart_end_index = light_heart_end_index + int ( PlayerManager.hp % PlayerManager.hp_length ) if PlayerManager.hp > 0 else 0
	print("light_heart_end_index: ",light_heart_end_index,"half_heart_end_index: ",half_heart_end_index)
	for hgd in hearts:
		if hgd.index < light_heart_end_index : 
			hgd.value = 2
		elif hgd.index < half_heart_end_index : 
			hgd.value = 1
		else :
			hgd.value = 0
			pass
		pass
	pass
