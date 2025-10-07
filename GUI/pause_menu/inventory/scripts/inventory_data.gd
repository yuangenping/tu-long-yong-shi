class_name InventoryData extends Resource

@export var slots : Array[ SlotData ]

func _init() -> void: 
	connect_slot()
	pass


func add_item( item : ItemData, count : int = 1 ) -> bool:
	var existIndex  := slots.find_custom( func(element):
		return element != null && element.item_data == item
	)
	
	if existIndex != -1:
		slots[existIndex].quantity += count
	else :
		var newData : SlotData = SlotData.new()
		newData.item_data = item
		newData.quantity = count
		newData.changed.connect( slot_changed )
		slots.append(newData)
	
	return true 


func connect_slot() -> void:
	for s in slots:
		if s :
			s.changed.connect( slot_changed )

func slot_changed() -> void:
	var remove_slots: Array[ SlotData ] =  slots.filter( func(ele : SlotData) :
		return ele.quantity < 1
	)
	if remove_slots.is_empty() :
		return
	
	for r: SlotData in remove_slots :
		r.changed.disconnect( slot_changed )
		var remove_index = slots.find(r)
		slots.remove_at( remove_index )
		emit_changed()
	remove_slots.clear()	
	pass


func get_save_data() -> Array :
	var item_save : Array = []
	item_save = slots.map( item_to_save )
	return item_save


func item_to_save( slot : SlotData ) -> Dictionary:
	var result = {
		item = "",
		quanity = 0
	}
	
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	
	return result
	
func parse_save_data( save_data : Array ) -> void:
	var new_data  := save_data.map( item_from_data ).filter( func(ele): return ele != null )
	if new_data.is_empty() :
		return
	slots.clear()
	slots.append_array( new_data )
	pass


func item_from_data( save_object : Dictionary ) -> SlotData:
	if save_object.item == "" :
		return null
	
	var new_slot : SlotData = SlotData.new()
	new_slot.item_data = load( save_object.item )
	new_slot.quantity = int( save_object.quantity )
	return new_slot
