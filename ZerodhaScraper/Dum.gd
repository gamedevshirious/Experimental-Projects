extends Node2D

func _ready():
	$HTTPRequest.download_file = "res://temp.html"
	$HTTPRequest.request("https://coin.zerodha.com/funds/140516920.00206600/axis-seasons-debt-fund-funds-direct-plan")
	
	print("done")
