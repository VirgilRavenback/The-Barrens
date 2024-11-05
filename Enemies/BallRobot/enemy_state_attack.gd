class_name EnemyStateAttack

extends EnemyState


@onready var sprite_2d: Sprite2D = $"../../Sprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var hurt_box: HurtBox = $"../../Sprite2D/HurtBox"


@export var anim_name : String = "attack"
@export var attack_speed : int = 200
@export var decelerate_speed: int = 50
@export var next_state : EnemyState

var player : Player
var _direction : Vector2
var _animation_finished : bool = false

func initialize() -> void:
	#enemy.ready_to_attack.connect( _on_ready_to_attack )
	pass

func _on_process( _delta: float ) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity = Vector2.ZERO
	return null
	

func _on_physics_process( _delta: float ):
	enemy.velocity -= _direction * decelerate_speed
	pass

	
func enter():
	enemy.velocity = Vector2.ZERO
	_animation_finished = false
	_direction = enemy.global_position.direction_to( enemy.player.global_position )
	enemy.set_direction( _direction )
	enemy.velocity = _direction * attack_speed
	
	enemy.update_animation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )

func exit():
	enemy.animation_player.animation_finished.disconnect( _on_animation_finished )
	pass

#func _on_ready_to_attack() -> void:
	#state_machine.change_state( self )
	#pass

func _on_animation_finished() -> void:
	_animation_finished = true
	pass
