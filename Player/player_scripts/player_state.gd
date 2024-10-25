class_name PlayerState

extends Node

## Stores a reference to the player that this state belongs to
static var player: Player
static var state_machine : PlayerStateMachine

func _ready() -> void:
	pass 

func initialize() -> void:
	pass

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
