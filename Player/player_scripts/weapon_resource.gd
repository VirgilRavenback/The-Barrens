class_name WeaponResource extends Resource


enum COLORS { WHITE, RED, BLUE, GREEN, YELLOW, BLACK  }

@export var weapon_name : String
@export var texture : Texture2D
@export var damage : float = 5.0
@export var cooldown : float = 0.2
@export var color : COLORS

@export var projectile_scene : PackedScene

@export var is_ranged : bool = false
@export var is_available : bool = false
