@tool
class_name TreasureChest extends Node2D

@export var item_data : ItemData : set = _set_item_data
@export var quantity : int = 1 : set = _set_quantity

var is_open : bool = false

@onready var sprite: Sprite2D = $ItemSprite
@onready var label: Label = $ItemSprite/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $Area2D


func _ready() -> void:
	_update_texture()
	_update_label()
	if Engine.is_editor_hint():
		return
	interact_area.area_entered.connect( _on_area_entered )
	interact_area.area_exited.connect( _on_area_exit )
	pass


func player_interact() -> void:
	print("开始打开宝箱")
	if is_open:
		return
	if item_data and quantity > 0:
		is_open = true
		animation_player.play("open_chest")
		PlayerManager.PLAYER_INVENTORY_DATA.add_item( item_data, quantity )
	else:
		printerr("宝箱是空的")
		push_error("宝箱是空的2222")
	pass
	
	

func _on_area_entered( _a: Area2D ) -> void:
	print("接近宝箱 _on_area_entered")
	InputManager.event_interact.connect( player_interact )
	pass

func _on_area_exit( _a: Area2D ) -> void:
	print("离开宝箱 _on_area_entered")
	InputManager.event_interact.disconnect( player_interact )
	pass

func _set_item_data( value: ItemData ) -> void:
	item_data = value
	_update_texture()
	pass


func _set_quantity( value: int ) -> void:
	quantity = value
	_update_label()
	pass

func _update_texture() -> void:
	if item_data and sprite:
		sprite.texture = item_data.texturt
	pass
	
func _update_label() -> void:
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = "x" + str( quantity )
