extends NodeState

@onready var character_body_2d: CharacterBody2D = $"../.."
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

@export var slow_down_speed: int = 100


func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(delta: float):
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, slow_down_speed * delta)
	animation_player.play("idle_down")
	character_body_2d.move_and_slide()
	
func enter():
	pass

func exit():
	pass
