class_name InventorySlot extends Button

var slot_data : SlotData : set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect( item_focused )
	focus_exited.connect( item_unfocused )
	pass
	
func set_slot_data( value : SlotData ) -> void:
	slot_data = value
	if slot_data == null :
		return
	
	texture_rect.texture = slot_data.item_data.texturt
	label.text = str(slot_data.quantity)
	
func item_focused() -> void:
	if slot_data != null && slot_data.item_data != null && slot_data.item_data.description != null:
		PauseMenu.update_item_description( slot_data.item_data.description )
	pass


func item_unfocused() -> void:
	pass
