class_name InventoryUI extends Control


const INVENTORY_SLOT = preload("uid://cdeknbajewqne")

@export var data : InventoryData


func _ready() -> void:
	PauseMenu.shown.connect( update_inventory )
	PauseMenu.hidden.connect( clear_inventory )
	clear_inventory()
	pass
	
func clear_inventory() -> void:
	for c in get_children() :
		c.queue_free()

func update_inventory() -> void:
	for c in data.slots :
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = c
	get_child( 0 ).grab_focus()
	
	pass
	
