class_name PlayerStateMachine

extends Node

var states : Array[ PlayerState ]
var previous_state : PlayerState
var current_state : PlayerState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#call the process function from the current state's state script and return
	#either a state or null. If null, state will not change
	change_state( current_state.process( delta ))
	pass


func _physics_process(delta: float) -> void:
	change_state( current_state.physics_process( delta ))
	pass


func _unhandled_input(event: InputEvent) -> void:
	change_state( current_state.handle_input( event))


func initialize( _player : Player ) ->void:
	#set states array variable equal to an empty array
	states = []
	# for each node in the children of this node, check their type.
	# if the node type is PlayerState, add them into the array
	for child in get_children():
		if child is PlayerState:
			states.append(child)
	
	if states.size() > 0:
		states[0].player = _player
		change_state( states[0])
		#inherit the process mode settings from the parent so if we disable parent 
		#this will also be disabled
		process_mode = Node.PROCESS_MODE_INHERIT


func change_state( new_state : PlayerState ) -> void:
	#check if new_state variable is null or if it's the same as the current state.
	#if either is true, end the function and do nothing bc we don't need to change state.
	if new_state == null || new_state == current_state:
		return
	
	
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter()
