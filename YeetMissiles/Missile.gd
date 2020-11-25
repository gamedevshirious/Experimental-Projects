extends Area2D

var difficulty = 1
var base_speed = 1
var speed
var fuel_over = false
var velocity = Vector2()
var player
export (PackedScene) var coins
# Declare member variables here. Examples:
# var a = 2

func _ready():
	player = get_parent().get_node("World/Plane")

func init(dif):
	difficulty = dif

func move(_delta):
	look_at(player.global_position)
	speed = base_speed * global_position.distance_to(player.global_position)

	if player.position.x > position.x:
		position.x += difficulty * speed * _delta/2
	if player.position.x < position.x:
		position.x -= difficulty * speed * _delta/2
	if player.position.y > position.y:
		position.y += difficulty * speed * _delta/2
	if player.position.y < position.y:
		position.y -= difficulty * speed * _delta/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	# position += velocity * delta
	die(delta)
		

func _on_Missile_area_entered(area):
	#if area.has_method("is_plane"):

	if area.name != "Coins":
		fuel_over = true
			
func die(_delta):
	if fuel_over:
		scale -= Vector2(1, 1) * _delta
		if scale.x <= 0:
			queue_free()
		
			coins = preload("res://Coins.tscn").instance()
			coins.position = global_position
			get_tree().get_root().add_child(coins)


func _on_Timer_timeout():
	fuel_over = true
	#base_speed += .1

