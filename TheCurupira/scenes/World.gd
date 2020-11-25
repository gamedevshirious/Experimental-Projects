extends Node

var level = 1

func _ready():
	randomize()

func _on_SpawnTimer_timeout():
	if ($Animals.get_child_count() - 3) > level * 2:
		return
	var deer = preload("res://characters/NPC/Deer/Deer.tscn").instance()
	var spawner = "Animals/Spawner"+ str(int(rand_range(1, 3)))
	print(spawner)
	deer.position = get_node(spawner).position
	$Animals.add_child(deer)
	
