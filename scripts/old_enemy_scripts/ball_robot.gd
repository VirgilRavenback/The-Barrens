class_name BallRobot

extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $hit_box
#a@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

signal ball_robot_damaged()
signal ball_robot_death

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

#Enemy Stats
@export var max_health: float = 3
var current_health: float = 3
var damage_amount: float = 1
var spawned: bool = false

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable: bool = false

func _ready() -> void:
	hit_box.damaged.connect(_on_hit_box_damaged)
	pass

func _on_game_ball_robot_spawn():
	spawned = true
	current_health = max_health


func _process(_delta):
	pass
	
	# Robot death
	if current_health == 0:
		die()

# Handle robot dying
func die():
	queue_free()
	ball_robot_death.emit()
	print("you defeated the robot!")

func _physics_process(_delta: float):
	pass


func _on_hit_box_damaged( damage: int ) -> void:
	print("The robot took damage")
	current_health -= damage
	if current_health < 0: 
		current_health = 0
	print("The robot's health is", current_health)
	ball_robot_damaged.emit()
	pass # Replace with function body.
