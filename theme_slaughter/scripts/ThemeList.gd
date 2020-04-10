extends Node

var path = "res://themes.txt"
var loaded = false
var full_list = []
var cur_list = []


# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomize RNG seed
	randomize()
	load_themes()
	print("Done loading themes!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func load_themes():
	var file = File.new()
	var content = ""

	file.open(path, File.READ)
	while file.is_open() and not file.eof_reached():
		content = file.get_csv_line()
		full_list.push_back(content)

	if file.is_open():
		file.close()
	
	full_list.shuffle()
	cur_list = full_list.duplicate()
	loaded = true


func reset():
	loaded = false
	cur_list.clear()
	cur_list = full_list.duplicate()
	loaded = true


func get_next():
	var next_theme = cur_list.pop_back()
	# Return as string instead of PoolStringArray
	return next_theme[0]


func get_count():
	return full_list.size()


func get_remaining():
	return cur_list.size()


func is_loaded():
	return loaded
