extends Node

const SAVE_PATH = "user://"



signal game_loaded
signal game_saved


var current_save : Dictionary = {
	scene_path = "",
	player = {
		current_health = 1, 
		max_health = 1,
		pos_x = 0,
		pos_y = 0,
		save_pos_x = 0,
		save_pos_y = 0,
		current_healing_charges = 0,
		max_healing_charges = 0
	},
	items = [],
	persistence = [],
	quests = [
		#{ title = "not found", is_complete = false, completed_steps = [ '' ] }
	],
}


func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_inventory_data()
	var file := FileAccess.open( SAVE_PATH + "save.sav", FileAccess.WRITE )
	var save_json = JSON.stringify( current_save )
	file.store_line( save_json )
	game_saved.emit()

	
	pass

func get_save_file() -> FileAccess:
	return FileAccess.open( SAVE_PATH + "save.sav", FileAccess.READ )


func load_game() -> void:
	var file := get_save_file()
	var json:= JSON.new()
	json.parse( file.get_line() )
	var save_dictionary : Dictionary = json.get_data() as Dictionary
	current_save = save_dictionary
	
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO )
	
	await LevelManager.level_load_started
	
	#spawn player at the last save point
	PlayerManager.set_player_position( Vector2( current_save.player.save_pos_x, current_save.player.save_pos_y ) )
	#spawn player at the player's last position
	#PlayerManager.set_player_position( Vector2( current_save.player.pos_x, current_save.player.pos_y ) )
	PlayerManager.set_player_health( current_save.player.current_health, current_save.player.max_health )
	PlayerManager.set_player_healing_charges( current_save.player.current_healing_charges, current_save.player.max_healing_charges )
	PlayerManager.INVENTORY_DATA.parse_save_data( current_save.items )
	
	await LevelManager.level_loaded
	
	game_loaded.emit()
	
	pass


func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.current_health = p.current_health
	current_save.player.max_health = p.max_health
	current_save.player.current_healing_charges = p.current_healing_charges
	current_save.player.max_healing_charges = p.max_healing_charges
	#position of last spawn point is currently being set in the save point manager
	#current_save.player.save_pos_x = p.global_position.x
	#current_save.player.save_pos_y = p.global_position.y
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	
	print( str(SaveManager.current_save.player.save_pos_x) + "," + str(SaveManager.current_save.player.save_pos_y) )

func update_scene_path() -> void:
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p

func update_inventory_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()

func add_persistent_value( value : String ) -> void:
	if check_persistent_value( value ) == false:
		current_save.persistence.append( value )
	pass

func check_persistent_value( value : String ) -> bool:
	var p = current_save.persistence as Array
	return p.has( value )
