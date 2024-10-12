extends Node

@export var enemy_state_machine : NodeFiniteStateMachine



func _on_attack_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		enemy_state_machine.transition_to("attack")
		


func _on_attack_area_2d_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		enemy_state_machine.transition_to("chase") 
	


func _on_chase_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		enemy_state_machine.transition_to("chase")


func _on_chase_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		enemy_state_machine.transition_to("idle")
