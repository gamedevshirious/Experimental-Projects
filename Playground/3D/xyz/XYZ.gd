extends KinematicBody

const MOVE_SPEED = 12
const JUMP_FORCE = 30
const GRAVITY = 0.98
const MAX_FALL_SPEED = 30

const H_LOOK_SENS = 1.0
const V_LOOK_SENS = .1

onready var tpcam = $CameraBase/TPCamera
onready var fpcam = $Mesh/head/head/FPCamera
var cam
var zoomed_in = false
onready var anim = $AnimationTree.get("parameters/playback")

var y_velo = 0

func _ready():
	cam = tpcam
	cam.current = true
	play_anim("idle")
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("change_camera"):
		cam = fpcam if cam != fpcam else tpcam
		cam.current = true
		zoomed_in = false if cam != fpcam else true
	if event is InputEventMouseMotion:
		cam.rotation_degrees.x -= event.relative.y * V_LOOK_SENS
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, 0, 30)# if cam == fpcam else clamp(cam.rotation_degrees.x, 0, 30)
#		$CameraBase/Gun.rotation_degrees.z = cam.rotation_degrees.x
		rotation_degrees.y -= event.relative.x * H_LOOK_SENS


func _process(_delta):
#	$CameraBase/Crosshair.visible = zoomed_in

	var move_vec = Vector3()
	if Input.is_action_pressed("ui_up"):
		move_vec.z -= 1
	if Input.is_action_pressed("ui_down"):
		move_vec.z += 1
	if Input.is_action_pressed("ui_right"):
		move_vec.x += 1
	if Input.is_action_pressed("ui_left"):
		move_vec.x -= 1
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_vec *= MOVE_SPEED
	move_vec.y = y_velo
	move_vec = move_and_slide(move_vec, Vector3(0, 1, 0))

	var grounded = is_on_floor()
	y_velo -= GRAVITY
	var just_jumped = false
	if grounded and Input.is_action_just_pressed("jump"):
		just_jumped = true
		y_velo = JUMP_FORCE
#		play_anim("jump")
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED


#	if Input.is_action_just_pressed("shoot"):
#		if zoomed_in:
#			$CameraBase/Gun.fire_weapon()
	if Input.is_action_just_pressed("focus"):
		if cam.name == "TPCamera":
			if not zoomed_in:
				cam.translation = Vector3(3, 4, 4)
				zoomed_in = true
			else:
				cam.translation = Vector3(0, 4, 8)
				zoomed_in = false

#	if just_jumped:
#		play_anim("jump")
	if grounded:
		if abs(move_vec.x) > 5 or abs(move_vec.z) > 5:
			play_anim("walk")
		else:
			play_anim("idle")
	else:
		play_anim("idle")

func play_anim(name):
#	if anim.get_current_node() == name:
#		return
	anim.travel(name)
