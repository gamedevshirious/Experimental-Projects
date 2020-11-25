extends Node

#const SWORDSMASTERS_SERVER_IP = "127.0.0.1"
const SWORDSMASTERS_SERVER_IP = "192.168.1.212"
# const SWORDSMASTERS_SERVER_IP = "162.254.189.86"
const SWORDSMASTERS_PORT = 4412
const SAVFILE = "user://save_game_01.json"


var mode = "local"
var room_id = ""
var player_name = "Default"
var sword = ""
var same_sword = false

var swords = {
"Rapier":{
	"info":"A Rapier is type of sword with a slender and sharply-pointed two-edged blade that was popular in Western Europe, both for civilian use (dueling and self-defense) and as a military side arm, throughout the 16th and 17th centuries."
},
"Shamshir":{
	"info":"A shamshir (Persian: شمشیر‎) is a type of Middle Eastern sword with a radical curve. The name is derived from shamshīr, which means 'Lion\'s Fang'"
}, 
"Katana":{
	"info":"A katana is a Japanese sword characterized by a curved, single-edged blade with a circular or squared guard and long grip to accommodate two hands."
},
"Flamberge":{
	"info":"A flamberge was a kind of two-handed sword. The term 'flamberge' was also applied to a special type of single handed rapier that possessed an undulating blade."
},
"Tulwar":{
	"info":"The tulwar generally possesses a blade with a medium curve, however, it should be remembered that the term is derived from Sanskrit and simply means sword, and so it could be applied to any entry in this list. Also spelled talwar."
}
}

func send_packet(packet):
	if mode == "local":
		return
	var error = get_tree().multiplayer.send_bytes(to_json(packet).to_ascii())
	if error != OK:
		#print(packet["reason"] + " packet sent!")
		return false
	return true
