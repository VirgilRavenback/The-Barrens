class_name Grass

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$hit_box.damaged.connect (take_damage)
	pass # Replace with function body.

func take_damage(_damage : int) -> void:
	queue_free()
