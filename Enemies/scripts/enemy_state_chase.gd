class_name EnemyStateChase

extends EnemyState

@export var anim_name : String = "walk"
@export var chase_speed : int = 100
@export var turn_rate : float = 0.25

@export_category("AI")
@export var next_state : EnemyState
@export var previous_state : EnemyState
@export var vision_area : VisionArea
#@export var attack_area : HurtBox
@export var state_aggro_duration : float = 0.5
@export var attack_distance : float = 100.0

var target: CharacterBody2D
var player: CharacterBody2D
var _can_see_player : bool = false
var _direction : Vector2
var _timer : float = 0.0

@onready var character_body_2D: Enemy = $"../.."
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var navigation_agent_2D: NavigationAgent2D = $"../../NavigationAgent2D"

func initialize() -> void:
	if vision_area:
		vision_area.player_entered.connect( _on_player_entered )
		vision_area.player_exited.connect( _on_player_exited )
		#attack_distance = navigation_agent_2D.target_desired_distance
		player = PlayerManager.player
	pass

func _ready() -> void:
		
	pass

func process( _delta: float ) -> EnemyState:
	if PlayerManager.player_falling == true:
		return next_state
	if PlayerManager.player.current_health <= 0: #exit chase state if player dies
		return next_state
	var _new_direction : Vector2 = enemy.global_position.direction_to( PlayerManager.player.global_position )
	_direction = lerp( _direction, _new_direction, turn_rate )
	enemy.velocity = _direction * chase_speed
	if enemy.set_direction( _direction ):
		enemy.update_animation( anim_name )

	
	if _can_see_player == false:
		_timer -= _delta
		if _timer < 0:
			return next_state
		else:
			_timer = state_aggro_duration
	return null
		

func _on_physics_process( _delta: float ) -> EnemyState:
	#if _can_see_player == true:
		#target = player
	#if  target:
		#navigation_agent_2D.target_position = target.global_position
	#elif !target:
		#navigation_agent_2D.navigation_finished #may have no effect?
	#if navigation_agent_2D.is_navigation_finished():
		#enemy.ready_to_attack.emit()
		#enemy.enemy_state_machine.change_state( next_state )
		#return
	
	#var next_path_position : Vector2 = navigation_agent_2D.get_next_path_position()
	#var new_velocity: Vector2 = enemy.global_position.direction_to( next_path_position ) * chase_speed
	#character_body_2D.velocity = clamp(character_body_2D.velocity, min: (-max_speed, -max_speed), max:(max_speed, max_speed))
	#if navigation_agent_2D.avoidance_enabled:
		#navigation_agent_2D.set_velocity( new_velocity )
	#else:
		#_on_navigation_agent_2d_velocity_computed( new_velocity )
	return null
	
func enter():
	_timer = state_aggro_duration
	#set_movement_target()
	enemy.update_animation( anim_name )
	pass


func set_movement_target():
	target = player
	if target:
		navigation_agent_2D.target_position = target.global_position
		#print("target set")
	

func exit():
	target = null
	_can_see_player = false
	#need to figure out how to end navigation on exiting the state


#func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	#enemy.velocity = safe_velocity 
	#enemy.move_and_slide()

func _on_player_entered( _body : Node2D ) -> void:
	_can_see_player = true
	if state_machine.current_state is EnemyStateStun:
		return
	state_machine.change_state( self )
	#print( "chasing player" )
	pass

func _on_player_exited( _body : Node2D ) -> void:
	_can_see_player = false
	pass
