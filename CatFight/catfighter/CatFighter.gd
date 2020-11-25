extends KinematicBody2D

const GRAVITY_VECTOR = Vector2(0,980)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 10.0
const SIDING_CHANGE_SPEED = 10
const WALK_SPEED = 250
const JUMP_SPEED = 750

var anim = ""
var dir = 1
var gun_picked = false

export (PackedScene) var gun

var linear_velocity = Vector2()
var state_machine
var power = 2000

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	$hand/CollisionShape2D.disabled = true
	$leg/CollisionShape2D.disabled = true

func _process(delta):
	linear_velocity += delta * GRAVITY_VECTOR
	linear_velocity = move_and_slide(linear_velocity , FLOOR_NORMAL , SLOPE_SLIDE_STOP)

	var target_speed = 0
	if !gun_picked:
		state_machine.travel("idle")
	else:
		state_machine.travel("idle_gun")
	
	if Input.is_action_pressed("plr_1_left") :
		target_speed -= 1
		if is_on_floor():
			state_machine.travel("walk")
		set_global_transform(Transform2D(Vector2(-5,0),Vector2(0,5),position))
		dir = -1
	
	elif Input.is_action_pressed("plr_1_right") :
		target_speed += 1	
		if is_on_floor():
			state_machine.travel("walk")
		set_global_transform(Transform2D(Vector2(5,0),Vector2(0,5),position))
		dir = 1

	if Input.is_action_just_released("plr_1_light"):# and animation_completed:
		state_machine.travel("punch")
	#	new_anim = "punch"
	#	animation_completed = false
		
	if Input.is_action_just_pressed("plr_1_heavy") :#and animation_completed:
		state_machine.travel("kick")
#		animation_completed = false
	if Input.is_action_pressed("drop"):
		gun_picked = false
		gun = preload("res://gun.tscn").instance()
		gun.position = get_parent().get_node("CatFighter").global_position + Vector2(100, 100)
		gun.scale = Vector2(2.5, 2.5)
		get_parent().add_child(gun)
		
		
	if is_on_floor() and Input.is_action_pressed("plr_1_jump") :
		linear_velocity.y = -JUMP_SPEED
	
	target_speed *= WALK_SPEED
	linear_velocity.x = lerp(linear_velocity.x , target_speed , 0.1)
	
	
	if not is_on_floor():
		if linear_velocity.y < 0:
			state_machine.travel("jump")
		else:
			state_machine.travel("fall")
	
func punch_started():
	$hand/CollisionShape2D.disabled = false

func punch_finished():
	$hand/CollisionShape2D.disabled = true

func _on_hand_body_entered(body):
	if body.has_method("apply_impulse"):
		body.apply_impulse(Vector2(), Vector2(dir * power, 0))

func kick_started():
	$leg/CollisionShape2D.disabled = false

func kick_finished():
	$leg/CollisionShape2D.disabled = true

func _on_leg_body_entered(body):
	if body.has_method("apply_impulse"):
		body.apply_impulse(Vector2(), Vector2(dir * power, 0))

func pick_gun():
	gun_picked = true

	#if $cat/AnimationPlayer.current_animation == "punch": 
	
	#if new_anim != anim :#and !animation_completed:
	#	anim = new_anim
	#	state_machine.travel(anim)
	#	$sprite.play(anim)
	#	if anim == "punch":
	#		animation_completed = false
		

#func _on_sprite_animation_finished():
#	if anim == "punch":
#		animation_completed = true
	
	#if Input.is_action_pressed("plr_1_left") and not Input.is_action_pressed("plr_1_right"):
	#	scale.x = -5
	#if Input.is_action_pressed("plr_1_right") and not Input.is_action_pressed("plr_1_left"):
	#	scale.x = 5
	#$CollisionShape2D.position.x = abs($CollisionShape2D.position.x) * move_direction
#	if on_floor:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
	#if Input.is_action_pressed("plr_1_left") and not Input.is_action_pressed("plr_1_right"):
	#	scale.x = 5
	#if Input.is_action_pressed("plr_1_right") and not Input.is_action_pressed("plr_1_left"):
	#	scale.x = -5

	



