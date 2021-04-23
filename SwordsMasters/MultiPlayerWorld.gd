extends Node2D

export (PackedScene) var my_player
export (PackedScene) var other_player

var packet
var error

func _ready():
	error = get_tree().multiplayer.connect("network_peer_packet",self,"_on_packet_received")
	if error != OK:
		get_tree().change_scene("res://MultiPlayer.tscn")
	
#	packet = {}
#	packet["reason"] = "initiate"
#	packet["room_id"] = globals.room_id
#	error = get_tree().multiplayer.send_bytes(to_json(packet).to_ascii())
#	if error != OK:
#		print_stack()
	

func _on_packet_received(_id, _packet):
	var packet_data = parse_json(_packet.get_string_from_ascii())
	print(packet_data)
	match packet_data["reason"]:
		"initiate":
			if packet_data["room_id"] != globals.room_id:
				return
				
			$Player1.set_name( packet_data["player_1_name"])
			$Player2.set_name( packet_data["player_2_name"])
			
			if packet_data["player_1_name"] == globals.player_name:
				my_player = $Player1
				other_player = $Player2
				$UpdatePosTimer.start()
			elif packet_data["player_2_name"] == globals.player_name:
				my_player = $Player2
				other_player = $Player1
				$UpdatePosTimer.start()
			other_player.set_script(null)
			print(my_player.name)
			print(other_player.name)
		"update_pos":
			other_player.global_position = str2var("Vector2" + packet_data["player_pos"])
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_UpdatePosTimer_timeout():
	packet = {}
	packet["reason"] = "update_pos"
	packet["room_id"] = globals.room_id
	packet["player_name"] = globals.player_name
	packet["player_pos"] = str(my_player.global_position)
	error = get_tree().multiplayer.send_bytes(to_json(packet).to_ascii())
	if error != OK:
		print_stack()
