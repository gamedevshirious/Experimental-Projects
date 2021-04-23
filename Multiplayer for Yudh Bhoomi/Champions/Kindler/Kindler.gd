extends KinematicBody2D


slave var slave_data = {
	id = "1",
	name="", 
	hero = "",
	pos=Vector2(),
	anim = ""
}

var data = {
	id = "1",
	name="", 
	hero = "",
	pos=Vector2(),
	anim = ""
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var move_speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(_data):
	$Label.text = _data.name
	
	data = _data
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_network_master():
		# slave_data.pos = position
	#	rset_unreliable('slave_data', slave_data)
		if Input.is_action_pressed("ui_up"):
			position.y -= move_speed * delta
		if Input.is_action_pressed("ui_down"):
			position.y += move_speed * delta
		if Input.is_action_pressed("ui_left"):
			position.x -= move_speed * delta
		if Input.is_action_pressed("ui_right"):
			position.x += move_speed * delta

		rset_unreliable('slave_data', slave_data)
	else:
		pass
	
	if get_tree().is_network_server():
		data.pos = position
		Network.update_data(int(name), data)
#	pass
