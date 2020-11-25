extends Node2D

func _ready():
	#self player
	var selfPlayer = preload("res://Sliding_Box.tscn").instance()
	selfPlayer.set_name(str(get_tree().get_network_unique_id()))
	selfPlayer.set_network_master(get_tree().get_network_unique_id())
	add_child(selfPlayer)
	# selfPlayer.position = $Spawnpoint1.position
	
	#other Player
	var opp = preload("res://Sliding_Box.tscn").instance()
	opp.set_name(str(globals.otherPlayerId))
	opp.set_network_master(globals.otherPlayerId)
	add_child(opp)
	# opp.position = $Spawnpoint2.position
	
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
