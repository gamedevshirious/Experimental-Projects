extends KinematicBody2D

const GRAVITY_VECTOR = Vector2(0, 980)
const UP_DIRECTION = Vector2(-1, 0)

export var walk_speed = 250
export var jump_height = 500

var linear_velocity = Vector2()

func _physics_process(delta):
	# apply gravity
	linear_velocity += delta * GRAVITY_VECTOR
	linear_velocity = move_and_slide(linear_velocity, UP_DIRECTION, false)
	
	var target_speed = 0
	if Input.is_action_pressed("ui_left"):
		target_speed -= 1
		$sprite.scale.x = -1
	if Input.is_action_pressed("ui_right"):
		target_speed += 1
		$sprite.scale.x = 1
		
	if Input.is_action_just_pressed("ui_up"):
		linear_velocity.y = -jump_height
	
	target_speed *= walk_speed
	linear_velocity.x = lerp(linear_velocity.x, target_speed, 0.1)
	
	if is_on_wall():
		$status_label.text = "is_on_wall"

	if is_on_floor():
		$status_label.text = "is_on_floor"
		
	if is_on_ceiling():
		$status_label.text = "is_on_ceiling"
		
	if not (is_on_ceiling() or is_on_floor() or is_on_wall()):
		$status_label.text = ""
		
