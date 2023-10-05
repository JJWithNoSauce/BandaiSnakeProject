extends Node
var players = {}
var point = 0
var playerQueue = []
var isTrun = false

func _ready():
	add_to_group("network")


func _process(delta):
	pass

@rpc("authority","call_local", "reliable")
func setPlayers(p):
	players = p
	for i in p :
		playerQueue.append(i)

@rpc("any_peer","call_local", "reliable",2)
func server_roll():
	if not Lib.isServer(): return
	var sender = multiplayer.get_remote_sender_id()
	var p = randi_range(1,10)
	getRoll.rpc_id(sender,p)

@rpc("authority","call_local", "reliable",2)
func getRoll(p):
	point = p

func readyToStart():
	if not Lib.isServer() : return
	var send = playerQueue.pop_front()
	nextTurn.rpc_id(send)

@rpc("any_peer","call_local","reliable",2)
func server_getEndTurn():
	if not Lib.isServer() :return
	playerQueue.push_back(multiplayer.get_remote_sender_id())
	var send = playerQueue.pop_front()
	print(send)
	nextTurn.rpc_id(send)
	
@rpc("authority","call_local","reliable",2)
func nextTurn():
	isTrun = true
	get_tree().call_group("network","on_isTrun")
