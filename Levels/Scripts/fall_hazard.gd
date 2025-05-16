class_name FallHazard extends Node2D


@onready var area_2d: Area2D = $Area2D


signal falling

func _ready() -> void:
	area_2d.area_entered.connect( _on_area_entered )
	area_2d.area_exited.connect( _on_area_exited )
	pass 



func _process(delta: float) -> void:
	pass


func _on_area_entered( _b : Player ) -> void:

	pass

func _on_area_exited( _b : Player ) -> void:
	
	pass
