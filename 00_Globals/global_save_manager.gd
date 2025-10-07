extends Node


const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save : Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quests = []
}


func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_item_data()
	var file := FileAccess.open( SAVE_PATH + "save.sav", FileAccess.WRITE )
	var save_json = JSON.stringify( current_save )
	file.store_line( save_json )
	game_saved.emit()
	print("save_game", save_json )
	pass
	
func load_game() -> void:
	var start_time = Time.get_ticks_msec()  # 记录开始时间（毫秒）
	var file := FileAccess.open( SAVE_PATH + "save.sav", FileAccess.READ )
	if file == null :
		return
	current_save = JSON.parse_string( file.get_line() ) as Dictionary
	#print("get_save_data",current_save)
	
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO )
	PlayerManager.PLAYER_INVENTORY_DATA.parse_save_data( current_save.items )
	await LevelManager.level_load_started
	
	PlayerManager.hp = current_save.player.hp
	PlayerManager.max_hp = current_save.player.max_hp
	PlayerManager.set_player_position( Vector2( current_save.player.pos_x, current_save.player.pos_y ) )
	PlayerHud.update_hp()
	
	await  LevelManager.level_loaded
	game_loaded.emit()
	var end_time = Time.get_ticks_msec()   # 记录结束时间
	var duration = end_time - start_time  # 计算耗时
	print("函数执行时间：",  duration, "毫秒")  # 打印结果
	pass


func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.hp = PlayerManager.hp
	current_save.player.max_hp = PlayerManager.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	pass

func update_scene_path() -> void:
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Level :
			p = c.scene_file_path
	
	current_save.scene_path = p
	pass

func update_item_data() -> void:
	current_save.items = PlayerManager.PLAYER_INVENTORY_DATA.get_save_data()
	pass
