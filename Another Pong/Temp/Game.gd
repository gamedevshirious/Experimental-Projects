extends Node2D

const ball_scene = preload("res://Scenes/Ball.tscn")

export var P1_score = 0
export var P2_score = 0

var p1_up = false
var p2_up = false
var p1_down = false
var p2_down = false

func create_ball() :
	var ball = ball_scene.instance()
	ball.set("position", $GUI/Misc/Position2D.position)
	$Interactables.add_child(ball)
	
func _ready():
	create_ball()
	
func _process(delta):
	if p1_up == true :
		$Interactables/P1.call("move", "up")
	if p2_up == true :
		$Interactables/P2.call("move", "up")
	if p1_down == true :
		$Interactables/P1.call("move", "down")
	if p2_down == true :
		$Interactables/P2.call("move", "down")
		
	# $GUI/GUI_Layer/Score/P1.text = str(P1_score)
	# $GUI/GUI_Layer/Score/P2.text = str(P2_score)

func on_Player_out(name) :
	if name == "P1" :
		P2_score += 1
	if name == "P2" :
		P1_score += 1
	$Interactables/P1.set("bat_speed", Vector2(0, 2))
	$Interactables/P2.set("bat_speed", Vector2(0, 2))
	create_ball()
	
func _on_P1_UP_button_down():
	p1_up = true

func _on_P1_DOWN_button_down():
	p1_down = true
	
func _on_P2_UP_button_down():
	p2_up = true

func _on_P2_DOWN_button_down():
	p2_down = true

func _on_P1_UP_button_up():
	p1_up = false

func _on_P2_UP_button_up():
	p2_up = false

func _on_P2_DOWN_button_up():
	p2_down = false

func _on_P1_DOWN_button_up():
	p1_down = false
