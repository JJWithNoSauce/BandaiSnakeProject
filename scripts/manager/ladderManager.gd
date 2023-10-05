extends Node
class_name Ladder

var cell:PackedScene = load("res://scene/cell/cell1Normal.tscn")
var cellsPos = {}
var cellsStep= {}
var step = 1
var prevMapPos = Vector2i(0,0)
var next = 0
var isgenCell = false

var grapStep = 0

var cellPath = "res://scene/cell/"
@export var numCellGiveCard:Dictionary = {"cell1Normal":-1}

func _ready():
	add_to_group("system")

func _physics_process(delta):
	genCell()
	next += delta 

func genCell():
	if isgenCell : return
	
	if next >= 1: 
		isgenCell = true
		get_tree().call_group("system","on_genCelled")
		return
	
	var nextPath = get_node("pathStep")
	nextPath.progress_ratio = next
	
	var mapPos = $grid.local_to_map(nextPath.position)
	if mapPos == prevMapPos : return
	prevMapPos = mapPos
	
	var ins = cell.instantiate()
	var cellPos = $grid.map_to_local(mapPos)
	
	ins.init(step,cellPos)
	add_child(ins)
	
	cellsPos[cellPos] = ins
	cellsStep[step] = ins
	
	step += 1

func loadCell():
	var cellDir = DirAccess.get_files_at(cellPath)
	
	for i in cellDir :
		var c = load(cellPath+i)
		#cells.append(c)

func on_genCelled():
	step = step-1
	grapStep = 1/step

func getPosFromStep(s):
	var pos = cellsStep[s]
	return pos.position

func posToPosCell(pos):
	var cellPos = $grid.local_to_map(pos)
	pos = $grid.map_to_local(cellPos)
	return pos
	
