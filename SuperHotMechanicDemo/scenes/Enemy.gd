extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = get_parent().get_parent().get_node("Player")
var speed = 300
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shot():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Code so that enemy follows player
	if player.position.x > position.x :
		position.x += speed * delta
	if player.position.x < position.x :
		position.x -= speed * delta
	if player.position.y > position.y :
		position.y += speed * delta
	if player.position.y < position.y :
		position.y -= speed * delta
