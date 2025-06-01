class_name GroundDetection extends Area2D


signal falling

func _ready() -> void:
	area_entered.connect( _on_area_entered )

	pass


func _process(_delta: float) -> void:
	pass

func _on_area_entered( _a : Area2D ) -> void:
	if _a is FallHazard:
		falling.emit()
	pass
