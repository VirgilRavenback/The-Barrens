class_name InteractionArea extends Node2D

@onready var interaction_area: Area2D = $"."


func _ready() -> void:
	interaction_area.area_entered.connect( _on_area_entered )
	interaction_area.area_exited.connect( _on_area_exited )
	pass 



func _process(_delta: float) -> void:
	pass

func _on_area_entered( b ) -> void:
	if b is InteractionArea:
		pass
	
	pass

func _on_area_exited( b ) -> void:
	
	
	pass
