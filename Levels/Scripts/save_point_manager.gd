class_name SavePointManager extends Node2D

var save_points : Array = []
var current_save_point : SavePoint = null
var current_save_position : Vector2 = Vector2.ZERO

@export var fall_damage : int = 1


func _ready() -> void:
	
	
	for c in get_children():
		if c is SavePoint or WaterSource:
			save_points.append( c )
			c.save_activated.connect( _on_save_activated )
	print( save_points )
	
	current_save_point = save_points[0]
	current_save_position = save_points[0].global_position
	
	if PlayerManager.player_spawned == false:
		PlayerManager.set_player_position( current_save_position )
		PlayerManager.player_spawned = true
	
	pass 

func _process(delta: float) -> void:
	
	if PlayerManager.player_falling == true:
		PlayerManager.set_player_position( current_save_position )
		
	pass
	
func _on_save_activated( save_point : SavePoint , save_point_position: Vector2 ) -> void:
	current_save_point = save_point
	current_save_position = save_point_position
	
	print( str(current_save_point) + " activated" )
	print( current_save_position )
	
	update_saved_data()
	
	pass

func update_saved_data() -> void:
	SaveManager.current_save.player.save_pos_x = current_save_position.x
	SaveManager.current_save.player.save_pos_y = current_save_position.y
	
	SaveManager.save_game()
	
	pass

func _reset_player() -> void:
	if PlayerManager.player_spawned == false:
		PlayerManager.set_player_position( current_save_position )
		PlayerManager.player_spawned = true
