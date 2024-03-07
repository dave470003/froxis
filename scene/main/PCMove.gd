extends Node2D

var _new_InputName := preload("res://library/InputName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_GroupName := preload("res://library/GroupName.gd").new()

var _pc: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
    get_node("../Schedule").turn_started.connect(_on_Schedule_turn_started)
    get_node("../InitWorld").sprite_created.connect(_on_InitWorld_sprite_created)
    set_process_unhandled_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _on_InitWorld_sprite_created(sprite: Sprite2D):
    if sprite.is_in_group(_new_GroupName.PC):
        _pc = sprite
        set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
    print("pc: {0}".format([_pc]))
    var source: Array = _new_ConvertCoord.vector_to_array(_pc.position)
    var x: int = source[0]
    var y: int = source[1]

    if event.is_action_pressed(_new_InputName.MOVE_LEFT):
        x -= 1
    elif event.is_action_pressed(_new_InputName.MOVE_RIGHT):
        x += 1
    elif event.is_action_pressed(_new_InputName.MOVE_UP):
        y -= 1
    elif event.is_action_pressed(_new_InputName.MOVE_DOWN):
        y += 1


    _pc.position = _new_ConvertCoord.index_to_vector(x, y)
    get_node("../Schedule").end_turn()

func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
    if current_sprite.is_in_group(_new_GroupName.PC):
        set_process_unhandled_input(true)
    else:
        print(current_sprite.name)
