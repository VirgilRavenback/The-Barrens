class_name FacadeControl extends Node2D


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D



var facade_visible : bool = true


func _ready() -> void:
	area_2d.body_entered.connect( _on_body_entered )
	
	pass 



func _process(_delta: float) -> void:
	pass

func _on_body_entered( _b : Node2D ) -> void:
	if _b is Player:
		if facade_visible == true:
			sprite_2d.visible = false
			facade_visible = false
		elif facade_visible == false:
			sprite_2d.visible = true
			facade_visible = true
	pass
