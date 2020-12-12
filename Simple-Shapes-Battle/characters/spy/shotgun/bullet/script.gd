extends Area2D

var velocity
var speed = 300
var by = ""
var dir 

func start(pos, _dir):
	position = pos
	velocity = speed * _dir
	dir = _dir
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta * 3
#	velocity += Vector2(10, 10)

func _on_Bullet_body_entered(body):
	if body is RigidBody2D:
		body.apply_central_impulse(velocity * 5)
	if body.has_method("damage"):
		body.damage(1, by)
#	$Particles2D.emitting = true
	
	queue_free()
