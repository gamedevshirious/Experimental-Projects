extends Sprite

var projectile_path = "res://characters/spy/pistol/bullet/bullet.tscn"

var initial = -1
var final = 1

#	if state == states.TAKEN:
#		look_at(get_global_mouse_position())
#		if global_position > get_global_mouse_position():
#			flip_v = 1
#		else:
#			flip_v = 0

func shoot():
	var bullet = load(projectile_path).instance()
	var pos = $point.global_position #+ Vector2(randf(), rand_range(5, -5))
	var dir = Vector2(1, 0).rotated(scale.x * global_rotation) #+ Vector2(0, rand_range(0, -.05))
	bullet.start(pos, dir)
	bullet.by = globals.player_name
	$boom.emitting = true
	$Tween.interpolate_property(self, "offset", Vector2(-2, -2), Vector2(), 0.1, Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$Tween.start()
	$Tween.interpolate_property(self, "rotation_degrees", -5, 0, 0.1, Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$Tween.start()
	get_tree().get_root().add_child(bullet)
#
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
		
