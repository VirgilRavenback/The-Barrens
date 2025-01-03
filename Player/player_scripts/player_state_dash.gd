class_name PlayerStateDash

extends PlayerState


@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var idle: PlayerStateIdle = $"../Idle"
@onready var walk: PlayerStateWalk = $"../Walk"
@onready var hit_box: HitBox = $"../../hit_box"


@export var dash_speed : float = 2000.0
@export var decelerate_speed : float = 15.0
@export var invulnerable_duration : float = 0.6
@export var dash_duration : float = 0.10
@export var dash_sound : AudioStream


var direction : Vector2
var next_state : PlayerState = null
var dashing : bool = false
var timer_timeout : bool = false



func _ready() -> void:
	pass 

func initialize() -> void:
	timer_timeout = false
	dashing = false
	pass

func enter() -> void:
	print("player is dashing")
	dashing = true
	player.update_animation( "dash" )
	#animation_player.animation_finished.connect( end_attack )
	audio.stream = dash_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	player.make_invulnerable( invulnerable_duration )
	player.velocity = player.direction * dash_speed
	player.set_direction()
	
	await get_tree().create_timer( dash_duration ).timeout
	
	timer_timeout = true
	dashing = false
	
	
	pass

func exit() -> void:
	
	dashing = false
	timer_timeout = false
	next_state = null
	print("end dash")
	pass

func process( _delta : float ) -> PlayerState:
	#if dashing == true and timer_timeout == false:
	
	player.velocity -= player.velocity * decelerate_speed * _delta
	if timer_timeout == true and dashing == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
		
	
	#if player.set_direction():
		#player.update_animation("dash")
	
	return null

func physics_process( _delta: float ) -> PlayerState:
	
	return null

func handle_input( _event : InputEvent ) -> PlayerState:
	return null
