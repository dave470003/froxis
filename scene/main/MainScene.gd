extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var schedule = get_node("Schedule")
	var dungeonBoard = get_node("DungeonBoard")
	var removeObject = get_node("RemoveObject")
	get_node("PCMove")._ref_Schedule = schedule
	get_node("EnemyAI")._ref_Schedule = schedule
	get_node("InitWorld")._ref_DungeonBoard = dungeonBoard
	get_node("PCMove")._ref_DungeonBoard = dungeonBoard
	get_node("PCMove/PCAttack")._ref_DungeonBoard = dungeonBoard
	get_node("PCMove/PCAttack")._ref_RemoveObject = removeObject
	get_node("PCMove/PCAttack")._ref_Schedule = schedule
	get_node("RemoveObject")._ref_DungeonBoard = dungeonBoard

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
