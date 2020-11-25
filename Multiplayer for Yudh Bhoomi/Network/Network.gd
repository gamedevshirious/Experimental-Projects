extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 1212
const MAX_PLAYERS = 5

var players = {}
var self_data = {
	id = "",
	name="", 
	hero = "",
	pos=Vector2(),
	anim = ""
}

signal _player_connected
signal _player_disconnected

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
func host_server(data):
	players[1] = data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	print("Network created")
	
func join_server(data):
	self_data = data
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func _connected_to_server():
	players[get_tree().get_network_unique_id()] = self_data
	rpc("_send_player_info", get_tree().get_network_unique_id(), self_data)

func _player_connected(id):
	print("Player connected" + str(id))
	if not(get_tree().is_network_server()):
		rpc_id(1, '_request_player_info', get_tree().get_network_unique_id(), id)


func _player_disconnected(id):
	print("Player disconnected" + str(id))
	players.erase(id)


remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])

# A function to be used if needed. The purpose is to request all players in the current session.
remote func _request_players(request_from_id):
	if get_tree().is_network_server():
		for peer_id in players:
			if( peer_id != request_from_id):
				rpc_id(request_from_id, '_send_player_info', peer_id, players[peer_id])


remote func _send_player_info(id, info):
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id,"_send_player_info", peer_id, players[peer_id])
	players[id] = info
	
#	var new_player = load("res://Champions/"+info.hero+"/"+info.hero+".tscn")
	var new_player = load("res://Champions/Kindler/Kindler.tscn").instance()
	new_player.data.id = str(id)
	new_player.name = str(get_tree().get_network_unique_id())
	new_player.set_network_master(id)
	get_tree().get_root().add_child(new_player)
	new_player.init(info)
	
func update_data(id, data):
	players[id] = data
