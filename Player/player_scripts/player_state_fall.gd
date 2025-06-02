class_name PlayerStateFall

extends PlayerState



@export var fall_damage : int = 1
@export var fall_audio : AudioStream
@export var gravity_speed : float  = 300.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

@onready var player_state_machine: PlayerStateMachine = $".."
@onready var stun: PlayerStateStun = $"../Stun"
@onready var dash: PlayerStateDash = $"../Dash"
@onready var idle: PlayerStateIdle = $"../Idle"
@onready var death: PlayerStateDeath = $"../Death"
@onready var walk: PlayerStateWalk = $"../Walk"

@onready var ground_detect_area: GroundDetection = $"../../GroundDetectArea"

var direction : Vector2 = Vector2.DOWN

var next_state : PlayerState = idle


func _ready() -> void:
	pass 

func initialize() -> void:
	ground_detect_area.falling.connect( _on_fall )
	pass

func enter() -> void:
	player.animation_player.animation_finished.connect( _on_animation_finished )

	player.direction = Vector2.ZERO
	
	direction = Vector2.DOWN
	
	player.velocity = direction * gravity_speed
	
	player.update_animation( "fall" )
	
	audio.play()
	
	await animation_player.animation_finished
	
	
	print( "you fell" )
	
	PlayerManager.player_falling = true
	
	pass

func exit() -> void:
	player.sprite_2d.visible = false
	player.velocity = Vector2.ZERO
	PlayerManager.player_falling = false
	player.update_health( -fall_damage )
	player.sprite_2d.visible = true
	player.animation_player.play( "stun_down" )
	player.make_invulnerable( stun.invulnerable_duration )
	player.effect_animation_player.play( "damaged" )
	next_state = null
	player.animation_player.animation_finished.disconnect( _on_animation_finished )
	pass

func process( _delta : float ) -> PlayerState:
	return next_state

func physics_process( _delta: float ) -> PlayerState:
	return null

func handle_input( _event : InputEvent ) -> PlayerState:
	
	return null

func _on_fall() -> void:
	
	if absf( player.velocity.x ) > absf( walk.movement_speed + 200.0 ) or absf( player.velocity.y ) > absf( walk.movement_speed + 200.0 ):
		return
	
	state_machine.change_state( self )
	pass

func _on_animation_finished( _newAnimName : String ) -> void:
	await get_tree().create_timer( 0.01 ).timeout
	
	next_state = idle
	if player.current_health <= 0:
		next_state = death
	pass
