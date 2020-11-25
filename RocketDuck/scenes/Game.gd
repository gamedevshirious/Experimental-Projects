extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var duck
export (PackedScene) var wall
export (PackedScene) var powerup

# var save_game
var high_score = 0
var score = 0
var bullet_count = 0

var curr_wall_speed
var curr_wall_distance
var screen_offset

func new_game():
	duck = preload("res://scenes/RocketDuck.tscn").instance()
	duck.position = $birdspawn.global_position
	add_child(duck)
	#duck.connect("hide", self , "on_Wall_game_over")
	duck.connect("game_start", self , "on_game_start")
	duck.connect("game_over", self , "on_Wall_game_over")
	
func load_save():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	# while not save_game.eof_reached():
	var high_score = int(parse_json(save_game.get_line()))
	return high_score
	
func save_game(var score):
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(str(score))

func on_game_start() :
	$Timer.start()
	#duck.new_game()
#	print(duck.parent)
#	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	high_score = int(load_save())
	
	####initial difficulty
	curr_wall_speed = 275
	curr_wall_distance = 175
	screen_offset = 100
	# load_save()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$HUD/score_label.text = "Score : " + str(score) + "\nBullets : " + str(bullet_count)


func _on_Timer_timeout():
	var ch = randi() % 3
	print(ch)
	#spawn powerup
	if ch == 1:
		powerup = preload("res://scenes/PowerUps/BulletPowerUp.tscn").instance()
		powerup.position = $wallspawn.global_position  + Vector2(0, rand_range(-screen_offset, screen_offset))
		add_child(powerup)
	if ch == 2:
		powerup = preload("res://scenes/PowerUps/Boomerang.tscn").instance()
		powerup.position = $wallspawn.global_position  + Vector2(0, rand_range(-screen_offset, screen_offset))
		add_child(powerup)
	else:
	# spawn wall
		wall = preload("res://scenes/Walls.tscn").instance()
		wall.init(curr_wall_speed, curr_wall_distance)
		wall.position = $wallspawn.global_position + Vector2(0, rand_range(-screen_offset, screen_offset))
		add_child(wall)
		wall.connect("game_over", self , "on_Wall_game_over")
		wall.connect("score", self , "on_Wall_score")
	
	# var selfDup = self.duplicate()

func on_Wall_score():
	score += 1
	
	### update difficulty
	curr_wall_speed += 5
	curr_wall_distance -= 1
	screen_offset += 1

func on_Wall_game_over():
	$HUD/score_label.hide()
	$HUD/TextureButton.hide()
	if score >= high_score:
		high_score = score
		save_game(score)
	else:
		high_score = load_save()
	$HUD/game_over_label/score_label.text = "Score : " + str(score) + "High Score : " + str(high_score)
	$HUD/game_over_label.show()
	duck.queue_free()
	$Timer.stop()
#	get_tree().paused = true

func _on_restart_pressed():
	return get_tree().reload_current_scene()

func _on_TextureButton_pressed():
	Input.action_press("ui_accept")
