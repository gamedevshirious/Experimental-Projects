extends KinematicBody2D

var GRAVITY_VECTOR = Vector2(0, 980)
const UP_DIRECTION = Vector2(0, -1)

export var walk_speed = 125
var dir = 1
var state = states.IDLE
enum states { PATROL, IDLE, HUNT }


var linear_velocity = Vector2()
var target_speed = 0

func _physics_process(delta):
	# apply gravity
	linear_velocity += delta * GRAVITY_VECTOR
# warning-ignore:return_value_discarded
	move_and_slide(linear_velocity)

	if state == states.PATROL:
		linear_velocity.x = lerp(linear_velocity.x, walk_speed * dir, 0.1)
	elif state == states.IDLE:
		linear_velocity.x = 0


func _on_BehaviourTimer_timeout():
	match state:
		states.IDLE:
			dir = 0 - dir
			state = states.PATROL
			$BehaviourTimer.start(2)
		states.PATROL:
			state = states.IDLE
			$BehaviourTimer.start(5)
	
			
