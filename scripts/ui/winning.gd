extends CanvasLayer
var lobby:PackedScene = load("res://scene/ui/lobby.tscn")

func _ready():
	$playerWin.text = GameController.winPlayer

func _process(delta):
	pass

func _on_to_lobby_pressed():
	get_tree().change_scene_to_packed(lobby)
