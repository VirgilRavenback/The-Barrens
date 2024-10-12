extends NodeState

@onready var character_body_2D: CharacterBody2D = $"../.."
@onready var patrol_group_1: Node = $"BallRobot/Patrol Group 1"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"


@export var speed: float 

var random_time = RandomNumberGenerator.new()
var initial_patrol_target: Vector2
var current_patrol_target: Vector2
var new_patrol_target: Vector2


var number_of_points: int
var point_positions: Array[Vector2]
var current_patrol_target_position: int




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float):
	
	#character_body_2D.velocity = character_body_2D.global_position.direction_to(current_patrol_target) * speed * delta
	
	if character_body_2D.velocity.x < 0: 
		animation_player.play("walk_side")
		sprite_2d.scale.x = -1
	elif character_body_2D.velocity.x > 0:
		animation_player.play("walk_side")
	elif character_body_2D.velocity.y > 0:
		animation_player.play("walk_down")
	elif character_body_2D.velocity.y < 0:
		animation_player.play("walk_up")
		
	character_body_2D.move_and_slide()
	
func enter():
	if patrol_group_1 != null:
		number_of_points = patrol_group_1.get_children().size()
		for point in patrol_group_1.get_children():
			point_positions.append(point.global_position)
		current_patrol_target = point_positions[current_patrol_target_position]
	else:
		print("No patrol points")
		
	random_time.randomize()
	print("Robot will walk for ", random_time, " seconds")

func exit():
	pass
