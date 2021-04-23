extends RigidBody2D

export (bool) var out = false
var last_coll = "hey" 

func _ready():
	randomize()
	var init_speed = rand_range(-3, 3) * 100
	while init_speed <= 50 and init_speed >= -50 :
		init_speed = rand_range(-3, 3) * 100
	linear_velocity = Vector2(init_speed, -init_speed)

func reset(pl = "none"):
	if pl != "none" : get_parent().get_parent().call("on_Player_out", pl)
	queue_free()
	

func _on_Ball_body_exited(body):
	print(body.name)
	"""
	angular_velocity = 0
	if body.name == "P1_out" :
		reset("P1")
	elif body.name == "P2_out" :
		reset("P2")
	elif body.name in ["P1", "P2"] :
		linear_velocity *= Vector2(1.1, 1.1)
		var bs = body.get("bat_speed")
		body.set("bat_speed", bs + Vector2(0, 1))
		linear_velocity.normalized()
	"""