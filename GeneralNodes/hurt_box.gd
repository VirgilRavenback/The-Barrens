class_name HurtBox

extends Area2D

signal did_damage

@export var damage : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered( area_2D : Area2D) -> void:
	if area_2D is HitBox:
		did_damage.emit()
		area_2D.take_damage( self )
		
		
