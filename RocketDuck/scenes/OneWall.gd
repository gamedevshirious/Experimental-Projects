extends KinematicBody2D

var linear_vel = Vector2()
var collide
var speed = 450 

signal game_over
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#linear_vel.x -= speed #* delta
	position.x -= speed * delta
	collide = move_and_collide(linear_vel)
	if collide:
		if collide.collider.has_method("shoot"):
			emit_signal("game_over")
		if collide.collider.has_method("explode"):
			queue_free()
			collide.collider.explode()
		else:
			queue_free()
		#if collide.get_method_list() :
		#	queue_free()
		#else:
		#	pass
			#emit_signal("game_over")
		
		# get_tree().paused = true
#	pass
