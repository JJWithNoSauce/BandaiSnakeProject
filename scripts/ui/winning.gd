extends CanvasLayer
var lobby:PackedScene = load("res://scene/ui/lobby.tscn")

func _ready():
	$Cup/playerWin.text = GameController.winPlayer
	$AniPlayer.play("start")
	await get_tree().create_timer(0.6).timeout
	$AniPlayer.play("hover")

func _process(delta):
	pass

func _on_to_lobby_pressed():
	get_tree().change_scene_to_packed(lobby)
