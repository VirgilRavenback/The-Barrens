class_name EquippableItemModifier extends Resource


enum ModifierType { HEALTH, ATTACK, DEFENSE, ATTACKSPEED, COLOR }
@export var modifier_type : ModifierType = ModifierType.HEALTH
@export var value : int = 1
enum ColorType { NULL, WHITE, YELLOW, RED, BLUE, GREEN, BLACK }
@export var color_type : ColorType = ColorType.WHITE
