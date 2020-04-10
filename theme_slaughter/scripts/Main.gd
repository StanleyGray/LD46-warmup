extends Node

signal shot

export (PackedScene) var Mob
var score = 0
var despawned = 0
var shoot_enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomize RNG seed
	randomize()
	if $ThemeList.is_loaded():
		$HUD.update_count($ThemeList.get_count())
	$HUD.update_score(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Change the target whenever a touch event happens.
func _input(event):
	# Touch event or mouse click
	if event is InputEventScreenTouch and event.pressed:
		shoot()
	# Keyboard key press	
	elif event is InputEventKey and event.pressed \
			and (event.scancode == KEY_Z or event.scancode == KEY_SPACE):
		shoot()


func shoot():
	if shoot_enabled:
		$ShootSound.play()
		emit_signal("shot")


func game_over():
	despawned = 0	
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$CompleteSound.play()
	$ThemeList.reset()


func new_game():
	score = 0
	despawned = 0
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_count($ThemeList.get_count())
	$HUD.show_message("Slaughter\nthose themes!")
	$Music.play()


func spawn(text):
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	mob.set_text(text)
	
	var _err
	_err = self.connect("shot", mob, "_on_shot")
	# Connect mob to start_game signal (to remove any remaining from previous game)
	_err = $HUD.connect("start_game", mob, "_on_start_game")
	_err = mob.connect("despawned", self, "_on_mob_despawned")

func _on_StartTimer_timeout():
	# Start the game - enable mob spawning and player shooting
	$MobTimer.start()
	shoot_enabled = true


func _on_MobTimer_timeout():
	if $ThemeList.is_loaded() and $ThemeList.get_remaining() > 0:
		#print("Spawning mob")
		var mob_text = $ThemeList.get_next()
		spawn(mob_text)


func _on_mob_despawned(killed):
	despawned += 1
	if killed:
		score += 1
		$HUD.update_score(score)
	if despawned >= $ThemeList.get_count():
		game_over()	
