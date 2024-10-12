class_name EnemyStateMachine
extends Node


var enemy : Enemy
var state_machine : EnemyStateMachine
var states : Array[ EnemyState ]
var previous_state : EnemyState
var current_state : EnemyState


##What happens when we initialize this state?
func initialize( _enemy : Enemy ) -> void:
	#set states array variable equal to an empty array
	states = []
	# for each node in the children of this node, check their type.
	# if the node type is PlayerState, add them into the array
	for c in get_children():
		if c is EnemyState:
			states.append( c )
	
	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.initialize()
		
	if states.size() > 0:
		change_state( states[0])
		#inherit the process mode settings from the parent so if we disable parent 
		#this will also be disabled. This allows us to pause the game and the enemies will pause
		process_mode = Node.PROCESS_MODE_INHERIT
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( delta: float):
	change_state( current_state.process( delta ))
	pass

func _physics_process( delta: float ):
	change_state( current_state.physics_process( delta ))
	pass

func change_state( new_state : EnemyState ) -> void:
	#check if new_state variable is null or if it's the same as the current state.
	#if either is true, end the function and do nothing bc we don't need to change state.
	if new_state == null || new_state == current_state:
		return
	
	
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter()
	print("current_state is ", current_state)
