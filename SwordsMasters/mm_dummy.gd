extends KinematicBody2D

var net_id = ""
var current_anim = ""
var state_machine
var hp = 100

func _ready():
	init_player("xyz")

func init_player(name, swordtype = "katana"):
	$Name.text = name +"\n"+ swordtype
	state_machine = $AnimationTree.get("parameters/playback")


#func _process(delta):
#	current_anim = "idle"
#	$AnimationPlayer.current_animation = current_anim
