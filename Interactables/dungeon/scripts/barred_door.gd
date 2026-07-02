class_name BarredDoor
extends Node2D


var is_open : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var is_open_data: PersistentDataHandler = $PersistentDataHandler

func _ready () -> void:
	#EventManager.switch_flipped.connect( _on_switch_flipped )
	pass


func open_door() -> void:
	animation_player.play( "open_door" )
	pass

func close_door() -> void:
	animation_player.play( "close_door" )
	pass

#func _on_switch_flipped( switch_on : bool ) -> void:
	#print( switch_on )
	#if switch_on == true:
		#return
	#else:
		#open_door()
	#pass


func _on_blue_light_orb_switch_flipped( switch_on : bool ) -> void:
	print( switch_on )
	#call_deferred( "open_door" )
	#
	if switch_on == true:
		close_door()
		var is_open_data = false
	else:
		open_door()
		var is_open_data = true
	pass
