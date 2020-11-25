extends Node2D

# port should be between 1025 - 655232
func _ready():
	
	var network = NetworkedMultiplayerENet.new()
	network.create_server(globals.SWORDSMASTERS_PORT, 4094) # 4094 max
	get_tree().set_network_peer(network)
	network.connect("peer_connected",self,"_peer_connected")
	network.connect("peer_disconnected",self,"_peer_disconnected")
	get_tree().multiplayer.connect("network_peer_packet",self,"_on_packet_received")
	print(IP.get_local_addresses()) 
#	$Label.text = str(IP.get_local_addresses())

func _on_packet_received(id,packet):
	var packet_data = parse_json(packet.get_string_from_ascii())
	
	match packet_data["reason"]:
		"create_room":
			create_room(id, packet_data["room_id"], packet_data["player_name"])
		"join_room":
			join_room(id, packet_data["room_id"], packet_data["player_name"])
		"initiate_mm":
			initiate_match_making_game(id, packet_data)
		"initiate_me":
			initiate_me_making_game(id, packet_data)
#			initiate_game(id, packet_data["room_id"])
		"attack":
			attack(id, packet_data)
			
		"hurt":
			hurt(id, packet_data)
		"update_p_pos":
			update_game(id, packet_data["room_id"], packet_data)

func hurt(id, packet_data):
	var packet = {}
	var room_id = packet_data["room_id"]
#	send_packet_ur(packet)
	packet["reason"] = "hurt_plyr"
	packet["room"] = room_id
	packet["anim"] = "hurt"
	
	var plyrs = globals.games[room_id].keys()
	if id == plyrs[0]:
		packet["id"] = plyrs[1]
#		packet["anim"] = globals.games[room_id][plyrs[1]]["anim"]
	else:
		packet["id"] = plyrs[0]
#		packet["anim"] = globals.games[room_id][plyrs[0]]["anim"]

	send_packet(packet)
	
func attack(id, packet_data):
	var packet = {}
	var room_id = packet_data["room_id"]
#	send_packet_ur(packet)
	packet["reason"] = "attack_plyr"
	packet["room"] = room_id
	packet["anim"] = packet_data["attack"]
	
	var plyrs = globals.games[room_id].keys()
	if id == plyrs[0]:
		packet["id"] = plyrs[1]
#		packet["anim"] = globals.games[room_id][plyrs[1]]["anim"]
	else:
		packet["id"] = plyrs[0]
#		packet["anim"] = globals.games[room_id][plyrs[0]]["anim"]

	send_packet(packet)

func initiate_match_making_game(id, _packet):
	globals.games[_packet["room"]][id]["name"] = _packet["name"]
	globals.games[_packet["room"]][id]["sword"] = _packet["sword"]
	if globals.games[_packet["room"]].size() == 2:
		var packet = {}
		packet["reason"] = "initiate"
		packet["room_id"] = _packet["room"]
		var plyrs = globals.games[_packet["room"]].keys()
		packet["player_1_id"] = str(plyrs[0])
		packet["player_2_id"] = str(plyrs[1])
		packet["player_1_name"] = globals.games[_packet["room"]][plyrs[0]]["name"]
		packet["player_2_name"] = globals.games[_packet["room"]][plyrs[1]]["name"]
		packet["player_1_sword"] = globals.games[_packet["room"]][plyrs[0]]["sword"]
		packet["player_2_sword"] = globals.games[_packet["room"]][plyrs[1]]["sword"]
		
		send_packet(packet)

func initiate_me_making_game(id, packet):
	globals.games[packet["room"]][id]["name"] = packet["name"]
	globals.games[packet["room"]][id]["sword"] = packet["sword"]


func update_game(id,room_id, packet_data):
	globals.games[room_id][id]["pos"] = packet_data["player_pos"]
	globals.games[room_id][id]["hp"] = packet_data["player_hp"]
	
	var packet = {}
	packet["reason"] = "update_pos"
	packet["room"] = room_id
	var plyrs = globals.games[room_id].keys()
	if id == plyrs[0]:
		packet["id"] = plyrs[1]
		packet["player_pos"] = globals.games[room_id][plyrs[1]]["pos"]
		packet["anim"] = globals.games[room_id][plyrs[1]]["anim"]
	else:
		packet["id"] = plyrs[0]
		packet["player_pos"] = globals.games[room_id][plyrs[0]]["pos"]
		packet["anim"] = globals.games[room_id][plyrs[0]]["anim"]
