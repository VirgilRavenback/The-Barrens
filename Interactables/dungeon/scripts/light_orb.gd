class_name BLueLightOrb extends StaticBody2D

@onready var hit_box: HitBox = $hit_box
@onready var polygon_2d: Polygon2D = $Polygon2D

var switch_on : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_box.damaged.connect( _on_hit )
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func turn_on() -> void:
	switch_on = true
	polygon_2d.modulate = Color( 0,0,0 )
	pass

func turn_off() -> void:
	switch_on = false
	polygon_2d.modulate = Color( 0,100,255 )
	pass

func _on_hit( hurt_box : HurtBox ) -> void:
	if not hurt_box.current_light_type == "blue":
		return
	else:
		if switch_on == true:
			turn_off()
		else:
			turn_on()
		print( "switch is", switch_on )
		
	pass
