class_name PlayerStateWalk

extends PlayerState

@export var movement_speed : float
@export var time_to_movement_speed : float = 0.2
@export var time_moving : float = 0.4

@onready var idle: PlayerState = $"../Idle"
@onready var attack: PlayerState = $"../Attack"
@onready var dash: PlayerState = $"../Dash"
@onready var heal: PlayerState = $"../Heal"


func enter() -> void:
	player.update_animation( "walk" )
	pass

func exit() -> void:
	
	pass

func process( _delta : float ) -> PlayerState:
	if player.direction == Vector2.ZERO:
		time_moving = 0
		return idle
		
		
	#calculate the acceleration value
	time_moving += 0.3 * _delta
		
	player.velocity = player.direction * lerpf(0, movement_speed, 
	clampf( time_moving / time_to_movement_speed, 0, 1 ) )
	#print(player.velocity)
	
	if player.set_direction():
		player.update_animation("walk")
	
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
	if _event.is_action_pressed("heal"):
		return heal
	
	return null
