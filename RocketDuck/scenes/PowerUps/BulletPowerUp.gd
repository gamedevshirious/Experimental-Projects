extends Area2D

var speed = 250
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta
#	pass


func _on_Bullet_PowerUp_body_entered(body):
	if body.has_method("get_powerup"):
		body.call("get_powerup", "bullet", 10)
		queue_free()
