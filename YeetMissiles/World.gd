extends Node

var difficulty = 5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var missile

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_number_of_levels())
#	pass # Replace with function body.

func get_number_of_levels(path = "res://levels"):
	var dir = Directory.new()
	var levels = 0
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				levels += 1
			file_name = dir.get_next()
		return levels
	else:
		print("An error occurred when trying to access the path.")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$GUI/ScoreLabel.text = "Score: " + str($Plane.score)
#	pass


func _on_Timer_timeout():
	missile = preload("res://Missile.tscn").instance()
	missile.position = get_node("MissileSpawner/missile1").global_position
	missile.init(difficulty)
	get_tree().get_root().add_child(missile)
	difficulty += .1
