@tool

@icon( "res://NPC/Icons/npc.svg" )

class_name NPC extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


@export var npc_resource : NPCResource : set = _set_npc_resource

var state : String = "idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "down"


signal behavior_enabled


func _ready() -> void:
	setup_NPC()
	if Engine.is_editor_hint():
		return
	
	pass


func setup_NPC() -> void:
	#if npc_resource:
		#sprite_2d.texture = npc_resource.sprite
	pass

func _set_npc_resource( _npc : NPCResource ) -> void:
	npc_resource = _npc
	setup_NPC()
