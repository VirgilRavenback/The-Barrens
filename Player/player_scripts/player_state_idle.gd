class_name PlayerStateIdle

extends PlayerState

@onready var walk: PlayerState = $"../Walk"
@onready var attack: PlayerState = $"../Attack"
@onready var dash: PlayerStateDash = $"../Dash"


func enter() -> void:
	player.update_animation("idle")
	pass

func exit() -> void:
	
	pass

func process( _delta : float ) -> PlayerState:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null

func physics_process( _delta: float ) -> PlayerState:
	return null

func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
		print("player is trying to interact")
	if _event.is_action_pressed("dash"):
		return dash
	return null
