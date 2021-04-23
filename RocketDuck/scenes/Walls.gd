extends Node2D

signal game_over
signal score
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init(speed, distance):
	distance += 300
	$upwall.speed = speed
	$downwall.speed = speed
	$downwall.position = Vector2 (0, distance)
	$upwall.position = Vector2(0, -distance)

func _on_upwall_game_over():
	emit_signal("game_over")

func _on_downwall_game_over():
	emit_signal("game_over")

#func _on_downwall_score():
#	emit_signal("score")




# func _on_upwall_score():
# 	emit_signal("score")

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("score")
	$downwall.queue_free()
