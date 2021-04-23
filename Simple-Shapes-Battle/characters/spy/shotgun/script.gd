extends Sprite

var projectile_path = "res://characters/spy/shotgun/bullet/bullet.tscn"

var initial = -1
var final = 1

#	if state == states.TAKEN:
#		look_at(get_global_mouse_position())
#		if global_position > get_global_mouse_position():
#			flip_v = 1
#		else:
#			flip_v = 0

func shoot():
	for _i in range(3):
		$Tween.interpolate_property(self, 
			"offset", 
			Vector2(-10, 0), Vector2(),
			0.1, 
			Tween.TRANS_BACK,
			Tween.EASE_IN_OUT
		)
		$Tween.start()
		var bullet = load(projectile_path).instance()
		var pos = $point.global_position 
		var dir = Vector2(1, 0).rotated(scale.y * global_rotation) + Vector2(0, rand_range(0.1, -.1))
		bullet.start(pos, dir)
		bullet.by = globals.player_name
		get_tree().get_root().add_child(bullet)
	$Tween.interpolate_property(self, 
		"rotation_degrees", 
		330, 0, 
		1, 
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT
	)
	$Tween.start()
#func _on_area_body_entered(body):
#	call_deferred("reparent",body)
#
#func reparent(body):
#	if body is RigidBody2D:
#		scale = Vector2(1, 1)
#		var weapon = body.get_node("../head/weapon")
#		get_parent().remove_child(self)
#		weapon.add_child(self)
#		position = weapon.position
#		state = states.TAKEN
#		$area.queue_free()


#func _on_Timer_timeout():
#	if state == states.IDLE:
#		$Tween.interpolate_property(
#			self,
#			"scale",
#			Vector2(initial, 1),
#			Vector2(final, 1),
#			1,
#			Tween.TRANS_SINE,
#			Tween.EASE_IN_OUT
#		)
#		$Tween.start()
#		var temp = initial
#		initial = final
#		final = temp
		
#		$Tween.interpolate_property(self, "offset", Vector2(-10, 0), Vector2(), 0.1, Tween.TRANS_BACK,Tween.EASE_IN_OUT)
#		$Tween.start()
#		$Tween.interpolate_property(self, "rotation_degrees", -10, 0, 0.1, Tween.TRANS_BACK,Tween.EASE_IN_OUT)
#		$Tween.start()
#	
