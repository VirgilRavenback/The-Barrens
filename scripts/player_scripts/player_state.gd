class_name PlayerState

extends Node

## Stores a reference to the player that this state belongs to
static var player: Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func enter() -> void:
	
	pass

func exit() -> void:
	
	pass

func process( _delta : float ) -> PlayerState:
	return null

func physics_process( _delta: float ) -> PlayerState:
	return null

func handle_input( _event : InputEvent ) -> PlayerState:
	return null
