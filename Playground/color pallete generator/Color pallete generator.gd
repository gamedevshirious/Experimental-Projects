extends Node

var link = "https://www.thecolorapi.com/scheme?format=json&mode=quad&count=4&hex="

var gcolor = "000000"

func _ready():
	pass


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
#	$Text.text = body.get_string_from_ascii()
	var json = parse_json(body.get_string_from_ascii())
#	$Text.text = str(json.result)
	VisualServer.set_default_clear_color(Color(json["colors"][0]["hex"]["clean"]))

	for i in range(4):
		get_node("container/square"+str(i+1)).modulate = str(json["colors"][i]["hex"]["clean"]) 


func _on_Button_pressed():
	var _link = link + gcolor
#	var query = JSON.print("/scheme?hex=24B1E0&format=json&count=6")
	$HTTPRequest.request(_link) #,["Content-Type: application/json"],true,HTTPClient.METHOD_GET,query)



func _on_ColorPicker_color_changed(color):
	gcolor = color.to_html(false)


func _on_Button2_pressed():
	$ColorPicker.color = Color(randf(), randf(), randf())
