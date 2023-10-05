extends Node

func _ready():
	pass

func _process(delta):
	pass

func wait(time):
	await get_tree().create_timer(time).timeout

func isServer():
	return multiplayer.is_server()

func getUID():
	return multiplayer.get_unique_id()
