extends CanvasLayer


@export var button_focus_audio : AudioStream = preload( "res://Title_Scene/audio/menu_focus.wav" )
@export var button_select_audio : AudioStream = preload( "res://Title_Scene/audio/menu_select.wav" )

var hearts : Array[ HeartGUI ] = []

@onready var game_over: Control = $Control/GameOver
@onready var button_continue: Button = $Control/GameOver/VBoxContainer/ButtonContinue
@onready var button_title_screen: Button = $Control/GameOver/VBoxContainer/ButtonTitleScreen
@onready var animation_player: AnimationPlayer = $Control/GameOver/AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

#Boss UI
@onready var boss_ui: Control = $Control/Boss_UI
@onready var boss_hp_bar: TextureProgressBar = $Control/Boss_UI/TextureProgressBar
@onready var boss_label: Label = $Control/Boss_UI/Label

@onready var notification: NotificationUI = $Control/Notification


func _ready() -> void:
	for child in $Control/HBoxContainer.get_children():
		if child is HeartGUI:
			hearts.append( child )
			child.visible = true
	
	hide_game_over_screen()
	button_continue.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	button_continue.pressed.connect( load_game )
	button_title_screen.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	button_title_screen.pressed.connect( load_title_screen )
	LevelManager.level_load_started.connect( hide_game_over_screen )
	
	hide_boss_health()

	pass 

func update_health( _current_health: int, _max_health: int ) -> void:
	update_max_health( _max_health )
	for i in _max_health:
		update_heart( i, _current_health )
	pass

func update_heart( _index : int, _health : int ) -> void:
	var _value : int = clampi( _health - _index, 0, 1 )
	hearts[ _index ].value = _value
	pass

func update_max_health( _max_health : int )-> void:
	#var _heart_count : int = roundi( _max_health )
	#for i in hearts.size():
		#if i < _heart_count:
			#hearts[i].visible = true
		#else:
			#hearts[i].visible = false
	pass


func show_game_over_screen() -> void:
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var can_continue : bool = SaveManager.get_save_file() != null
	button_continue.visible = can_continue
	
	animation_player.play( "show_game_over" )
	await animation_player.animation_finished
	
	if can_continue == true:
		button_continue.grab_focus()
	else:
		button_title_screen.grab_focus()
	#focus button by default
	
func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color( 1,1,1,0 )

func load_game() -> void:
	play_audio( button_select_audio )
	await  fade_to_black()
	SaveManager.load_game()
	pass

func load_title_screen() -> void:
	play_audio( button_select_audio )
	await  fade_to_black()
	LevelManager.load_new_level( "res://Title_Scene/title_screen.tscn", "", Vector2.ZERO )
	pass

func fade_to_black() -> bool:
	animation_player.play( "fade_to_black" )
	await animation_player.animation_finished
	PlayerManager.player.revive_player()
	return true



func play_audio( _a : AudioStream ) -> void:
	audio.stream = _a
	audio.play() 

func show_boss_health( _boss_name : String ) -> void:
	boss_ui.visible = true
	boss_label.text = _boss_name
	update_boss_health( 1, 1 )
	pass

func hide_boss_health() -> void:
	boss_ui.visible = false
	pass

func update_boss_health( _hp : int, _max_hp : int ) -> void:
	boss_hp_bar.value = clampf( float(_hp) / float(_max_hp) * 100, 0.0, 100.0 )
	pass

func queue_notification( _title : String, _message : String ) -> void:
	notification.add_notification_to_queue( _title, _message )
	pass
