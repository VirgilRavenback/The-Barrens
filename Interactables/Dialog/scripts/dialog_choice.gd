@tool

@icon( "res://GUI/Dialog System/Icons/question_bubble.svg" )


class_name DialogChoice extends DialogItem

var dialog_branches : Array[ DialogBranch ]



func _ready() -> void:
	super()
	for c in get_children():
		if c is DialogBranch:
			dialog_branches.append( c )
	

func _set_editor_display() -> void:
	#set the text based on related DialogText node
	if dialog_branches.size() < 2:
		return
	example_dialog.set_dialog_choice( self )
	_set_related_text()
	pass


#find sibling above self in the scene tree and set text accordingly
func _set_related_text() -> void:
	var _p = get_parent()
	var _text = _p.get_child( self.get_index() -1 )
	
	if _text is DialogText:
		example_dialog.set_dialog_text( _text )
		example_dialog.content.visible_characters = -1
	pass


func _get_configuration_warnings() -> PackedStringArray:
	# check for dialog items
	if _check_for_dialog_branches() == false:
		return [ "Requires at least two dialog branch nodes" ]
	else:
		return []


func _check_for_dialog_branches() -> bool:
	var _count : int = 0
	for c in get_children():
		if c is DialogBranch:
			_count += 1
			if _count > 1:
				return true
	return false
