@tool

class_name ResetPoint extends Node2D

@onready var reset_area: Area2D = $Area2D
@onready var label: Label = $Label


var reset_point_active : bool = false

@export var reset_point_name : String = "Reset Point X"

signal reset_point_activated( reset_point , reset_point_position )


func _ready() -> void:
	_update_label()
	
	if Engine.is_editor_hint():
		return

	visible = false
	reset_area.body_entered.connect( _on_body_entered )
	reset_area.body_exited.connect( _on_body_exited )

func _on_body_entered( _b : Player ) -> void:
	if _b is Player:
		reset_point_activated.emit( self, self.global_position )
		reset_point_active = true
		#print( save_name + " activated")
		
		pass
	
func _on_body_exited( _b : Player ) -> void:
	
	pass

func _update_label() -> void:
	if Engine.is_editor_hint():
		label.text = reset_point_name
	pass
