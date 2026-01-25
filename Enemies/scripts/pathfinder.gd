class_name Pathfinder extends Node2D


var vectors : Array[ Vector2 ] = [
	Vector2( 0, -1 ), #UP
	Vector2( 1, -1 ), #UP/RIGHT
	Vector2( 1, 0 ), #RIGHT
	Vector2( 1,1 ), #DOWN/RIGHT
	Vector2( 0, 1 ), #DOWN
	Vector2( -1, 1 ), #DOWN/LEFT
	Vector2( -1, 0 ), #LEFT
	Vector2( -1, -1 ) #UP/LEFT
]

var interests : Array[ float ]
var obstacles : Array[ float ] = [ 0, 0, 0, 0, 0, 0, 0, 0 ]
var outcomes : Array[ float ] = [ 0, 0, 0, 0, 0, 0, 0, 0 ]
var rays : Array[ RayCast2D ]

var move_dir : Vector2 = Vector2.ZERO
var best_path : Vector2 = Vector2.ZERO

@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Gather all raycast 2D nodes
	for c in get_children():
		if c is RayCast2D:
			rays.append( c )
	
		
	pass
	
	# normalize all vectors

	for i in vectors.size():
		vectors[ i ] = vectors[ i ].normalized()
	
	# Perform initial pathfinder function
	set_path()
	
	# connect timer
	timer.timeout.connect( set_path )
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_dir = lerp( move_dir, best_path, 10 * delta )
	pass


# Set the best_path the entity should follow by checking for desired direction and considering obstacles
func set_path() -> void:
	# get direction to the player
	var player_dir : Vector2 = global_position.direction_to( PlayerManager.player.global_position )
	
	# reset obstacle values to 0
	for i in 8:
		obstacles[ i ] = 0
		outcomes[ i ] = 0
	
	# check each raycast for collision and update obstacle array
	for i in 8:
		
		if rays[ i ].is_colliding():
			var parent = get_parent()
			var raycast_collider = rays[ i ].get_collider()
			if raycast_collider == get_parent():
				continue

			obstacles[ i ] += 4
			obstacles[ get_next_i( i ) ] += 1
			obstacles[ get_prev_i( i ) ] += 1
	
	# If no obstacles, recommend path in direction of player
	if obstacles.max() == 0: 
		best_path = player_dir
		return
	
	# populate interest array with desirability of possible directions
	interests.clear()
	for v in vectors:
		# the dot product takes two vectors and returns a value which indicates how close they align,
		# essentially how close they are to overlapping. Higher value means more similar vectors
		
		interests.append( v.dot( player_dir ) )
	
	# calculate outcomes of the obstacles and interest directions and populate outcomes array
	
	for i in 8:
		outcomes[ i ] = interests[ i ] - obstacles[ i ]
	
	#set best path with the best outcome
	best_path = vectors[ outcomes.find( outcomes.max() ) ]
	
	
	pass

func get_next_i( i : int ) -> int:
	var n_i : int = i + 1
	if n_i >= 8:
		return 0
	else:
		return n_i
		
func get_prev_i( i : int ) -> int:
	var n_i : int = i - 1
	if n_i < 0:
		return 7
	else:
		return n_i
