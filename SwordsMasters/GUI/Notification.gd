extends Node2D

func pop_in():
	print("tween started 1")
	$Tween.interpolate_property(
		$ColorRect,
		"rect/position",
		Vector2(200, -75),
		Vector2(200, 0),
		0.5,
		Tween.TRANS_SINE,
		Tween.EASE_IN
	)
	
	$Tween.start()
	$Timer.start()
	print("tween started")


func _on_Timer_timeout():
	$Tween.interpolate_property(
		$ColorRect,
		"rect/position",
		Vector2(200, 0),
		Vector2(200, -75),
		0.1,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	
	$Tween.start()

func _process(delta):
	print("H")
	if Input.is_action_just_pressed("ui_down"):
		pop_in()
