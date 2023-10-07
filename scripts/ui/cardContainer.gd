extends CanvasLayer
var cardsPos = {}
var card:PackedScene = load("res://scene/card/cardMagnet.tscn")

func _ready():
	add_to_group("card")
	draw()
	draw()


func _process(delta):
	pass


func _on_card_pos_child_entered_tree(node):
	cardsPos[node.position] = false

func draw():
	var ins = card.instantiate()
	
	for i in cardsPos:
		if cardsPos[i] : continue
		cardsPos[i] = true
		ins.init(i)
		add_child(ins)
		return

func _on_use_card_pressed():
	get_tree().call_group("card","on_useCard")
