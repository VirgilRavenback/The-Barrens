extends CanvasLayer


var hearts : Array[ HeartGUI ] = []


func _ready() -> void:
	for child in $Control/HBoxContainer.get_children():
		if child is HeartGUI:
			hearts.append( child )
			child.visible = true
			

	pass 

func update_health( _current_health: int, _max_health: int ) -> void:
	update_max_health( _max_health )
	for i in _max_health:
		update_heart( i, _current_health )
	pass

func update_heart( _index : int, _health : int ) -> void:
	var _value : int = clampi( _health - _index, 0, 1 )
	hearts[ _index ].value = _value
	pass

func update_max_health( _max_health : int )-> void:
	#var _heart_count : int = roundi( _max_health )
	#for i in hearts.size():
		#if i < _heart_count:
			#hearts[i].visible = true
		#else:
			#hearts[i].visible = false
	pass
