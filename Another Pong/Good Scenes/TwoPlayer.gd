extends Node

var p1_up = false
var p2_up = false
var p1_down = false
var p2_down = false

func _ready():
	pass

func _process(delta):
	if p1_down == true :
		$Interactables/P1.call("move", "down")
	
	if p2_down == true :
		$Interactables/P2.call("move", "down")

	if p1_up == true :
		$Interactables/P1.call("move", "up")
	
	if p2_up == true :
		$Interactables/P2.call("move", "up")
	
func _on_P1_Down_button_up():
	p1_down = false
	print(p1_up)

func _on_P1_Down_button_down():	
	p1_down = true
	
func _on_P2_Down_button_up():
	p2_down = false
	
func _on_P2_Down_button_down():
	p2_down = true

func _on_P1_Up_button_down():
	print(p1_up)
	p1_up = true

func _on_P1_Up_button_up():
	p1_up = false

func _on_P2_Up_button_down():
	p2_up = true

func _on_P2_Up_button_up():
	p2_up = false
