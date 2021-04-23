extends Node
#onready var single_player = "res://characters/"+globals.curr_shape+"/"+globals.curr_hero+"/Player.tscn"
#onready var single_player = "res://characters/bean/Base.tscn"
#onready var single_player = "res://characters/agent/AgentBean.tscn"
#onready var multi_player = "res://characters/"+globals.curr_shape+"/"+globals.curr_hero+"/Player.tscn"
var winner_name = ""

func _ready():
	if globals.curr_hero != "" and globals.mode == "singleplayer" :
		var player = load("res://characters/"+globals.curr_hero+"/Player.tscn").instance()
		player.get_node("body/head/camera").current = true
#		player.set_script(null)
#		player.set_script(load("res://characters/base/singleplayer.gd"))
		$players.add_child(player)

func _process(_delta):
	if globals.mode != "singleplayer":
		if $players.get_child_count() == 1 and winner_name == "":
			winner_name = $players.get_child(0).get_node("body/head/labels/name_label").text
			$GameOver/WinnerLabel.text = "Winner is: "+winner_name
			$GameOver.visible = true
