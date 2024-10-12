extends CanvasLayer

#@onready var start_message = 

# Notifies Game node that the Start button has been pressed
signal start_game

# Display message temporarily
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	#print("Debug: Message Timer Started")

# hide the message label when the timer times out
func _on_message_timer_timeout():
	$Message.hide()

#Process what happens when player  loses
#Show "Game Over" for 2 seconds, return to title screen, and show Start button
func show_game_over():
	#print("Debug: show_game_over called")
	show_message("Game Over")
	await get_tree().create_timer(1.0).timeout
	$Message.hide()
	$StartButton.show()
	
func show_win_screen():
	show_message("You Win!")
	await get_tree().create_timer(1.0).timeout
	$Message.hide()
	$StartButton.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_pressed():
	print("Debug: Start Button Pressed")
	$StartButton.hide()
	start_game.emit()
