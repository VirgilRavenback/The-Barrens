extends Node2D

const STARTING_LEVEL : String = "res://Levels/town01.tscn"


@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_press_audio : AudioStream

@onready var button_new_game: Button = $CanvasLayer/Control/ButtonNew
@onready var button_continue: Button = $CanvasLayer/Control/Button2Continue
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D



func _ready() -> void:
	get_tree().paused = true
	PlayerManager.player.visible = false
	
	PlayerHud.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	
	if SaveManager.get_save_file() == null:
		button_continue.disabled = true
		button_continue.visible = false

	#$CanvasLayer/SplashScreen.finished.connect( setup_title_screen )
	
	setup_title_screen()
	
	LevelManager.level_load_started.connect( exit_title_screen )
	pass 


func setup_title_screen() -> void:
	AudioManager.play_music( music )
	button_new_game.pressed.connect( start_game )
	button_new_game.grab_focus()
	button_continue.pressed.connect( load_game )
	
	button_new_game.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	button_continue.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	
	pass


func start_game() -> void:
	LevelManager.load_new_level( STARTING_LEVEL, "", Vector2.ZERO )
	play_audio( button_press_audio )
	pass

func load_game() -> void:
	SaveManager.load_game()
	play_audio( button_press_audio )
	pass



func exit_title_screen() -> void:
	PlayerManager.player.visible = true
	PlayerHud.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	
	self.queue_free()
	pass

func play_audio( _a : AudioStream ) -> void:
	audio_stream_player_2d.stream = _a
	audio_stream_player_2d.play()
