extends Node2D

export (PackedScene) var my_player
export (PackedScene) var other_player

var game_started = false
var my_id
	
func _ready():
	$Player1.set_physics_process(false)
	$Player2.set_physics_process(false)
	
	$Player1.hide()
	$Player2.hide()
	# connect_to_swordsmaster_server()
	var network = NetworkedMultiplayerENet.new()
	network.create_client(globals.SWORDSMASTERS_SERVER_IP, globals.SWORDSMASTERS_PORT)
	get_tree().set_network_peer(network)
	network.connect("connection_failed",self,"_on_connection_failed")
	var error = get_tree().multiplayer.connect("network_peer_packet",self,"_on_packet_received")
	
	$Player1.init_player(globals.player_name, globals.sword)
	$HUD/Player1/Name.text = globals.player_name + "\n" + globals.sword
	
	if error != OK:
		print("Hi")
	
	my_id = get_tree().get_network_unique_id()
#		$AcceptDialog.show()
	
#	if error != OK:
#		$AcceptDialog.show()
		# print("Hwllo")
#		get_tree().change_scene("res://MainMenu.tscn")

func _on_connection_failed():
	$AcceptDialog.visible = true

func me_damage():
	my_player.state_machine.travel("hurt")

func send_packet_ur(packet):
	var error = get_tree().multiplayer.send_bytes(to_json(packet).to_ascii(), 0, NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE)
	if error != OK:
		#print(packet["reason"] + " packet sent!")
		return false
	return true

func local_initiate(player, packet_data):
	get_node("Player" + player).init_player( packet_data["player_"+player+"_name"], packet_data["player_"+player+"_sword"])
	get_node("HUD/Player"+player+"/Name").text = packet_data["player_"+player+"_name"] + "\n" + packet_data["player_"+player+"_sword"]
	get_node("HUD/Player"+player+"/HP").value = get_node("Player" + player).hp
#	get_node("Player" + player).name = str(packet_data["player_"+player+"_id"])
	get_node("Player" + player).show()
	get_node("Player" + player).set_process(true)
	
func _on_packet_received(_id, _packet):
	var packet_data = parse_json(_packet.get_string_from_ascii())

	match packet_data["reason"]:
		"initiate":
			# print(get_tree().get_network_unique_id())
			# $Player2.init_player( packet_data["player_2_name"], packet_data["player_2_sword"])
			if packet_data["player_1_id"] == str(my_id):
				my_player = $Player1
				other_player = $Player2
			else:
				my_player = $Player2
				other_player = $Player1
			$UpdatePosTimer.start()
			other_player.set_script(load("res://mm_dummy.gd"))
			#other_player.set_script(null)
			
			local_initiate("1", packet_data)
			local_initiate("2", packet_data)
			
			
			game_started = true
			#print(my_player.name)
			#print(other_player.name)
			#print(globals.player_name + ": " +str(_id))
		"attack_plyr":
		#	print(packet_data)
			if packet_data["id"] == my_id and packet_data["room"] == globals.room_id:
				var anim = packet_data["anim"]
		#		print(anim)
				#if anim == null:
				#	return
				other_player.state_machine.travel(anim)
	
		"update_pos":
#			print(str(packet["room"]) + "|" + str(globals.room_id))
			if packet_data["id"] != my_id and packet_data["room"] == globals.room_id:
				# print("moving other player")
				other_player.global_position = str2var("Vector2" + packet_data["player_pos"])
			#	other_player.hp = packet_data["player_hp"]
				other_player.state_machine.travel(packet_data["anim"])
		#		other_player.get_node("AnimationPlayer").current_animation = packet_data["anim"]
			if packet_data["player_1_id"] == my_id:
				$Player1.hp = packet_data["player_1_hp"]
				$Player2.hp = packet_data["player_2_hp"]
			else:
				$Player2.hp = packet_data["player_1_hp"]
				$Player1.hp = packet_data["player_2_hp"]
			$HUD/Player1/HP.value = my_player.hp
			$HUD/Player2/HP.value = other_player.hp

		"matchmaking":
			var packet = {}
			if str(packet_data["id"]) ==  str(get_tree().get_network_unique_id()):
				globals.room_id = packet_data["room"]
				packet["room"] = globals.room_id
				packet["name"] = globals.player_name
				packet["sword"] = globals.sword
				packet["same"] = globals.same_sword
				if packet_data["role"] == "join":
					packet["reason"] = "initiate_mm"
					# print(globals.player_name + " sent initiate mm")
					$AcceptDialog.visible = not globals.send_packet(packet)
				else:				
					packet["reason"] = "initiate_me"
					$AcceptDialog.visible = not globals.send_packet(packet)
			

func _on_UpdatePosTimer_timeout():
	var packet = {}
	packet["reason"] = "update_p_pos"
	packet["room_id"] = globals.room_id
	packet["player_pos"] = str(my_player.global_position)
	packet["player_hp"] = my_player.hp
#	
#	packet["anim"] = my_player.get_node("AnimationPlayer").current_animation
	$AcceptDialog.visible = not send_packet_ur(packet)
			

func _on_AcceptDialog_confirmed():
	get_tree().change_scene("res://MainMenu.tscn")
	
