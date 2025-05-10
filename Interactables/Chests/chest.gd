@tool

class_name Chest extends Node2D



@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var item_label: Label = $Sprite2D_Item/ItemLabel
@onready var interaction_label: Label = $CanvasLayer/Control/InteractionLabel
@onready var sprite_2d_chest: Sprite2D = $Sprite2D_Chest
@onready var sprite_2d_item: Sprite2D = $Sprite2D_Item
@onready var sprite_2d_shadow: Sprite2D = $Sprite2D_Shadow
@onready var persistent_data_is_open: PersistentDataHandler = $PersistentData_IsOpen


@export var item_data : ItemData : set = _set_item_data
@export var quantity : int = 1 : set = _set_quantity

var is_open : bool = false
#var _has_key : bool = false

signal chest_opened

func _ready() -> void:
	_update_label()
	_update_texture()
	if Engine.is_editor_hint():
		return
	
	area_2d.area_entered.connect( _on_area_entered )
	area_2d.area_exited.connect( _on_area_exited )
	persistent_data_is_open.data_loaded.connect( set_chest_state )
	set_chest_state()
	pass

func set_chest_state() -> void:
	is_open = persistent_data_is_open.value
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")

func _on_area_entered( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	#print("Player Interaction Connected")
	interaction_label.visible = true
	pass

func _on_area_exited( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	#print("Player Interaction Disconnected")
	interaction_label.visible = false
	pass


func player_interact() -> void:
	#print("Player is interacting")
	if is_open == true:
		return
	is_open = true
	persistent_data_is_open.set_value()
	animation_player.play("open_chest")
	if item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item( item_data, quantity )
	else:
		printerr("No items in chest")
		push_error("No items in chest. Chest Name ", name)
	chest_opened.emit()
	pass


func _set_item_data( value : ItemData ) -> void:
	item_data = value
	_update_texture()
	pass

func _set_quantity( value : int ) -> void:
	quantity = value
	_update_label()
	pass

func _update_texture() -> void:
	if item_data and sprite_2d_item:
		sprite_2d_item.texture = item_data.texture

func _update_label() -> void: 
	if item_data:
		if quantity <= 1:
			item_label.text = ""
		else:
			#item_label.text = "x" + str( quantity )
			#this is throwing an error - base object is type Nil
			return
