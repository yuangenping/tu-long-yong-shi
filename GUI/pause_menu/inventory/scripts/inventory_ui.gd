class_name InventoryUI extends Control


const INVENTORY_SLOT = preload("uid://cdeknbajewqne")

var focus_index : int = 0

@export var data : InventoryData


func _ready() -> void:
	PauseMenu.shown.connect( update_inventory )
	PauseMenu.hidden.connect( clear_inventory )
	clear_inventory()
	data.changed.connect( on_inventory_changed )
	pass
	
func clear_inventory() -> void:
	for c in get_children() :
		c.queue_free()

func update_inventory() -> void:
	for c in data.slots :
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = c
		new_slot.focus_entered.connect ( set_focus_index )
	var child_count := get_child_count()
	if child_count > 0:
		var new_focus_index : int = focus_index
		if child_count <= focus_index :
			new_focus_index = focus_index - 1
		get_child( new_focus_index ).grab_focus()
	pass

func set_focus_index() -> void:
	for i in get_child_count():
		if get_child( i ).has_focus() :
			focus_index = i
	pass
	
func on_inventory_changed() -> void:
	clear_inventory()
	await get_tree().process_frame
	update_inventory()
	
