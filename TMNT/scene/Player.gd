extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var WALK_SPEED = 300
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$"air collision box".disabled = true
	$"land collision box".disabled = false
	$AnimatedSprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	control(delta)
#	pass

func control(delta) :
	velocity = Vector2()
	
	if Input.is_action_pressed("ui_up") and position.y > 400:
		velocity.y -= 1
	if Input.is_action_pressed("ui_down") and position.y < 500 :
		velocity.y += 1 
	if Input.is_action_pressed("ui_left") :
		velocity.x -= 1
		$AnimatedSprite.scale.x = -1
	if Input.is_action_pressed("ui_right") :
		velocity.x += 1 
		$AnimatedSprite.scale.x = 1
		
	if Input.is_action_just_pressed("ui_accept"):
		$"air collision box".disabled = false
		$"land collision box".disabled = true
		$AnimatedSprite.play("jump")
		
	if $AnimatedSprite.animation == "jump" && $AnimatedSprite.frame == ($AnimatedSprite.frames.get_frame_count("jump") - 1):
		$"air collision box".disabled = true
		$"land collision box".disabled = false
		$AnimatedSprite.play("idle")
	#$AnimatedSprite.play("idle")
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * WALK_SPEED
	
	position += velocity * delta

func _on_AnimatedSprite_animation_finished():
	pass
	# AnimatedSprite
	