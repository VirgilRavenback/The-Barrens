class_name Chest extends Node2D



@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite_2d_chest: Sprite2D = $Sprite2D_Chest
@onready var sprite_2d_interaction: Sprite2D = $Sprite2D_Interaction
@onready var sprite_2d_item: Sprite2D = $Sprite2D_Item
@onready var sprite_2d_shadow: Sprite2D = $Sprite2D_Shadow

@export var item_data : ItemData : set = _set_item_data

var chest_open : bool = false
var can_interact : bool = false
var has_key : bool = false

signal chest_opened

func _ready() -> void:
	#set item_data = 
	area_2d.body_entered.connect( _on_body_entered )
	area_2d.body_entered.connect(_on_body_exited )
	sprite_2d_item.visible = false
	sprite_2d_interaction.visible = false
	
	pass

func chest_interact() -> void:
	if can_interact == false:
		return
	if has_key == false:
		return
	_chest_opened()

func _chest_opened() -> void:
	chest_open = true
	area_2d.body_entered.disconnect( _on_body_entered )
	animation_player.play("open_chest")
	audio_stream_player_2d.play()
	PlayerManager.INVENTORY_DATA.add_item( item_data )
	sprite_2d_item.visible = true
	
	await get_tree().create_timer( 0.75 ).timeout
	
	sprite_2d_item.visible = false
	chest_opened.emit()
	pass	

func _set_item_data( value : ItemData ) -> void:
	item_data = value
	_update_texture()
	pass

func _update_texture()-> void:
	if item_data and sprite_2d_item:
		sprite_2d_item.texture = item_data.texture
	pass

func _on_body_entered( _body ) -> void:
	if _body is Player:
		print("You can interact with the chest")
		can_interact = true
		sprite_2d_interaction.visible = true
	pass

func _on_body_exited( _body ) -> void:
	if _body is Player:
		can_interact = false
		sprite_2d_interaction.visible = false
	pass
