extends Node2D

@export var ball_robot_scene: PackedScene
@onready var hud: CanvasLayer = $HUD
@onready var player: Player = $Player2_0


signal ball_robot_spawn

	
# Called when the node enters the scene tree for the first time.
func _ready():
	#new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#call game over function when player dies
func _on_player_death():
	game_over()


#call game over screen on HUD
func game_over():
	$HUD.show_game_over()
	#print("Debug: game_over called")

#show win screen on HUD when the robot dies
func you_win():
	$HUD.show_win_screen()
	print("Debug: Show Win Screen Called")
	

#call new game, show UI, reset player, clear enemies, and spawn new enemy instance
func new_game():
	print("Debug: new_game called") 
	$HUD.show_message("Fight the Robot!")
	# Clear spawned enemies
	get_tree().call_group("ball_robots", "queue_free")
	# Spawn character at spawn point
	$Player2_0.spawn($PlayerStartPosition.position)
	#Spawn new enemy at spawn point
	spawn_robot() #The robot is spawning an instance, but the instance doesn't seem to be responding correctly to some of the ball_robot code


# spawn an instance of the ball robot
func spawn_robot():
		var ball_robot = ball_robot_scene.instantiate()
		ball_robot.position = $BallRobotStartPosition.position
		get_parent().add_child(ball_robot)
		ball_robot_spawn.emit()


# call win screen when robot dies
func _on_ball_robot_death():
	you_win()
	print("robot death signal working")
