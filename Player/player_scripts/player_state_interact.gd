class_name PlayerStateInteract extends PlayerState


@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
#add onready var for audiostreamplayer2D
@onready var idle: PlayerStateIdle = $"../Idle"
@onready var walk: PlayerStateWalk = $"../Walk"


var interacting : bool = false

func _ready() -> void:
	pass 

func initialize() -> void:
	pass

func enter() -> void:
	player.update_animation( "interact" )
	#audio_stream_player_2d.play()
	animation_player.animation_finished.connect( end_interaction )

	interacting = true
	player.interacting.emit()
	print("Player is interacting")
	pass

func exit() -> void:
	animation_player.animation_finished.disconnect( end_interaction )
	interacting = false
	pass

func process( _delta : float ) -> PlayerState:
	if interacting == true:
		return self 
	if interacting == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null

func physics_process( _delta: float ) -> PlayerState:
	return null

func handle_input( _event : InputEvent ) -> PlayerState:
	return null

func end_interaction( _newAnimName : String )-> void:
	interacting = false
