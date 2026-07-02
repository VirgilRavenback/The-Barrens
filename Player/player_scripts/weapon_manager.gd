class_name WeaponManager extends Node

var weapons : Array = []
var available_weapons : Array = []
var current_weapon : String = ""

signal weapon_changed( w : Weapon,  )

func _ready() -> void:
	#reset the weapon arrays first
	weapons = []
	available_weapons = []
	
	#grab the weapon save data from the Save Manager and add those to a dictionary
	#available_weapons = SaveManager.available_weapons
	
	#grab the weapons/children and add them to a dictionary
	for c in get_children():
		weapons.append( c )
		
	#compare the dictionaries and set all weapons in both as "available"
	for i in weapons:
		if i in available_weapons:
			i.available = true
	
	#grab the saved current weapon from save data and assign it to the current weapon
	current_weapon = to_string(  )
	
	pass 



func _process( _delta: float ) -> void:
	pass

func change_weapon() -> Weapon:
	var next_weapon : Weapon
	
	return next_weapon
