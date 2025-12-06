extends Node

const PLAYER = preload("res://Player/player.tscn")
const INVENTORY_DATA : InventoryData = preload("res://GUI/pause_menu/player_inventory/player_inventory.tres")

var player : Player
var interact_handled = true
var player_spawned : bool = false
var player_falling : bool = false

signal camera_shook( trauma : float )
signal interact_pressed


func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true
	player_falling = false


func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child( player )
	pass

func set_player_health( current_health : int, max_health : int ) -> void:
	player.max_health = max_health
	player.current_health = current_health
	player.update_health( 0 )

func set_player_healing_charges( current_heal_charges : int, max_healing_charges : int ) -> void:
	player.max_healing_charges = max_healing_charges
	player.current_healing_charges = current_heal_charges

func set_player_position( _new_pos : Vector2 ) -> void:
	player.global_position = _new_pos
	pass


func set_as_parent( _p : Node2D ) -> void:
	if player.get_parent():
		player.get_parent().remove_child( player )
	_p.add_child( player )
	pass

func play_audio( _audio : AudioStream ) -> void:
	player.audio.stream = _audio
	player.audio.play()

func interact() -> void:
	interact_handled = false
	interact_pressed.emit()

func unparent_player( _p : Node2D ) -> void:
	_p.remove_child( player )
	pass

func shake_camera( trauma : float = 1 ) -> void:
	camera_shook.emit( trauma )
