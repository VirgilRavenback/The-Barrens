class_name EquippableItemData extends ItemData

enum ItemType { WEAPON, ARMOR, AMULET, RING }
@export var type : ItemType = ItemType.WEAPON
@export var modifiers : Array[ EquippableItemModifier ]
