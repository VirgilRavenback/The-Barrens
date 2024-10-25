class_name PlayerStateAttack

extends PlayerState

var attacking : bool = false

@onready var idle: PlayerState = $"../Idle"
@onready var walk: PlayerState = $"../Walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var hurt_box: HurtBox = $"../../PlayerInteractions/HurtBox"


func enter() -> void:
	player.update_animation( "attack" )
	animation_player.animation_finished.connect( end_attack )
	attacking = true
	
	hurt_box.monitoring = true
	pass

func exit() -> void:
	animation_player.animation_finished.disconnect( end_attack )
	attacking = false
	
	hurt_box.monitoring = false
	
	pass

func process( _delta : float ) -> PlayerState:
	player.velocity = Vector2.ZERO
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
		
		
	
	if player.set_direction():
		player.update_animation("attack")
	
	return null

func physics_process( _delta: float ) -> PlayerState:
	return null

func handle_input( _event : InputEvent ) -> PlayerState:
	return null
	

func end_attack( _newAnimName : String ) -> void:
	attacking = false
