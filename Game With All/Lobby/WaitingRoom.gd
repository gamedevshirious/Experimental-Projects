extends Popup

onready var playerlist = $VBoxContainer/CenterContainer/ItemList

func _ready():
	playerlist.clear()
	
func refresh_players(players):
	playerlist.clear()
	for player_id in players:
		var player = players[player_id]["player_name"]
		playerlist.add_item(player, null, false)
