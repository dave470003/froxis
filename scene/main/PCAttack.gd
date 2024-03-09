extends Node2D

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const RemoveObject := preload("res://scene/main/RemoveObject.gd")
const Schedule := preload("res://scene/main/Schedule.gd")

var _ref_DungeonBoard: DungeonBoard
var _ref_RemoveObject: RemoveObject
var _ref_Schedule: Schedule

signal pc_attacked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attack(group_name: String, x: int, y: int) -> void:
	if not _ref_DungeonBoard.has_sprite(group_name, x, y):
		return
	pc_attacked.emit("You kill Urist McRogueliker! :(")
	_ref_RemoveObject.remove(group_name, x, y)
	_ref_Schedule.end_turn()
