class_name MapProjector extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pause_menu: CanvasLayer = $".."

signal open_map

func _ready() -> void:
	visible = false
	pass 


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if pause_menu.is_paused == false:
			if DialogSystem.is_active:
				return
			
			visible = true
			
			throw_map_animation()
			await animation_player.animation_finished
			
			open_map_animation()
			await animation_player.animation_finished
			
			pause_menu.show_pause_menu()
			#open_map.emit()
			pass
		else:
			pause_menu.hide_pause_menu()

func _process( _delta: float) -> void:
	pass

func throw_map_animation()-> void:
	animation_player.play( "throw_down")
	
	#animation_player.play( "throw_" + PlayerManager.player.animation_direction() )
	pass

func open_map_animation()-> void:
	animation_player.play( "open_down")
	
	#animation_player.play( "open_" + PlayerManager.player.animation_direction() )
	pass
