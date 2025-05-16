class_name PlayerStateFall

extends Node

## Stores a reference to the player that this state belongs to
static var player: Player
static var state_machine : PlayerStateMachine

@export var next_state : PlayerState

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var stun: PlayerStateStun = $"../Stun"

func _ready() -> void:
	pass 

func initialize() -> void:
	pass

func enter() -> void:
	player.direction = Vector2.ZERO
	player.update_animation( "fall" )
	
	await animation_player.animation_finished
	
	
	pass

func exit() -> void:
	
	pass

func process( _delta : float ) -> PlayerState:
	return null

func physics_process( _delta: float ) -> PlayerState:
	return null

func handle_input( _event : InputEvent ) -> PlayerState:
	return null

func _animation_finished( _newAnimName : String ) -> void:
	next_state = stun
	player.global_position = 
