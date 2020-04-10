extends RigidBody2D

signal despawned

export var min_speed = 150 # Minimum speed range.
export var max_speed = 250 # Maximum speed range.
var mob_types = ["walk", "swim", "fly"]
var exploding = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func remove():
	if exploding:
		$ExplodeSound.stop()
		$Explosion.stop()
	queue_free()


func explode():
	exploding = true
	$ThemeLabel.visible = false
	$Explosion.visible = true
	$Explosion.play()
	$ExplodeSound.play()
	emit_signal("despawned", true)
	yield($Explosion, "animation_finished")
	yield($ExplodeSound, "finished")
	remove()


# Callback on exit screen to delete the mob
func _on_Visibility_screen_exited():
	emit_signal("despawned", false)
	remove()


# Called at start of game to delete any leftover mobs
func _on_start_game():
	# Don't emit signal in this case
	remove()


func _on_shot():
	if not exploding:
		# Check if mob was hit by player's shot
		var mouse_pos = get_global_mouse_position()
	
		var intersections = get_world_2d().direct_space_state.intersect_point( 
				mouse_pos, 32, [], 0x7FFFFFFF, true, true)
	
		for i in range(intersections.size()):
			if intersections[i].collider == self:
				explode()


func set_text(text):
	$ThemeLabel.text = text
	var string_size = $ThemeLabel.get_font("font").get_string_size(text)
	# Resize the collision rect to match the text size
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.extents = string_size
