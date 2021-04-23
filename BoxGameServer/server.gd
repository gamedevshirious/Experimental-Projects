extends Node2D

var IP_CLIENT
var PORT_CLIENT
var PORT_SERVER = 1507
var IP_SERVER = "127.0.0.1"
var socketUDP = PacketPeerUDP.new()

func _ready():
	start_server()

func send_packet(ip, port, msg):
	socketUDP.set_dest_address(ip, port)
	var pac = msg.to_ascii()
	socketUDP.put_packet(pac)

func _process(delta):	  
	if socketUDP.get_available_packet_count() > 0:
		var array_bytes = socketUDP.get_packet()
		print(socketUDP.get_packet_ip())
		print(socketUDP.get_packet_port())
		IP_CLIENT = socketUDP.get_packet_ip()
		var PORT_CLIENT = socketUDP.get_packet_port()
		print("msg from client: " + array_bytes.get_string_from_ascii())
		send_packet(IP_CLIENT, PORT_CLIENT, "Hi")

func start_server():
	if (socketUDP.listen(PORT_SERVER) != OK):
		printt("Error listening on port: " + str(PORT_SERVER))
	else:
		printt("Listening on port: " + str(PORT_SERVER))

func _exit_tree():
	socketUDP.close()
