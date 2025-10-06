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
