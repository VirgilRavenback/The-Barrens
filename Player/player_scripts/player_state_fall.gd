class_name PlayerStateFall

extends PlayerState


@export var next_state : PlayerState
@export var fall_damage : int = 1
@export var fall_audio : AudioStream
@export var gravity_speed : float  = 200.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var stun: PlayerStateStun = $"../Stun"
@onready var death: PlayerStateDeath = $"../Death"
@onready var ground_detect_area: GroundDetection = $"../../GroundDetectArea"
@onready var player_state_machine: PlayerStateMachine = $".."

var direction : Vector2 = Vector2.DOWN

signal player_falling

func _ready() -> void:
	pass 

func initialize() -> void:
	ground_detect_area.falling.connect( _on_fall )
	pass

func enter() -> void:
	if player_state_machine.current_state == PlayerStateDash:
		return
	
	player.direction = Vector2.ZERO
	
	direction = Vector2.DOWN
	player.velocity = direction * gravity_speed
	
	player.update_animation( "fall" )
	
	audio.play()
	
	await animation_player.animation_finished
	
	print( "you fell" )
	
	player.queue_free()
	PlayerManager.player_spawned = false
	player_falling.emit()
	
	pass

func exit() -> void:
	next_state = null
	pass

func process( _delta : float ) -> PlayerState:
	return null

func physics_process( _delta: float ) -> PlayerState:
	return null

func handle_input( _event : InputEvent ) -> PlayerState:
	
	return null

func _on_fall() -> void:
	state_machine.change_state( self )
	pass

#func reset_player() -> void:
	#next_state = stun
	#if player.current_health <= 0:
		#next_state = death
	#pass
