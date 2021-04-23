extends KinematicBody2D

var GRAVITY_VECTOR = Vector2(0, 98)
const UP_DIRECTION = Vector2(0, -1)

export var walk_speed = 175
var dir = 1
var state = states.IDLE
enum states { PATROL, EAT, IDLE, RUN}


var linear_velocity = Vector2()
var target_speed = 0

func _physics_process(delta):
	# apply gravity
	linear_velocity += delta * GRAVITY_VECTOR
# warning-ignore:return_value_discarded
	move_and_slide(linear_velocity)
	
	match state:
		states.IDLE:
			linear_velocity.x = 0
		states.PATROL:
			linear_velocity.x = lerp(linear_velocity.x, walk_speed * dir, 0.1)
		states.EAT:
			pass
	$StatusLabel.text = str(states.keys()[state])

func _on_BehaviourTimer_timeout():
	match state:
		states.IDLE:
			dir = 1 if rand_range(-1, 1) > 0 else -1
			state = states.get(states.keys()[randi() % 2])
			$BehaviourTimer.start(2)
		states.PATROL:
			state = states.IDLE
			$BehaviourTimer.start(10)
		states.EAT:
			state = states.IDLE
			$BehaviourTimer.start(5)
	
			
