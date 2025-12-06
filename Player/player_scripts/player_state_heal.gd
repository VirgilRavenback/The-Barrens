class_name PlayerStateHeal

extends PlayerState

@export var idle : PlayerStateIdle
@export var walk : PlayerStateWalk
@export var death : PlayerStateDeath


var next_state : PlayerState = null
@export var heal_amount : int = 3


func _ready() -> void:

	pass 

func _initialize() -> void:
	
	pass

func enter() -> void:
	player.animation_player.animation_finished.connect( _animation_finished )
	if player.current_health >= player.max_health || player.current_healing_charges <= 0:
		next_state = idle
		if player.current_health <= 0:
			next_state = death
		print("you can't heal right now")
		return
	
	player.current_healing_charges -= 1
	print("you have ", player.current_healing_charges, " healing charges remaining")
	player.velocity = Vector2.ZERO
	player.update_animation( "heal" )
	var new_health_amount : int = player.current_health + heal_amount
	player.update_health(new_health_amount)
	
	pass

func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect( _animation_finished )
	
	pass

func process( _delta : float ) -> PlayerState:
	return next_state

func physics_process( _delta: float ) -> PlayerState:
	return null

func handle_input( _event : InputEvent ) -> PlayerState:
	return null

func _animation_finished( _newAnimName : String ) -> void:
	next_state = idle
	if player.current_health <= 0:
		next_state = death
	
	pass
