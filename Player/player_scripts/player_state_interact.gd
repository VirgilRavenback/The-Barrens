class_name PlayerStateInteract extends PlayerState


@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var interacting : bool = false

func _ready() -> void:
	pass 

func initialize() -> void:
	pass

func enter() -> void:
	player.update_animation( "interact" )
	animation_player.animation_finished.connect( end_interaction )

	interacting = true
	pass

func exit() -> void:
	
	pass

func process( _delta : float ) -> PlayerState:
	if interacting == true:
		return self 
	return null

func physics_process( _delta: float ) -> PlayerState:
	return null

func handle_input( _event : InputEvent ) -> PlayerState:
	return null

func end_interaction( _newAnimName : String )-> void:
	interacting = false
