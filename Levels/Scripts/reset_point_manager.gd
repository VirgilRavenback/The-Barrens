class_name ResetPointManager extends Node2D

var reset_points : Array = []
var fall_hazards : Array = []

var current_reset_point : ResetPoint = null
var current_reset_position : Vector2 = Vector2.ZERO

@export var fall_damage : int = 1


func _ready() -> void:
	
	
	for c in get_children():
		if c is ResetPoint:
			reset_points.append( c )
			c.reset_point_activated.connect( _on_activation )
		elif c is FallHazard:
			fall_hazards.append( c )
	#print( reset_points )
	#print( fall_hazards )
	
	current_reset_point = reset_points[0]
	current_reset_position = reset_points[0].global_position
	
	pass 

func _process(delta: float) -> void:
	
	if PlayerManager.player_falling == true:
		
		PlayerManager.set_player_position( current_reset_position )
		
	pass
	
func _on_activation( reset_point : ResetPoint , reset_point_position: Vector2 ) -> void:
	current_reset_point = reset_point
	current_reset_position = reset_point_position
	
	print( str(current_reset_point) + " activated" )
	print( current_reset_position )
	
	pass
