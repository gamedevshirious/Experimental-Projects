extends KinematicBody2D

const GRAVITY_VECTOR = Vector2(0 , 980)
const FLOOR_NORMAL = Vector2(0,-1)
const WALK_SPEED = 250
const JUMP_SPEED = 480
const SLOPE_SLIDE_STOP = 25.0
#const SLIDING_CHANGE_SPEED = 10
#const BULLET_VELOCITY = 1000

var linear_velocity = Vector2()

func _ready():
	pass
	
func _physics_process(delta):
	$Particles2D.emitting = false
	linear_velocity += delta*GRAVITY_VECTOR
	linear_velocity = move_and_slide(linear_velocity , FLOOR_NORMAL , SLOPE_SLIDE_STOP)
	var target_speed = 0
	if Input.is_action_pressed("ui_left"):
		target_speed -= 1
		$Particles2D.emitting = true
	elif Input.is_action_pressed("ui_right") :
		target_speed += 1
		$Particles2D.emitting = true
	
	target_speed *= WALK_SPEED
	linear_velocity.x = lerp(linear_velocity.x , target_speed , 0.1) 

	if is_on_floor() and Input.is_action_just_released("ui_up") :
		linear_velocity.y = -JUMP_SPEED