extends Node
var players = {}
var point = 0

func _ready():
	pass 


func _process(delta):
	pass

@rpc("authority","call_local", "reliable")
func setPlayers(p):
	players = p

@rpc("any_peer","call_local", "reliable",2)
func server_roll():
	if not multiplayer.is_server(): return
	var sender = multiplayer.get_remote_sender_id()
	var p = randi_range(1,10)
	getRoll.rpc_id(sender,p)

@rpc("authority","call_local", "reliable",2)
func getRoll(p):
	print("getRoll")
	point = p
