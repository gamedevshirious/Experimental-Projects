extends KinematicBody2D

export (InputEventKey) var up_key
export (InputEventKey) var down_key

export var bat_speed = Vector2(0, 2)

func _ready():
	pass

func move(_moving_dir) :
	bat_speed.normalized()
	
	if _moving_dir == "up" :
		position -= bat_speed
	if _moving_dir == "down" :
		position += bat_speed

func _process(delta):
	"""
	if Input.is_action_pressed("ui_up"):
		move("up")
	if Input.is_action_pressed("ui_down"):
		move("down")
	"""
	if Input.is_key_pressed(up_key.scancode) :
		move("up")
	if Input.is_key_pressed(down_key.scancode) :
		move("down")