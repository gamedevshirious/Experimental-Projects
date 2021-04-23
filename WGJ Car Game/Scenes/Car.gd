extends KinematicBody2D

export var rotation_speed = 20
export var init_speed = 0
var velocity = Vector2()

func _ready():
	$Sprite.texture = preload("res://Sprites/1.png")
	pass

func _physics_process(delta):
	var rot_dir = 0
	
	if Input.is_action_pressed('ui_up'):
		rot_dir += 1
	if Input.is_action_pressed('ui_down'):
		rot_dir -= 1
		
	velocity = Vector2()
	rotation += rotation_speed * rot_dir * delta
	velocity = Vector2(init_speed, 0).rotated(rotation)
	init_speed += 1
	move_and_slide(velocity)
