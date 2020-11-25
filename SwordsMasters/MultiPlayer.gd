extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.

func _ready():
	# connect_to_swordsmaster_server()
	var network = NetworkedMultiplayerENet.new()
	network.create_client(globals.SWORDSMASTERS_SERVER_IP, globals.SWORDSMASTERS_PORT)
	get_tree().set_network_peer(network)
	network.connect("connection_failed",self,"_on_connection_failed")
	var error = get_tree().multiplayer.connect("network_peer_packet",self,"_on_packet_received")
	if error != OK:
		$AcceptDialog.show()
		
	


func _on_connection_failed():
	$CreateRoom.text = "Error Server not found"

func _on_packet_received(_id, packet):
	var packet_data = parse_json(packet.get_string_from_ascii())
	# print(packet_data)
	match packet_data["reason"]:
		"connection_status":
			match packet_data["status"]:
				"create_successful":
					$CreateRoom.text = "Room no. " +$RoomIDTextBox.text+" created successfully"
					globals.mode = "multiplayer"
					globals.room_id = packet_data["room_id"]
					globals.player_name = packet_data["player_name"]
					get_tree().change_scene("res://MultiPlayerWorld.tscn")
				"join_successful":
					$JoinRoom.text = "Room no. " +$RoomIDTextBox.text+" joined successfully"
					globals.mode = "multiplayer"
					globals.room_id = packet_data["room_id"]
					globals.player_name = packet_data["player_name"]
					get_tree().change_scene("res://MultiPlayerWorld.tscn")
		"warning":
			match packet_data["message"]:
				"occupied":
					$RoomIDTextBox.clear()
					$CreateRoom.text = "Room no. " +$RoomIDTextBox.text+" occupied already. Create another!"
				"not_exist":
					$RoomIDTextBox.clear()
					$JoinRoom.text = "Room no. " +$RoomIDTextBox.text+" does not exist. Create one!"
					$CreateRoom.disabled = false
	# print(globals.mode)
				#get_tree().change_scene("res://World.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CreateRoom_pressed():
	if $RoomIDTextBox.text == "" or " " in $RoomIDTextBox.text:
		return
	
	if $NameTextBox.text == ""  or " " in $NameTextBox.text:
		return

#	connect_ip()
	$CreateRoom.text = "Connecting ..."
	$JoinRoom.disabled = true
	var packet = {
		reason = "create_room",
	}

	packet.room_id = $RoomIDTextBox.text
	packet.player_name = $NameTextBox.text
	var error = get_tree().multiplayer.send_bytes(to_json(packet).to_ascii())
	if error != OK:
		$AcceptDialog.show()

func _on_AcceptDialog_confirmed():
	get_tree().change_scene("res://MainMenu.tscn")

func _on_JoinRoom_pressed():
	if $RoomIDTextBox.text == "" or " " in $RoomIDTextBox.text :
		return
	
	if $NameTextBox.text == ""  or " " in $NameTextBox.text:
		return
#	if $ServerIPTextBox.text == "" or !$ServerIPTextBox.text.is_valid_ip_address():
#		return
	
#	connect_ip()
	$CreateRoom.disabled = true
	$JoinRoom.text = "Connecting ..."
	
	var packet = {
		reason = "join_room",
	}
	
	packet.room_id = $RoomIDTextBox.text
	packet.player_name = $NameTextBox.text
	var error = get_tree().multiplayer.send_bytes(to_json(packet).to_ascii())
	if error != OK:
#		OS.alert("Connection Failed", "Alert!")
		$AcceptDialog.show()

func _on_AcceptDialog_popup_hide():
	$CreateRoom.text = "Create Room"
	$JoinRoom.text = "Join Room"
	$CreateRoom.disabled = false
	$JoinRoom.disabled = false
	
