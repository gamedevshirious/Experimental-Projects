extends KinematicBody2D

export var rotation_speed = 20
export var speed = 10
var velocity = Vector2()

func _ready():
	pass

func _physics_process(delta):
	var rot_dir = 0
	if Input.is_action_pressed('ui_up'):
		rot_dir += 1
	if Input.is_action_pressed('ui_down'):
		rot_dir -= 1
	if Input.is_action_just_pressed('ui_accept'):
		printerr(rotation)
	velocity = Vector2()
	rotation += rotation_speed * rot_dir * delta
	velocity = Vector2(speed, 0).rotated(rotation)
	speed += rand_range(2,100)
	move_and_slide(velocity)