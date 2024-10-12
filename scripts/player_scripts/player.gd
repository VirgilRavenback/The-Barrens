extends CharacterBody2D

@export var speed: float = 150
## @export var accel: float = 10
	## not currently using acceleration for player movement
@onready var hurt_box: HurtBox = $Interactions/HurtBox

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D

var max_health: float = 5
var current_health: float = 5
var heal_amount: float = 1
var damage_amount: float = 1
var face_direction: String = "Down"
var animation_to_play: String = "Idle_Down"
var player_alive: bool = true


signal player_hit
signal player_death
signal direction_changed ( new_direction : Vector2 )


func _ready():
	hide()
	$CollisionShape2D_Enemy.disabled = true
	$CollisionShape2D_Level.disabled = true
	#$CollisionShape2D_Attack.disabled = true
	print("You have 5 health")

func spawn(pos):
	player_alive = true
	position = pos
	$CollisionShape2D_Enemy.disabled = false
	$CollisionShape2D_Level.disabled = false
	#$CollisionShape2D_Attack.disabled = true
	current_health = max_health
	animated_sprite.stop()
	animated_sprite.play("Idle_Down")
	show()
	print("You have 5 health")

func _process(_delta):
	
	# Take Damage
	if Input.is_action_just_pressed("take_damage"):
		take_damage()
	
	# Heal
	if Input.is_action_just_pressed("heal"):
		heal()
	
	# Player death
	if current_health == 0:
		die()


# Handle getting hit
func on_hit():
	player_hit.emit()
	$CollisionShape2D_Enemy.set_deferred("disabled", true)
	
	
	
# Handle taking damage
func take_damage():
	print("You took damage")
	current_health -= damage_amount
	if current_health < 0: 
		current_health = 0
	print("your health is", current_health)


# Handle healing
func heal():
	print("You healed!")
	current_health += heal_amount
	if current_health > 5:
		current_health = 5
	print("your health is", current_health)
	
# Handle Player death
func die():
	player_alive = false
	hide()
	$CollisionShape2D_Enemy.set_deferred("disabled", true)
	$CollisionShape2D_Level.set_deferred("disabled", true)
	#$CollisionShape2D_Attack.set_deferred("disabled", true)
	player_death.emit()
	#print("you died")


func _physics_process(_delta: float):
	# Reset velocity
	velocity = Vector2.ZERO
	
	
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	direction = direction.normalized()
	velocity = direction * speed
	
	# Play run and idle, run, and attack animations
	# Normalize velocity to 1 to avoid faster diagonal movement

	if Input.is_action_pressed("down"):
		velocity.y += 1 * speed
		if velocity.x == 0:
			face_direction = "Down"
	elif Input.is_action_pressed("up"):
		velocity.y -= 1 * speed
		if velocity.x == 0:
			face_direction = "Up"
	elif Input.is_action_pressed("left"):
		velocity.x -= 1 * speed
		if velocity.y == 0:
			face_direction = "Left"
	elif Input.is_action_pressed("right"):
		velocity.x += 1 * speed
		if velocity.y == 0:
			face_direction = "Right"

	animation_to_play = ("Run" if velocity.length() > 0.0 else "Idle") + "_" + face_direction 
	if animated_sprite.animation == "Attack1_Right" and animated_sprite.frame != 5:
		pass
	else:
		animated_sprite.flip_h = false
		animated_sprite.play(animation_to_play)

	if Input.is_action_just_pressed("attack"):
		#pause before activating hurtbox
		await  get_tree().create_timer ( 0.15 ).timeout
		hurt_box.monitoring = true
		if face_direction == "Right":
			animated_sprite.flip_h = false
			animated_sprite.play("Attack1_Right")
		elif face_direction == "Left":
			animated_sprite.flip_h = true
			animated_sprite.play("Attack1_Right")
		if animated_sprite.animation == "Attack1_Right" and animated_sprite.frame != 5:
			pass
		else:  
			animated_sprite.flip_h = false
			#$CollisionShape2D_Attack.set_deferred("disabled", true)
			animated_sprite.play(animation_to_play)
		
	move_and_slide()
	
