class_name PushableStatue
extends RigidBody2D

@export var push_speed : float = 30.0
@export var persistent : bool = false
@export var persistent_location : Vector2 = Vector2.ZERO
#@export var target : Node2D
#var target_location : Vector2 = Vector2.ZERO
var target_reached : bool = false
var target_size : Vector2 = Vector2( 4,4 )

var push_direction : Vector2 = Vector2.ZERO : set = _set_push
#var current_position : Vector2 = global_position

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var target_reached_data: PersistentDataHandler = $TargetReached



#signal position_locked( global_position )

func _ready() -> void:
	if target_reached_data.value == true:
		position = persistent_location
	pass

func _physics_process( _delta: float ) -> void:
	linear_velocity = push_direction * push_speed
	if persistent:
		var x_is_on : bool = abs( position.x - persistent_location.x ) < 15 + target_size.x
		var y_is_on : bool = abs( position.y - persistent_location.y ) < 6 + target_size.y
		if x_is_on and y_is_on and target_reached == false:
			target_reached = true
			print( "arrived on target" )
			#save the persistent data
			target_reached_data.set_value()
			print( SaveManager.current_save.persistence )
		elif ( x_is_on == false or y_is_on == false ) and target_reached == true:
			target_reached = false
			print( "off the button" )
			target_reached_data.remove_value()
			#unsave or remove persistent data
	pass

#func _process( _delta : float ) -> void:
	#if target_reached:
		#lock_position()
	#pass

func _set_push( value : Vector2 ) -> void:
	push_direction = value
	if push_direction == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()
	pass

func lock_position() -> void:
	
	pass
	
