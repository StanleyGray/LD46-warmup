extends CanvasLayer

signal start_game


# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide just in case we didn't hide it in the scene editor
	$MessageLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Show the title screen message (and hide the custom message if visible)
func show_title():
	$MessageLabel.hide()
	$TitleContainer/TitleLabel.show()
	$TitleContainer/SubtitleLabel.show()


# Show the custom message (and hide the title screen message if visible)
func show_message(message):
	$MessageLabel.text = message
	$TitleContainer/TitleLabel.hide()
	$TitleContainer/SubtitleLabel.hide()
	$MessageLabel.show()
	
	# Pause for message wait time and then hide the message
	$MessageTimer.start()
	yield($MessageTimer, "timeout")
	$MessageLabel.hide()


func show_game_over():
	show_message("Game Over\nThat's all the themes!")

	# Return to title screen
	show_title()
	# Pause for a few sec
	yield(get_tree().create_timer(5), "timeout")
	# Show the start button
	$StartButton.show()		


# Called whenever score changes to display updated score
func update_score(score):
	$ScoreContainer/ScoreBar/ScoreLabel.text = str(score)


# Called once (per game) to set total possible score
func update_count(count):
	$ScoreContainer/ScoreBar/CountLabel.text = str(count)


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$MessageLabel.hide()
