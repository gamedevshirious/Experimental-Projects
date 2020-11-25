extends Node2D

var save_game

func _ready():
#	save_game = File.new()
	load_data()
#	save_game.close()

func _on_SinglePlayerButton_pressed():
	globals.mode = "local"
	get_tree().change_scene("res://World.tscn")

func _on_MultiPlayerButton_pressed():
	globals.player_name = $NameTextBox.text
	#globals.sword = $OptionButton.text
	
	globals.same_sword = $CheckButton.pressed
	get_tree().change_scene("res://Matchmaking.tscn")
#	get_tree().change_scene("res://MultiPlayer.tscn")

func _on_NameTextBox_text_changed(new_text):
	save_data()

func _on_CheckButton_toggled(button_pressed):
	save_data()

func _on_OptionButton_item_selected(id):
	save_data()

func _on_OptionButton_item_focused(id):
	save_data()

func save_data(item_id = 0):
	save_game = File.new()
	if $NameTextBox.text == "":
		return
	save_game.open(globals.SAVFILE, File.WRITE)
	var data = {}
	data["name"] = $NameTextBox.text
#	data["sword"] = $OptionButton.text
	data["sword"] = $Weaponry.get_item_text(item_id)
	data["sword_index"] = str(item_id)
	
	data["same_opp"] = $CheckButton.pressed
	save_game.store_line(to_json(data))
	save_game.close()

func load_data():
	save_game = File.new()
	if not save_game.file_exists(globals.SAVFILE):
		save_data()
	save_game.open(globals.SAVFILE, File.READ)
	var load_data =  parse_json(save_game.get_line())
	save_game.close()
	$NameTextBox.text = load_data["name"]
	$Weaponry.select(int(load_data["sword_index"]))
	_on_ItemList_item_selected(int(load_data["sword_index"]))
	var sword_name = $Weaponry.get_item_text(int(load_data["sword_index"]))
	$SwordDescription.text = globals.swords[sword_name]["info"]
#	$OptionButton.text = load_data["sword"]
	$CheckButton.pressed = load_data["same_opp"]


func _on_ItemList_item_selected(index):
	save_data(index)
	var sword_name = $Weaponry.get_item_text(index)
	globals.sword = sword_name
	$SwordDescription.text = globals.swords[sword_name]["info"]
