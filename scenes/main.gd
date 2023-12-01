extends Node2D

var network := ENetMultiplayerPeer.new()
var gateway := SceneMultiplayer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	network.peer_connected.connect(_on_peer_connected)
	network.peer_disconnected.connect(_on_peer_disconnected)
	
	var error = network.create_server(7070)
	if error: print("ERROR CODE: ", error)
	get_tree().set_multiplayer(gateway, self.get_path())
	multiplayer.set_multiplayer_peer(network)
	
	print("Server listen 7070")

func _process(delta):
	if gateway.has_multiplayer_peer():
		gateway.poll()

func _on_peer_connected(peer_id):
	print("_on_peer_connected, peer_id: {0}".format([peer_id]))
	await get_tree().create_timer(1).timeout
	print("Custom Peers: {0}".format([multiplayer.get_peers()]))
	
func _on_peer_disconnected(peer_id):
	print("_on_peer_disconnected, peer_id: {0}".format([peer_id]))

@rpc("any_peer") 
func rpc_server_custom():
	var peer_id = multiplayer.get_remote_sender_id() # even custom uses default "multiplayer" calls
	print("rpc_server_custom, peer_id: {0}".format([peer_id]))
	rpc_server_custom_response(peer_id)

@rpc 
func rpc_server_custom_response(peer_id, test_var1 : String = "party like it's", test_var2 : int = 1999):
	print("rpc_server_custom_response to peer_id : {0}".format([peer_id]))
	rpc_server_custom_response.rpc_id(peer_id, test_var1, test_var2)
