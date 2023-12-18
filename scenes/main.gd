extends Node2D

var peer := ENetMultiplayerPeer.new()

func _ready():
	multiplayer.peer_connected.connect(_on_client_connect)
	multiplayer.peer_disconnected.connect(_on_client_disconnect)

	var error = peer.create_server(7070)
	if error != OK: 
		print("Error ", str(error))

	multiplayer.multiplayer_peer = peer

func _on_client_connect(peer_id):
	$ItemList.add_item(str(peer_id) + " connected")
	send_message_to_client.rpc_id(peer_id, "Hola Cliente, soy don Server")
	

func _on_client_disconnect(peer_id):
	$ItemList.add_item(str(peer_id) + " disconnected")

func _process(delta):
	var status = peer.get_connection_status()
	if status == peer.CONNECTION_CONNECTED:
		$Status.text = "Listen 7070"
	elif status == peer.CONNECTION_DISCONNECTED:
		$Status.text = "Offline"
	
	var peers = peer.get_host().get_peers()
	$Clients.text = "Clients: " + str(len(peers)) + " => " + str(peers)

@rpc("any_peer")
func send_message_to_server(message: String):
	print("send_message_to_server: ", message)
	if multiplayer.is_server():
		send_message_to_client.rpc(message)
		
@rpc("authority")
func send_message_to_client(message: String):
	print("send_message_to_client", message)
