extends Node

var playersStat = {}
var nowPlayer : Player

func setNowPlayer(id):
	nowPlayer = playersStat[id]

@rpc("any_peer","call_local","reliable",3)
func server_on_setWalk(id,step,dir):
	if not Lib.isServer() : return
	on_getWalk.rpc_id(id,step,dir)
	
@rpc("authority","call_local","reliable",3)
func on_getWalk(step,dir):
	nowPlayer.on_walkToStep(step,dir)
