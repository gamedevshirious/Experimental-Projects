extends KinematicBody2D

const GRAVITY_VECTOR = Vector2(0, 980)
const UP_DIRECTION = Vector2(0, -1)

export var walk_speed = 250
export var jump_height = 500
var dir = 1 

export var MAX_HP = 200
var hp

var linear_velocity = Vector2()

#
#var head_offset = Vector2(0, 30)
#onready var head = get_node("../head")
onready var abilities = get_node("../abilities")
onready var hp_bar = get_node("head/labels/hp_bar")


func apply_gravity(delta):
	linear_velocity += delta * GRAVITY_VECTOR
	linear_velocity = move_and_slide(linear_velocity, UP_DIRECTION, false)

func move():
	var target_speed = 0
	if Input.is_action_pressed("ui_left"):
		dir = -1		
		target_speed += dir
	if Input.is_action_pressed("ui_right"):
		dir = 1
		target_speed += dir
	set_transform(Transform2D(Vector2(1 * dir ,0), Vector2(0, 1), position))
	$head/labels.scale.x = dir
#	head.set_transform(Transform2D(Vector2(1 * dir ,0), Vector2(0, 1), position))
#	head.position.y = -45
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		linear_velocity.y = -jump_height
	#	print_debug($body.rotation_degrees)
	target_speed *= walk_speed
	linear_velocity.x = lerp(linear_velocity.x, target_speed, 0.1)
	
	if Input.is_action_just_pressed("ability_s"):
		abilities.ability_S()

#func keep_same():
#	head.position = head_offset + position

func _process(delta):
	apply_gravity(delta)
	move()
#	keep_same()
#	attack()
	
func damage(amount, _by="", _type=""):
	hp -= amount
	if hp <= 0:
		get_parent().queue_free()	
	hp_bar.value = hp

#func attack():

func _ready():
	hp = MAX_HP
	hp_bar.max_value = MAX_HP
	hp_bar.value = hp
	
	$head/camera.current = true
	$head/labels/name_label.text = globals.player_name
#	$head/camera.current = true
#	head_offset = head.position
#	base = BaseAbilities.new()
#
#class BaseAbilities:
	
