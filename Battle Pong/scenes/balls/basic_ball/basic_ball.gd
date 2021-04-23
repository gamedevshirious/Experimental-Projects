extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$effect.interpolate_property($ball, 'transform/scale', $ball.get_scale(), 
	Vector2(5.0, 5.0), .5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	$effect.interpolate_property($ball, 'visibility/opacity', 1, 0, 
	.5, Tween.TRANS_QUAD, Tween.EASE_OUT) 


func _on_ball_body_entered(body):
	print("hello")
	$effect.start()

func _on_effect_tween_completed(object, key):
	queue_free()

func _on_effect_tween_started(object, key):
	print("world")