#	print(packet)
	packet["player_1_id"] = plyrs[0]
	packet["player_2_id"] = plyrs[1]
	packet["player_1_hp"] = globals.games[room_id][plyrs[0]]["hp"]
	packet["player_2_hp"] = globals.games[room_id][plyrs[1]]["hp"]
	send_packet_ur(packet)

func initiate_game(room_id):
	var packet = {}
	packet["reason"] = "initiate"
	packet["room_id"] = room_id
	packet["player_1_name"] = globals.rooms[room_id]["1"]["name"]
	packet["player_2_name"] = globals.rooms[room_id]["2"]["name"]
	print(packet)
	var error = get_tree().multiplayer.send_bytes(to_json(packet).to_ascii())
	if error == OK:
		print("game initiated")

func join_room(_id, room_id, p_name):
	var packet = {}
	
	if not room_id in globals.rooms:
		packet["reason"] = "warning"
		packet["message"] = "not_exist"
	else:
		packet["reason"] = "connection_status"
		packet["status"] = "join_successful"
		packet["room_id"] = room_id
		packet["player_name"] = p_name
		
		globals.rooms[room_id]["2"]["id"] = _id
		globals.rooms[room_id]["2"]["name"] = p_name

	send_packet(packet)
	initiate_game(room_id)

func create_room(_id, room_id, p_name):
	var packet = {}

	if room_id in globals.rooms:
		packet["reason"] = "warning"
		packet["message"] = "occupied"
	else:	
		globals.rooms[room_id] = {}
	#	print("Room with id: " + room_id + " created!")
		packet["reason"] = "connection_status"
		packet["status"] = "create_successful"
		packet["room_id"] = room_id
		packet["player_name"] = p_name
		
		globals.rooms[room_id]["1"] = {}
		globals.rooms[room_id]["1"]["id"] = _id
		globals.rooms[room_id]["1"]["name"] = p_name
		globals.rooms[room_id]["1"]["pos"] = "(0, 0)"
		
		globals.rooms[room_id]["2"] = {}
		globals.rooms[room_id]["2"]["id"] = ""
		globals.rooms[room_id]["2"]["name"] = ""
		globals.rooms[room_id]["2"]["pos"] = "(0, 0)"
		
		send_packet(packet)
#	var data
#	get_tree().multiplayer.send_bytes(data, id, NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE)

func _peer_connected(id):
	globals.connected_players[id] = {}
	var _room
	var packet = {}
	packet["reason"] = "matchmaking"
	if globals.connected_players.size() % 2 == 0:
		_room = join_mm_room(id)
		packet["role"] = "join"
	else:
		_room = create_mm_room(id)
		packet["role"] = "create"
	packet["id"] = id
	packet["room"] = _room
	# print("ID: " + str(id) + " Room: " +str(_room))
	send_packet(packet)
	
func _peer_disconnected(id):
	globals.connected_players.erase(id)
	
func send_packet(packet):
	var error = get_tree().multiplayer.send_bytes(to_json(packet).to_ascii())
	if error != OK:
		print(packet["reason"] + " packet sent!")

func send_packet_ur(packet):
	var error = get_tree().multiplayer.send_bytes(to_json(packet).to_ascii(), 0, NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE)
	if error != OK:
		#print(packet["reason"] + " packet sent!")
		return false
	return true


func join_mm_room(id):
	var _room = globals.rooms[0]
	initiate_in_room(id, _room)
	globals.booked_rooms.append(_room)
	globals.rooms.erase(_room)
	return _room

func create_mm_room(id):
	var _room = ""
	while _room == "" or _room in globals.rooms:
		 _room = str(randi())
	globals.rooms.append(_room)
	globals.games[_room] = {}
	initiate_in_room(id, _room)
	return _room

func initiate_in_room(id, _room):
	globals.games[_room][id] = {}
	globals.games[_room][id]["name"] = ""
	globals.games[_room][id]["pos"] = "(0, 0)"
	globals.games[_room][id]["sword"] = ""
	globals.games[_room][id]["anim"] = ""
	globals.games[_room][id]["hp"] = 100
