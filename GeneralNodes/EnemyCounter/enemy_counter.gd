class_name EnemyCounter
extends Node2D

var all_enemies_defeated : bool = false

signal enemies_defeated

func _ready() -> void:
	count_enemies()
	child_exiting_tree.connect( _on_enemy_destroyed )


func _on_enemy_destroyed( e : Node2D ) -> void:
	if e is Enemy:
		if count_enemies() <= 1:
			enemies_defeated.emit()
	pass

func count_enemies() -> int:
	var _count : int = 0
	for c in get_children():
		if c is Enemy:
			_count +=1
	return _count
