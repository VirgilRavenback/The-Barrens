## QUEST MANAGER _ GLOBAL SCRIPT
extends Node

signal quest_updated( q )

const QUEST_DATA_LOCATION : String = "res://quests/"

var quests : Array[ Quest ] # all quests in the game
var current_quests : Array = []
# { title = "not found", is_complete = false, completed_steps = [ '' ] }


func _ready() -> void:
	#gather all quests
	gather_quest_data()
	pass

func _unhandled_input( event: InputEvent ) -> void:
	if event.is_action_pressed("test"):
		#print( find_quest( load("res://quests/recover_lost_gear.tres") as Quest) )
		#print( find_quest_by_title("Short Quest") )
		#print( "get_quest_index_by_title: ", get_quest_index_by_title( "Recover Lost Gear" ) )
		#print( "get_quest_index_by_title: ", get_quest_index_by_title( "short quest" ) )
		
		#print( "before: ", current_quests )

		update_quest( "short quest", "", true ) # starts the quest
		update_quest( "Recover Lost Gear", "Find the gear") # completes a step
		update_quest( "Recover Lost Gear", "", true ) #completes quest
		update_quest( "Recover Lost Gear", "", true ) # completes the quest and does not update any steps
		print( "current quests: ", current_quests )
		#print( "====================================================================" )
		
		pass

func gather_quest_data() -> void:
	#gather all quest resources and add into the quests array
	var quest_files : PackedStringArray = DirAccess.get_files_at( QUEST_DATA_LOCATION )
	quests.clear()
	for q in quest_files:
		quests.append( load( QUEST_DATA_LOCATION + "/" + q ) as Quest )
	pass
	print( "quest count: ", quests.size() )

	pass

#update status of the quest
func update_quest( _title : String, _completed_step : String = "", _is_complete : bool = false ) -> void:
	var quest_index : int = get_quest_index_by_title( _title )
	print( "quest_index = ", quest_index )
	if quest_index == -1:
		#quest wasn't found, we need to add it
		var new_quest : Dictionary = { 
			title = _title, 
			is_complete = _is_complete,
			completed_steps = [],
		}
		if _completed_step != "":
			new_quest.completed_steps.append( _completed_step.to_lower() )
		
		current_quests.append( new_quest )
		quest_updated.emit( new_quest )
		
		#display notification that quest was added
		pass
	else:
		#quest found, update it
		var q = current_quests[ quest_index ]
		if _completed_step != "" and q.completed_steps.has( _completed_step ) == false:
			q.completed_steps.append( _completed_step.to_lower() )
			pass
			
		q.is_complete = _is_complete
		
		quest_updated.emit( q )
		#display notification if quest was updated
		if q.is_complete == true:
			deliver_quest_rewards( find_quest_by_title( _title ) )
pass


func deliver_quest_rewards( _q : Quest ) -> void:
	#give xp and item rewards to player
	PlayerManager.reward_xp( _q.reward_xp )
	
	for i in _q.reward_items:
		PlayerManager.INVENTORY_DATA.add_item( i.item, i.quantity )
	pass

#provide a quest and return the current quest data associated with it
func find_quest( _quest : Quest ) -> Dictionary:
	for q in current_quests:
		if q.title.to_lower() == _quest.title.to_lower():
			return q
	return { title = "not found", is_complete = false, completed_steps = [ '' ] }

#take title and find associated quest resource
func find_quest_by_title( _title : String ) -> Quest:
	for q in quests:
		if q.title.to_lower() == _title.to_lower():
			return q
	return null

#find quest title by name and return index in quests array
func get_quest_index_by_title( _title : String ) -> int:
	for i in current_quests.size():
		if current_quests[ i ].title.to_lower() == _title.to_lower():
			return i
	#if we didn't find a matching title, return -1
	return -1
	
func sort_quests() -> void:
	# sort quests by completed or not completed and alphabetically
	pass
