extends Control
var cardsPos = {}
var card:PackedScene = load("res://scene/card/cardMagnet.tscn")

func _ready():
	draw()


func _process(delta):
	pass


func _on_card_pos_child_entered_tree(node):
	cardsPos[node.position] = false

func draw():
	var ins = card.instantiate()
	
	for i in cardsPos:
		if cardsPos[i] : continue
		ins.init(i)
		add_child(ins)
		return
		
