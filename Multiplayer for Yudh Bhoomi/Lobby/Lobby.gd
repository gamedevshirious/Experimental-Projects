extends Control

var self_data = {
	name="", 
	hero = "",
	pos=Vector2(),
	anim = ""
}

func _ready():
	self_data.name = $NameTextBox.text
	self_data.hero = $OptionButton.text

func _load_game():
	get_tree().change_scene("res://World.tscn")


func _on_NameTextBox_text_entered(new_text):
	self_data.name = new_text


func _on_OptionButton_item_selected(id):
	self_data.hero = $OptionButton.text


func _on_CreateGameButton_pressed():
	if self_data.name == "":
		return
	Network.host_server(self_data)
	_load_game()


func _on_JoinGameButton_pressed():
	if self_data.name == "":
		return
	Network.join_server(self_data)
	_load_game()
