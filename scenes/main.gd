extends Node2D

var server := ENetMultiplayerPeer.new()

func _ready():
	var error = server.create_server(7070)
	if error != OK: print("ERROR CODE: ", error)

func _process(delta):
	var status = server.get_connection_status()
	if status == server.CONNECTION_CONNECTED:
		$Status.text = "Listen 7070"
	elif status == server.CONNECTION_DISCONNECTED:
		$Status.text = "Offline"
	
	var peers = server.get_host().get_peers()
	$Clients.text = "Clients: " + str(len(peers)) + " => " + str(peers)
