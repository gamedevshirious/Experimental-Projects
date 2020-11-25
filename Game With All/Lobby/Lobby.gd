extends Control

func _ready():
	$VBoxContainer/CenterContainer/GridContainer/NameTextbox.text = Saved.save_data["player_name"]
func _on_Host_pressed():
	Network.create_server()
	create_waiting_room()

func _on_Join_pressed():
	Network.connect_to_server()
	create_waiting_room()

func _on_NameTextbox_text_changed(new_text):
	Saved.save_data["player_name"] = new_text
	Saved.save_game()

func create_waiting_room():
	$WaitingRoom.popup_centered()
	$WaitingRoom.refresh_players(Network.players)
