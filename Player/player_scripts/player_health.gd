class_name PlayerHealth extends Node

@onready var player_state_machine: PlayerStateMachine = $"../PlayerStateMachine"
@onready var hurt_box: HurtBox = $"../PlayerInteractions/HurtBox"
@onready var stat_component: PlayerStats = $"../StatComponent"


@export_category("Health")
@export var current_health : int = 5
@export var max_health : int = 5

@export_category("Healing")
@export var current_healing_charges : int = 0
@export var max_healing_charges : int = 3

signal player_damaged( hurt_box : HurtBox )

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass

func _take_damage ( hurt_box : HurtBox ) -> void:
	if stat_component.invulnerable == true and player_state_machine.current_state != PlayerStateFall:
		return
	
	if current_health > 0:
		update_health( -hurt_box.damage )
		player_damaged.emit( hurt_box )
	
	pass

func update_health( delta : int ) -> void:
	current_health = clampi( current_health + delta, 0, max_health )
	PlayerHud.update_health( current_health, max_health )
	pass

func revive_player() -> void:
	update_health( 5 )
	player_state_machine.change_state( $PlayerStateMachine/Idle )
