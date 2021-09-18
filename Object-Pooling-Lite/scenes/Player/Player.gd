extends KinematicBody2D


export var speed = 200
var linear_velocity = Vector2()

func _physics_process(delta):
	# Shoot	
	var target_velocity = Vector2()
	
	if Input.is_action_pressed("ui_left"):
		rotate(.1)
	if Input.is_action_pressed("ui_right"):
		rotate(-.1)
	if Input.is_action_pressed("ui_up"):
		target_velocity.x += speed 
	if Input.is_action_pressed("ui_down"):
		target_velocity.x -= speed
	
	linear_velocity = lerp(linear_velocity, target_velocity, .1)
	linear_velocity = move_and_slide(linear_velocity)
