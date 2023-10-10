extends Node2D

func _ready():
	pass 

func _process(delta):
	pass

func walkInRoll(player,mult):
	ActionControl.server_on_walkInRoll.rpc(player.uid,mult)
