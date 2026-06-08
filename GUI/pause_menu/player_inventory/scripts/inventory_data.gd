class_name InventoryData extends Resource

signal equipment_changed

@export var slots : Array[ SlotData ]
var equipment_slot_count : int = 4


func _init() -> void:
	connect_slots()
	pass
	
func inventory_slots() -> Array[ SlotData ]:
	
	return slots.slice( 0, -equipment_slot_count )

func equipment_slots() -> Array[ SlotData ]:
	
	return slots.slice( -equipment_slot_count, slots.size() )

func add_item( item : ItemData, count : int = 1 ) -> bool:
	for s in slots:
		if s:
			if s.item_data == item:
				s.quantity += count
				return true

	for i in inventory_slots().size():
		if slots[ i ] == null:
			var new = SlotData.new()
			new.item_data = item
			new.quantity = count
			slots[ i ] = new
			new.changed.connect( slot_changed )
			return true
	
	print("inventory was full!")
	return false
	

func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect( slot_changed )

func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect( slot_changed )
				var index = slots.find( s )
				slots [ index ] = null
				emit_changed()
	pass



## Gather the inventory into an array
func get_save_data()-> Array:
	var item_save : Array = []
	for i in slots.size():
		item_save.append( item_to_save( slots[i] ) )
	return item_save
	

## Convert each inventory item into a dictionary that goes into the array
func item_to_save( slot : SlotData ) -> Dictionary:
	var result = { item = "", quantity = 0 }
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result

func parse_save_data( save_data : Array ) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize( array_size )
	for i in save_data.size():
		slots[ i ] = item_from_save( save_data[ i ] )
	connect_slots()

func item_from_save( save_object : Dictionary ) -> SlotData:
	if save_object.item == "":
		return null
	var new_slot : SlotData = SlotData.new()
	new_slot.item_data = load( save_object.item )
	new_slot.quantity = int( save_object.quantity )
	return new_slot

func use_item( item : ItemData, count : int = 1 ) -> bool:
	for s in slots:
		if s:
			if s.item_data == item and s.quantity >= count:
				s.quantity -= count
				return true
	return false

func equip_item( slot : SlotData ) -> void:
	if slot == null or not slot.item_data is EquippableItemData:
		return
	
	var item : EquippableItemData = slot.item_data
	var slot_index : int = slots.find( slot )
	var equipment_index : int = slots.size() - equipment_slot_count #index of 20
	
	match item.type:
		EquippableItemData.ItemType.ARMOR:
			equipment_index += 0
		EquippableItemData.ItemType.WEAPON:
			equipment_index += 1 #21
		EquippableItemData.ItemType.AMULET:
			equipment_index += 2 #22
		EquippableItemData.ItemType.RING:
			equipment_index += 3 #23
	var unequipped_slot : SlotData = slots[ equipment_index ]
	
	slots[ slot_index ] = unequipped_slot
	slots[ equipment_index ] = slot
	
	equipment_changed.emit()
	PauseMenu.focused_item_changed( unequipped_slot )
	
	pass

func get_item_attack() -> int:
	return get_equipment_bonus( EquippableItemModifier.ModifierType.ATTACK )
	pass

func get_equipment_bonus( modifier_type : EquippableItemModifier.ModifierType ) -> int:
	var modifier : int = 1
	
	for s in equipment_slots():
		if s == null:
			continue
		var e : EquippableItemData = s.item_data
		for m in e.modifiers:
			if m.modifier_type == modifier_type:
				modifier = m.value
	return modifier

func get_item_color() -> String:
	var current_color : String = ""
	
	for s in equipment_slots():
		if s == null:
			continue
		var e : EquippableItemData = s.item_data
		for m in e.modifiers:
			if m.modifier_type == EquippableItemModifier.ModifierType.COLOR:
				current_color = convert_color( m.color_type )
	return current_color

func convert_color( c : EquippableItemModifier.ColorType ) -> String:
	if c == 0:
		return "null"
	elif c == 1:
		return "white"
	elif c == 2:
		return "yellow"
	elif c == 3:
		return "red"
	elif c == 4:
		return "blue"
	elif c == 5:
		return "green"
	elif c == 6:
		return "black"
	else:
		return "null"
