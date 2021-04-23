extends KinematicBody2D

const GRAVITY_VECTOR = Vector2(0,980)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 10.0
const SIDING_CHANGE_SPEED = 10
const WALK_SPEED = 250
const JUMP_SPEED = 400

var net_id = ""

var anim = ""
var dir = 1

var linear_velocity = Vector2()
var state_machine
var power = 2000
var hp = 100

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _process(delta):
	linear_velocity += delta * GRAVITY_VECTOR
	linear_velocity = move_and_slide(linear_velocity , FLOOR_NORMAL , SLOPE_SLIDE_STOP)

	var target_speed = 0
	state_machine.travel("idle")
#	$AnimationPlayer.play("idle")

	if Input.is_action_pressed("ui_left") :
		target_speed -= 1
#		set_global_transform(Transform2D(Vector2(-.1,0),Vector2(0,.1),position))
		dir = -1
		if is_on_floor():
			pass
			#state_machine.travel("walk")

	elif Input.is_action_pressed("ui_right") :
		target_speed += 1
		dir = 1    
		if is_on_floor():
			pass
			#state_machine.travel("walk")

#		set_global_transform(Transform2D(Vector2(.1,0),Vector2(0,.1),position))
#		dir = 1
	if is_on_floor() and Input.is_action_just_pressed("ui_kick"):
		attack()

	if is_on_floor() and Input.is_action_pressed("ui_up") :
		linear_velocity.y = -JUMP_SPEED
	#	print(global_position)
	
	target_speed *= WALK_SPEED
	linear_velocity.x = lerp(linear_velocity.x , target_speed , 0.1)
	
	if not is_on_floor():
		if linear_velocity.y < 0:
			pass
#			state_machine.travel("jump")
		else:
			pass
#			state_machine.travel("fall")

func init_player(name, swordtype = "katana"):
	$Name.text = name +"\n"+ swordtype

func _on_impact_area_body_entered(body):
	if body.has_method("throw"):
		$hit.play()
		body.throw(1)

func attack_start():
	$Sword/CollisionShape2D.disabled = false

func attack_end():
	$Sword/CollisionShape2D.disabled = true


func attack():
	var packet = {}
	packet["reason"] = "attack"
	packet["room_id"] = globals.room_id
	packet["attack"] = "attack"
	globals.send_packet(packet)
	state_machine.travel("attack")

func _on_Sword_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()
