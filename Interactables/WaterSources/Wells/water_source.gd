class_name WaterSource extends SavePoint


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D
#@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	
	area_2d.area_entered.connect( _on_area_entered )
	area_2d.area_exited.connect( _on_area_exited )
	label.visible = false
	
	pass


func _process(delta: float) -> void:
	pass


func _on_area_entered( a : Area2D ) -> void:
	label.visible = true
	PlayerManager.interact_pressed.connect( player_interact )
	
	pass
	
func _on_area_exited( a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	label.visible = false
	
	pass

func player_interact() -> void:
	##set current healing charges = max healing charges
	PlayerManager.player.current_healing_charges = PlayerManager.player.max_healing_charges
	print("Max healing charges restored")
	## heal player
	#PlayerManager.player.current_health = PlayerManager.player.max_health
	PlayerManager.player.update_health( PlayerManager.player.max_health - 1 )
	print(PlayerManager.player.current_health , " current health")
	## save game -> save manager or save point
	#save_point.save_active = true
	#save_point.save_activated.emit( self, self.global_position )
	## set current save point to be this one -> save point
	##play well animation - Where do I put the player animation?
	pass
