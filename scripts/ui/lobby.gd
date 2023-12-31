extends Node2D

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" 
const MAX_CONNECTIONS = 20

var players = {}

var player_info = {"name": "Name","id":1}

var players_loaded = 0



func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	player_connected.connect(on_playerConect)


func join_game(address = ""):
	if address == "":
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer


func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	players[1] = player_info
	player_connected.emit(1, player_info)
	


func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null


@rpc("call_local", "reliable")
func load_game():
	get_tree().change_scene_to_file("res://scene/main.tscn")


@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		$pStat/pLog/Log.text = "A player is ready"
		players_loaded += 1
		if players_loaded == players.size():
			$pStat/pLog/Log.text = "The game is starting"
			GameController.setPlayers.rpc(players)
			await get_tree().create_timer(0.2).timeout
			load_game.rpc()
			players_loaded = 0

func _on_player_connected(id):
	$pStat/pLog/Log.text = "A player is connected."
	_register_player.rpc_id(id, player_info)


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)


func _on_player_disconnected(id):
	$pStat/pLog/Log.text = "A player is disconnected."
	player_info.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)


func _on_connected_fail():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	server_disconnected.emit()


func _on_host_pressed():
	var n = $joinUI/name.text
	if n == null : n = "player " + str(players.size()+1)
	player_info["name"] = n
	create_game()
	$joinUI.visible = false
	$pStat.visible = true
	$ready.visible = true
	$pPosition.text = "You are the host!"
	$pPosition.visible = true
	pStatupdate(1)

func _on_join_pressed():
	var n = $joinUI/name.text
	if n == "" : n = "player"
	player_info["name"] = n
	var ip = $joinUI/joinG/ip.text
	join_game(ip)
	
	$joinUI.visible = false
	$pStat.visible = true
	$ready.visible = true
	$pPosition.text = "You are the player"
	$pPosition.visible = true
	pStatupdate(1)

func on_playerConect(id,info):
	players[id]["id"] = players.size()

func _on_ready_pressed():
	pStatupdate(2)
	player_loaded.rpc()
	
func pStatupdate(method):
	#for method 0 = null , 1 = not ready , 2 = not ready
		$pStat/P1.frame = method
