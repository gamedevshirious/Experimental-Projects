extends Node2D

var anim = "not turn"


func _ready():
	$Board_image/Rects/Rectangle1/AnimatedSprite.play(anim)
	$Board_image/Rects/Rectangle2/AnimatedSprite.play(anim)
	$Board_image/Rects/Rectangle3/AnimatedSprite.play(anim)
	$Board_image/Rects/Rectangle4/AnimatedSprite.play(anim)
	pass


func _on_Button_pressed():
	if anim == "not turn" :
		anim = "turn"
	else :
		anim = "not turn"
		
	$Board_image/Rects/Rectangle1/AnimatedSprite.play(anim)
	$Board_image/Rects/Rectangle2/AnimatedSprite.play(anim)
	$Board_image/Rects/Rectangle3/AnimatedSprite.play(anim)
	$Board_image/Rects/Rectangle4/AnimatedSprite.play(anim)
	