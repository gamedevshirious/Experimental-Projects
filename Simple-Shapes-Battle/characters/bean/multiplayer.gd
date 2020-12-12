extends KinematicBody2D

const GRAVITY_VECTOR = Vector2(0, 980)
const UP_DIRECTION = Vector2(0, -1)

export var walk_speed = 250
export var jump_height = 500
var dir = 1 

export var MAX_HP = 200
var hp = 0


var linear_velocity = Vector2()
onready var abilities = get_node("../abilities")
onready var hp_bar = get_node("head/labels/hp_bar")

puppet var _angular_velocity = 0
puppet var _dir = 1
puppet var _linear_velocity = Vector2()
puppet var _hp = 100

func move():
	if is_network_master():
		var target_speed = 0
		if Input.is_action_pressed("ui_left"):
			dir = -1		
			target_speed += dir
		if Input.is_action_pressed("ui_right"):
			dir = 1
			target_speed += dir
	#	head.set_transform(Transform2D(Vector2(1 * dir ,0), Vector2(0, 1), position))
	#	head.position.y = -45
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			linear_velocity.y = -jump_height
		#	print_debug($body.rotation_degrees)
		target_speed *= walk_speed
		linear_velocity.x = lerp(linear_velocity.x, target_speed, 0.1)
		
		if Input.is_action_just_pressed("ability_s"):
			rpc("ability_S")
		
		
#		rset("_angular_velocity", $body.angular_velocity)
		rset("_dir", dir)
		rset("_linear_velocity", linear_velocity)
	else:
#		$body.angular_velocity = _angular_velocity
		dir = _dir
		linear_velocity = _linear_velocity
	set_transform(Transform2D(Vector2(1 * dir, 0), Vector2(0, 1), position))
	$head/labels.scale.x = dir
# warning-ignore:unused_argument
func set_player_info(info):
	$head/labels/name_label.text = info["name"]

# warning-ignore:unused_argument
func _process(delta):
	apply_gravity(delta)
	move()


func apply_gravity(delta):
	linear_velocity += delta * GRAVITY_VECTOR
	linear_velocity = move_and_slide(linear_velocity, UP_DIRECTION, false)

sync func damaged(amount, _by="", _type=""):
	hp -= amount
	if hp <= 0:
		get_parent().queue_free()
		return
	hp_bar.value = hp

func damage(amount, _by="", _type=""):
	rpc("damaged", amount, _by, _type)

sync func ability_S():
	abilities.ability_S()

func _ready():
	if is_network_master():
		$head/camera.current = true
	if not is_network_master():
		hp_bar.hide()
	hp = MAX_HP
	hp_bar.max_value = MAX_HP
	hp_bar.value = hp
