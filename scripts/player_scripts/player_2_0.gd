class_name Player

extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player_alive : bool = false
var current_health : int = 5
var max_health : int = 5

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var hit_box: HitBox = $hit_box

signal direction_changed( new_direction : Vector2 )


func _ready() -> void:
	#hide()
	#$CollisionShape2D.disabled = true
	#setting this node equal to the player manager. Only works if the player is above enemies in the scene tree
	PlayerManager.player = self
	player_state_machine.initialize( self )
	pass
	
func spawn(pos):
	player_alive = true
	position = pos
	current_health = max_health
	$CollisionShape2D.disabled = false
	show()
	print("You have 5 health")
	hit_box.damaged.connect(_on_hit_box_damaged)

func _process(_delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = direction.normalized()
	
	if current_health == 0:
		die()
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()


func set_direction() -> bool:
	#This function returns true or false indicating whether the direction changed or not
	var new_direction : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
			return false
			
	if direction.y == 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN
		
	if new_direction == cardinal_direction:
		return false
		
	cardinal_direction = new_direction
	if cardinal_direction == Vector2.LEFT:
		sprite_2d.scale.x = -1
	else:
		sprite_2d.scale.x = 1
	
	direction_changed.emit( new_direction )
		
	return true
	
	
func update_animation( state : String ) -> void:
	animation_player.play( state + "_" + animation_direction() )
	pass
	
	
func animation_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
		
func _on_hit_box_damaged ( damage ) -> void:
	print("You took damage")
	current_health -= damage
	if current_health < 0: 
		current_health = 0
	print("Your health is", current_health)

func die() -> void:
	call_deferred("queue_free")
	print("you died")
