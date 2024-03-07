extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("PCMove")._ref_Schedule = get_node("Schedule")
	get_node("EnemyAI")._ref_Schedule = get_node("Schedule")
	get_node("PCMove")._ref_DungeonBoard = get_node("DungeonBoard")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
