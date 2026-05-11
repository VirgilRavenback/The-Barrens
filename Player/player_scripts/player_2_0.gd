class_name Player

extends CharacterBody2D

enum LIGHT_TYPES { BLUE, YELLOW, RED, BLACK }
var current_light_type : LIGHT_TYPES = LIGHT_TYPES.BLUE : 
	set(set_light_type):
		if current_light_type == LIGHT_TYPES.BLUE:
			hurt_box.current_light_type = "Blue"
		elif current_light_type == LIGHT_TYPES.YELLOW:
			hurt_box.current_light_type = "yellow"
		elif current_light_type == LIGHT_TYPES.RED:
			hurt_box.current_light_type = "red"
		elif current_light_type == LIGHT_TYPES.BLACK:
			hurt_box.current_light_type = "black"

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player_alive : bool = false


@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player : AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box : HitBox = $hit_box
@onready var hurt_box : HurtBox = $PlayerInteractions/HurtBox
@onready var player_state_machine : PlayerStateMachine = $PlayerStateMachine
@onready var sprite_2d: Sprite2D = $Sprite2D


signal direction_changed( new_direction : Vector2 )
signal player_damaged( hurt_box : HurtBox )
signal light_type_changed( current_light_type )

var invlunerable : bool = false

@export_category("Health")
@export var current_health : int = 5
@export var max_health : int = 5

@export_category("Healing")
@export var current_healing_charges : int = 0
@export var max_healing_charges : int = 3

func _ready() -> void:
	#setting this node equal to the player manager. Only works if the player is above enemies in the scene tree
	PlayerManager.player = self
	player_state_machine.initialize( self )
	hit_box.damaged.connect( _take_damage )
	current_health = max_health
	update_health( 0 )
	current_healing_charges = max_healing_charges
	pass
	
func spawn(pos):
	player_alive = true
	position = pos
	current_health = max_health
	$CollisionShape2D.disabled = false
	show()
	hit_box.damaged.connect(_take_damage)

func _process(_delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = direction.normalized()
	
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed( "test" ):
		
		
		#PlayerManager.shake_camera()
		pass
	

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
		
func _take_damage ( hurt_box : HurtBox ) -> void:
	if invlunerable == true and player_state_machine.current_state != PlayerStateFall:
		return
	
	if current_health > 0:
		update_health( -hurt_box.damage )
		player_damaged.emit( hurt_box )
	
	pass

func update_health( delta : int ) -> void:
	current_health = clampi( current_health + delta, 0, max_health )
	PlayerHud.update_health( current_health, max_health )
	pass

func make_invulnerable ( _duration : float = 1.5 ) -> void:
	invlunerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	
	invlunerable = false
	hit_box.monitoring = true
	pass
	
func revive_player() -> void:
	update_health( 5 )
	player_state_machine.change_state( $PlayerStateMachine/Idle )

func _set_current_light_type() -> void:
	#if #current weaopn == blue sword:
		#current_light_type = LIGHT_TYPES.BLUE
	#elif #current weapon == yellow sword:
		#current_light_type = LIGHT_TYPES.YELLOW
	#elif #current weapon == red sword:
		#current_light_type = LIGHT_TYPES.RED
	#elif #current weapon == black sword:
		#current_light_type = LIGHT_TYPES.BLACK
		
	pass
