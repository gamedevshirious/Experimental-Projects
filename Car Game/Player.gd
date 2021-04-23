extends VehicleBody

const MAX_STEER_ANGLE = .35
const STEER_SPEED = 1

const MAX_ENGINE_FORCE = 175
const MAX_BRAKE_FORCE = 10

var steer_target = .0
var steer_angle = .0

func _physics_process(delta):
	drive(delta)
	
	
func drive(delta):
	steering = apply_steering(delta)
	engine_force = apply_throttle()
	
	
func apply_steering(delta):
	var steer_val = 0
	var left = Input.get_action_strength("ui_left")
	var rght = Input.get_action_strength("ui_right")
	
	if left: steer_val = left
	elif rght: steer_val = -rght
	
	steer_target = steer_val * MAX_STEER_ANGLE
	
	if steer_target < steer_angle:
		steer_angle -= STEER_SPEED * delta 
	
	elif steer_target > steer_angle:
		steer_angle += STEER_SPEED * delta
	
	return steer_angle
	
func apply_throttle():
	var throttle_val = 0
	var frwd = Input.get_action_strength("ui_up")
	var back = Input.get_action_strength("ui_down")
	
	if back: throttle_val = -back
	elif frwd: throttle_val = frwd
	
	return throttle_val * MAX_ENGINE_FORCE