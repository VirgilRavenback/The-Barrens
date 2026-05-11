class_name WeaponManager extends Node

var weapons : Array = []
var available_weapons : Array = []

func _ready() -> void:
	weapons = []
	available_weapons = []
	
	#grab the weapon save data from the Save Manager and add those to a dictionary
	available_weapons = SaveManager.available_weapons
	#grab the weapons/children and add them to a dictionary
	for c in get_children():
		weapons.append( c )
		
	#compare the dictionaries and set all weapons in both as "available"
	for i in weapons:
		if i in available_weapons:
			i.available = true
	
	
	
	#Compare the two dictionaries, then change the "available" variable in the dictionary for any weapons that are in both dictionaries
	pass 



func _process(delta: float) -> void:
	pass
