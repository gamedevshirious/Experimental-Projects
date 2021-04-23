extends KinematicBody2D

const GRAVITY_VECTOR = Vector2(0,980)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 10.0
const SIDING_CHANGE_SPEED = 10
const WALK_SPEED = 250
const JUMP_SPEED = 480

var linear_velocity = Vector2()
onready var sprite = $sprite

func _ready():
	pass

func _physics_process(delta):
	linear_velocity += delta * GRAVITY_VECTOR
	linear_velocity = move_and_slide(linear_velocity , FLOOR_NORMAL , SLOPE_SLIDE_STOP)

	var target_speed = 0
	var on_floor = is_on_floor()
	if is_on_floor() :
		on_floor = true
	
	if Input.is_action_pressed("ui_left") :
		target_speed -= 1
	elif Input.is_action_pressed("ui_right") :
		target_speed += 1
	
	if on_floor and Input.is_action_pressed("ui_jump") :
		linear_velocity.y = -JUMP_SPEED
			
	if on_floor:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			sprite.scale.x = -1
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			sprite.scale.x = 1
	
	target_speed *= WALK_SPEED
	linear_velocity.x = lerp(linear_velocity.x , target_speed , 0.1)
