@tool

class_name SavePoint extends Node2D


@onready var save_area: Area2D = $Area2D
@onready var label: Label = $Label
@onready var fall_damage_area: HurtBox = $FallDamageArea

var save_active : bool = false

@export var save_name : String = "Save Point X"

signal save_activated( save_point , save_point_position )


func _ready() -> void:
	_update_label()
	fall_damage_area.monitoring = false
	
	if Engine.is_editor_hint():
		return

	visible = false
	save_area.body_entered.connect( _on_body_entered )
	save_area.body_exited.connect( _on_body_exited )

func _on_body_entered( _b : Player ) -> void:
	if _b is Player:
		save_activated.emit( self, self.global_position )
		save_active = true
		#print( save_name + " activated")
		
		#if _b.player_state_machine.current_state is PlayerStateFall:
			#fall_damage_area.monitoring = true
		
			#await get_tree().create_timer( 0.01 ).timeout
			
			#fall_damage_area.monitoring = false
		
		pass
	
func _on_body_exited( _b : Player ) -> void:
	
	pass

func _update_label() -> void:
	if Engine.is_editor_hint():
		label.text = save_name
	pass
