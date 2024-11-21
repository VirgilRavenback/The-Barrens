class_name Enemy

extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $hit_box
@onready var enemy_state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var audio: AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D


@export var current_health : int = 3
@export var take_damage_sound : AudioStream

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false

signal direction_changed ( new_direction : Vector2 )
signal enemy_damaged( hurt_box : HurtBox )
signal enemy_destroyed( hurt_box : HurtBox )
#signal ready_to_attack()

func _ready() -> void:
	enemy_state_machine.initialize( self )
	player = PlayerManager.player
	hit_box.damaged.connect( _take_damage )
	#player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D

	pass 


func _process( _delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	move_and_slide()

func set_direction( _new_direction : Vector2 ) -> bool:
	#This function returns true or false indicating whether the direction changed or not
	#direction is being provided from the states instead of player input
	direction = _new_direction
	#if direction is zero, return false
	if direction == Vector2.ZERO:
			return false
			
	var direction_id : int = int ( round(
			(direction + cardinal_direction * 0.1 ).angle()
			/ TAU * DIR_4.size()
	))
	var new_direction = DIR_4[ direction_id ]
	
	#if direction hasn't changed, return false
	if new_direction == cardinal_direction:
		return false
	
	#if direction has changed, set the cardinal direction
	cardinal_direction = new_direction
	
	if cardinal_direction == Vector2.LEFT:
		sprite_2d.scale.x = -1
	else:
		sprite_2d.scale.x = 1
	
	direction_changed.emit( new_direction )
	#print( new_direction )
		
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
		
func _take_damage ( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return
	
	audio.stream = take_damage_sound
	audio.pitch_scale = randf_range(1.1, 1.3)
	audio.play()
	
	current_health -= hurt_box.damage
	print("You dealt ", hurt_box.damage, "damage")
	if current_health > 0:
		enemy_damaged.emit( hurt_box )
		print("Your health is", current_health)
	else:
		enemy_destroyed.emit( hurt_box )
	
