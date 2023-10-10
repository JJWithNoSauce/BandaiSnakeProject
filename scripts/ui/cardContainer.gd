extends CanvasLayer
var cardsPos = {}
var card
var cards = ["res://scene/card/cardMagnet.tscn","res://scene/card/cardMyTime.tscn"]

func _ready():
	add_to_group("card")
	add_to_group("network")

func _process(delta):
	pass

func _on_card_pos_child_entered_tree(node):
	cardsPos[node.position] = null

func draw():
	card = cards.pick_random()
	var ins = load(card).instantiate()
	
	for i in cardsPos:
		if cardsPos[i] : continue
		cardsPos[i] = ins
		ins.init(i)
		add_child(ins)
		return

func _on_use_card_pressed():
	$useCard.visible = false
	get_tree().call_group("card","on_useCard")

func on_isTurn():
	await Lib.wait(0.1)
	$useCard.disabled = false

func on_endTurn():
	$useCard.disabled = true

