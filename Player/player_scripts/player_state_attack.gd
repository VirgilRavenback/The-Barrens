class_name PlayerStateAttack

extends PlayerState

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range(1, 20, 0.5) var decelerate_speed : float = 5.0

@onready var idle: PlayerState = $"../Idle"
@onready var walk: PlayerState = $"../Walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var hurt_box: HurtBox = $"../../PlayerInteractions/HurtBox"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"


func enter() -> void:
	player.update_animation( "attack" )
	animation_player.animation_finished.connect( end_attack )
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	attacking = true
	
	#await get_tree().create_timer( 0.075 ).timeout
	#if attacking:
	hurt_box.monitoring = true
	pass

func exit() -> void:
	animation_player.animation_finished.disconnect( end_attack )
	attacking = false
	
	hurt_box.monitoring = false
	
	pass

func process( _delta : float ) -> PlayerState:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
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
