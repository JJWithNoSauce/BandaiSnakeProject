extends CanvasLayer
var cardsPos = {}
var card:PackedScene = load("res://scene/card/cardMagnet.tscn")

func _ready():
	add_to_group("card")
	add_to_group("network")
	draw()
	draw()


func _process(delta):
	pass

func _on_card_pos_child_entered_tree(node):
	cardsPos[node.position] = null

func draw():
	var ins = card.instantiate()
	
	for i in cardsPos:
		if cardsPos[i] : continue
		cardsPos[i] = ins
		ins.init(i)
		add_child(ins)
		return

func _on_use_card_pressed():
	get_tree().call_group("card","on_useCard")
	$useCard.visible = false

func on_isTurn():
	$useCard.disabled = false

func on_endTurn():
	$useCard.disabled = true

