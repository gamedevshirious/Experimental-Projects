extends Node2D

var localhost = "127.0.0.1"

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _player_connected(id) :
	print("Connected !!!")
	globals.otherPlayerId = id
	var game = preload("res://Level1.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()

func _on_HostButton_pressed():
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_server(4242, 2)
	if res != OK :
		print("Error")
		return
	get_tree().set_network_peer(host)
	$StatusLabel.text = "Hosting"
	
	$HostButton.disabled = true
	$JoinButton.hide()

func _on_JoinButton_pressed():
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_client(localhost, 4242)
	if res != OK :
		print("Error")
		return
	get_tree().set_network_peer(host)
	
	$HostButton.hide()
	$JoinButton.disabled = true
