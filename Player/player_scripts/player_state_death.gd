class_name PlayerStateDeath extends PlayerState

@export var exhaust_audio: AudioStream
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"



func initialize() -> void:
	pass

func enter() -> void:
	player.animation_player.play( "death" )
	audio.stream = exhaust_audio
	audio.play()
	#trigger game over UI
	PlayerHud.show_game_over_screen()
	AudioManager.play_music( null ) #replace null with game over audio when ready
	pass

func exit() -> void:
	
	pass

func process( _delta : float ) -> PlayerState:
	player.velocity = Vector2.ZERO
	return null

func physics_process( _delta: float ) -> PlayerState:
	return null

func handle_input( _event : InputEvent ) -> PlayerState:
	return null
