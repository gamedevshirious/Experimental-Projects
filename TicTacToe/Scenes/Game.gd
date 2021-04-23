extends Node2D

var plyr_1_name = ""
var plyr_2_name = ""
var players = []
var turn = 0
var curr    # current player
var later   # other player
var temp    # temp player for swap 

var plyr_1_score = 0
var plyr_2_score = 0

var curr_arr = []
var curr_tex

var plyr_1_array = []
var plyr_2_array = []

var winning_seq = [[1,2,3], [4,5,6], [7,8,9],
				   [1,3,7], [2,5,8], [3,6,9],
				   [1,5,9], [3,5,7]]

onready var osprite = preload("res://Sprites/o.png")
onready var xsprite = preload("res://Sprites/x.png")
onready var blank = preload("res://Sprites/blank.png")

func check_win(arr):
	for k in winning_seq:
		if k[0] in arr and k[1] in arr and k[2] in arr :
			return true
	return false 

func _ready():
	$UI/PanelContainer.visible = true
	$UI/PanelContainer/Panel/Play.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func next(v):
	if curr == plyr_1_name :
		plyr_1_array.append(v)
	else :
		plyr_2_array.append(v)
	# check_win(plyr_1_array)
	# check_win(plyr_2_array)
	turn += 1
	if check_win(curr_arr):
		$UI/PlayAgain/ResultLabel.text = curr + " wins !!!"
		if curr == plyr_1_name :
			plyr_1_score += 1
		else :
			plyr_2_score += 1
		$objects/Score_Label.text = plyr_1_name + " : " + str(plyr_1_score) + "\n" + plyr_2_name + " : " + str(plyr_2_score)
		$UI/PlayAgain.show()
	elif turn == 9:
		$UI/PlayAgain/ResultLabel.text  = "Match's Draw"
		$UI/PlayAgain.show()
	
	temp = curr
	curr = later
	later = temp
	
	if curr == plyr_1_name :
		curr_tex = osprite
		curr_arr = plyr_1_array
	else :
		curr_tex = xsprite
		curr_arr = plyr_2_array
	$objects/Turn_Label.text = curr + "'s Turn"
	

func _on_Button_pressed():
	$UI/PanelContainer.visible = false
	new_game()
	# $UI/9Buttons/Button. = xsprite

func _on_Toss_pressed():
	plyr_1_name = $UI/PanelContainer/Panel/player1/name.text
	plyr_2_name = $UI/PanelContainer/Panel/player2/name.text
	
	$objects/Score_Label.text = plyr_1_name + " : " + str(plyr_1_score) + "\n" + plyr_2_name + " : " + str(plyr_2_score)
	
	$UI/PanelContainer/Panel/Toss.disabled = true
	
	if $UI/PanelContainer/Panel/player1/name.text != "" and $UI/PanelContainer/Panel/player2/name.text != "": 
		players.append(plyr_1_name)
		players.append(plyr_2_name)
		curr = players[randi() % 2]
		
		if curr == plyr_1_name :
			curr_tex = osprite
		else :
			curr_tex = xsprite
		$UI/PanelContainer/Panel/Toss.text = curr + " plays first"
		$UI/PanelContainer/Panel/Play.visible = true
		players.remove(players.find(curr))
		later = players[0]
		
		$objects/Turn_Label.text = curr + "'s Turn"
	else:
		$UI/NameAlert.show()

#func _on_1_pressed():
#	$UI/Buttons_9/btn_1.icon curr_tex
	


func _on_btn_1_pressed():
	$objects/Board/Buttons/btn_1.texture_normal = curr_tex
	$objects/Board/Buttons/btn_1.texture_disabled = curr_tex
	$objects/Board/Buttons/btn_1.disabled = true
	next(1)



func _on_btn_2_pressed():
	$objects/Board/Buttons/btn_2.texture_normal = curr_tex
	$objects/Board/Buttons/btn_2.texture_disabled = curr_tex
	$objects/Board/Buttons/btn_2.disabled = true
	next(2)

func _on_btn_3_pressed():
	$objects/Board/Buttons/btn_3.texture_normal = curr_tex
	$objects/Board/Buttons/btn_3.texture_disabled = curr_tex
	$objects/Board/Buttons/btn_3.disabled = true
	next(3)

func _on_btn_4_pressed():
	$objects/Board/Buttons/btn_4.texture_normal = curr_tex
	$objects/Board/Buttons/btn_4.texture_disabled = curr_tex
	$objects/Board/Buttons/btn_4.disabled = true
	next(4)

func _on_btn_5_pressed():
	$objects/Board/Buttons/btn_5.texture_normal = curr_tex
	$objects/Board/Buttons/btn_5.texture_disabled = curr_tex
	$objects/Board/Buttons/btn_5.disabled = true
	next(5)

func _on_btn_6_pressed():
	$objects/Board/Buttons/btn_6.texture_normal =  curr_tex
	$objects/Board/Buttons/btn_6.texture_disabled = curr_tex
	$objects/Board/Buttons/btn_6.disabled = true
	next(6)

func _on_btn_7_pressed():
	$objects/Board/Buttons/btn_7.texture_normal = curr_tex
	$objects/Board/Buttons/btn_7.texture_disabled = curr_tex
	$objects/Board/Buttons/btn_7.disabled = true
	next(7)

func _on_btn_8_pressed():
	$objects/Board/Buttons/btn_8.texture_normal  = curr_tex
	$objects/Board/Buttons/btn_8.texture_disabled = curr_tex
	$objects/Board/Buttons/btn_8.disabled = true
	next(8)

func _on_btn_9_pressed():
	$objects/Board/Buttons/btn_9.texture_normal = curr_tex
	$objects/Board/Buttons/btn_9.texture_disabled = curr_tex
	$objects/Board/Buttons/btn_9.disabled = true
	next(9)

func new_game():
	$UI/PlayAgain.hide()
	turn = 0
	plyr_1_array = []
	plyr_2_array = []
	for btn in get_node("objects/Board/Buttons").get_children():
		btn.texture_normal = blank
		btn.texture_disabled = blank
		btn.disabled = false

func _on_Again_pressed():
	new_game()


func _on_Exit_pressed():
	get_tree().quit()
