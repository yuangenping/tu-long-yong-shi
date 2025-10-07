extends CanvasLayer

signal shown
signal hidden

@onready var button_save: Button = $Control/VBoxContainer/Button_Save
@onready var button_load: Button = $Control/VBoxContainer/Button_Load
@onready var description: Label = $Control/Description
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var is_paused : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect( _on_save_pressed )
	button_load.pressed.connect( _on_load_pressed )
	GlobalUtil.event_pause.connect( show_or_hide_menu )
	pass # Replace with function body.




func show_or_hide_menu() -> void:
	if is_paused == false :
		show_pause_menu()
	else :
		hide_pause_menu()
	# 防止事件继续传递，给当前按键事件标记为已处理
	# get_viewport().set_input_as_handled()
	pass
	
func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	shown.emit()
	pass
	
func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()
	pass


func _on_save_pressed() -> void:
	if is_paused == false:
		return
		
	SaveManager.save_game()
	hide_pause_menu()
	pass
	
func _on_load_pressed() -> void:
	if is_paused == false:
		return
	hide_pause_menu()	
	SaveManager.load_game()
	pass

func update_item_description( new_text : String ) -> void:
	description.text = new_text
	pass


func play_audio( audio: AudioStream ) -> void :
	audio_stream_player.stream = audio
	audio_stream_player.play()
