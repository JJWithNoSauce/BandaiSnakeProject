extends Node2D
class_name CellParent

func init(step,pos):
	position = pos
	$step.text = str(step)

func _ready():
	pass 

func _process(delta):
	pass
