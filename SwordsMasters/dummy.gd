extends KinematicBody2D

const GRAVITY_VECTOR = Vector2(0,980)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 10.0
const SIDING_CHANGE_SPEED = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var power = 100
var linear_velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func throw(_dir):
	var new_position = position
	new_position.x += _dir * power 
	new_position.y -= power / 5
#	lerp(position, new_position, .1)

	$Tween.interpolate_property(
		self,
		"position",
		position,
		new_position,
		.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	
	$Tween.start()



func _on_impact_area_body_entered(body):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	linear_velocity += delta * GRAVITY_VECTOR
	linear_velocity = move_and_slide(linear_velocity , FLOOR_NORMAL , SLOPE_SLIDE_STOP)
	
	$AnimationPlayer.play("idle")
	#	pass
