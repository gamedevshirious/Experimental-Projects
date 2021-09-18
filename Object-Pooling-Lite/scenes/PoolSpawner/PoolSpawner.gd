extends Area2D

export var target_obj = "tree"

func instantiate_obj():
	$CollisionShape2D.disabled = true
	var path = ""
	match target_obj:
		"tree":
			path = Paths.TREE_PATH

	var obj = load(path).instance()
	add_child(obj)
	obj.position = Vector2.ZERO
	obj.name = "target"

func destroy_obj():
	var trg = get_node_or_null("target")
	if trg == null:
		return
	
	trg.queue_free()
	$CollisionShape2D.disabled = false
	

func _on_PoolSpawner_area_entered(area):
	if area.name != "pooler":
		return
	instantiate_obj()


func _on_PoolSpawner_area_exited(area):
	if area.name != "pooler":
		return
	destroy_obj()
