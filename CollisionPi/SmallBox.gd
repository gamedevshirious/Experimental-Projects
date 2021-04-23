extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#linear_velocity = Vector2(-100, 0)
	
#	pass


#	if body.name == "CollisionCounter" :
#		linear_velocity = Vector2(0, 0)
	

func _on_SmallBox2_body_entered(body):
	print(body.name)