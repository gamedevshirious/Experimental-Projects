extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rot_speed = 5
var plane_speed = 10
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$sprite.texture = load("res://sprites/Ships/spaceShips_00"+str(randi() % 10)+".png")
	pass # Replace with function body.

func is_plane():
	return true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rot_dir = 0
	if Input.is_action_pressed("ui_left"):
		rot_dir -= 1
	if Input.is_action_pressed("ui_right"):
		rot_dir += 1
	
	rotation += rot_speed * rot_dir * delta
	position += Vector2(0, -plane_speed).rotated(rotation)
#	pass
func score():
	score += 10
	
