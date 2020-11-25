extends KinematicBody2D

var linear_vel = Vector2()
const GRAVITY_VEC = Vector2(0, 900)
var game_start = false
export var jump_height = 250
export (PackedScene) var bullet

signal game_start
signal game_over

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#pass # Replace with function body.

func get_powerup(powerup_name, quantity):
	if powerup_name == "bullet":
		get_parent().bullet_count += quantity

func shoot():
	bullet = preload("res://scenes/Bullet.tscn").instance()
	bullet.position = $GunPoint.global_position 
	get_parent().add_child(bullet)
	bullet.add_collision_exception_with(self)
	get_parent().bullet_count -= 1

# func new_game():
	# global_position = Vector2(160, 300)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_up") : 
		# print("Hello")
		# position += jump_height # * delta
		game_start = true
		$Particles2D.emitting = true
		emit_signal("game_start")
		linear_vel.y = - jump_height
		$boink.play()
		
		#spawn bullet
	if Input.is_action_just_pressed("ui_accept") and get_parent().bullet_count >= 1:	
		shoot()
		
	if game_start :
		linear_vel += delta * GRAVITY_VEC
		linear_vel = move_and_slide(linear_vel, Vector2(0, -1), 25.0)


func _on_visibility_screen_exited():
	emit_signal("game_over")
