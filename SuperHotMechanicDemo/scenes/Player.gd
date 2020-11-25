extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var bullet

var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Turret
	$turret.look_at(get_global_mouse_position())
	
	# Shoot
	if Input.is_action_just_pressed("ui_accept"):
		bullet = preload("res://scenes/Bullet.tscn").instance()
		var pos = $turret/point.global_position
		var dir = Vector2(1, 0).rotated($turret.global_rotation)
		bullet.start(pos, dir)
		get_parent().add_child(bullet)
	
	# Movement
	if Input.is_action_pressed("ui_left"):
		position.x -= speed * delta
		get_parent().get_tree().paused = false
	if Input.is_action_pressed("ui_right"):
		position.x += speed * delta
		get_parent().get_tree().paused = false
	if Input.is_action_pressed("ui_up"):
		position.y -= speed * delta
		get_parent().get_tree().paused = false
	if Input.is_action_pressed("ui_down"):
		position.y += speed * delta
		get_parent().get_tree().paused = false
		
#	pass
