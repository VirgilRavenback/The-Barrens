class_name FallHazard extends Area2D


@onready var hurt_box: HurtBox = $HurtBox




func _ready() -> void:
	#body_entered.connect( _on_body_entered )
	#body_exited.connect( _on_body_exited )
	pass 



func _process(delta: float) -> void:
	pass


func _on_body_entered( _b : Player ) -> void:
	pass

func _on_body_exited( _b : Player ) -> void:
	
	pass
	
