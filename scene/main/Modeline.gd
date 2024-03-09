extends Label

var _new_GroupName := preload("res://library/GroupName.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../../../Schedule").turn_ended.connect(_on_Schedule_turn_ended)
	get_node("../../../EnemyAI").enemy_warned.connect(_on_EnemyAI_enemy_warned)
	get_node("../../../PCMove").pc_moved.connect(_on_PCMove_pc_moved)
	get_node("../../../PCMove/PCAttack").pc_attacked.connect(_on_PCAttack_pc_attacked)
	text = "Press Space to start game."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Schedule_turn_ended(current_sprite: Sprite2D) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		text = ""


func _on_EnemyAI_enemy_warned(message: String) -> void:
	text = message


func _on_PCMove_pc_moved(message: String) -> void:
	text = message


func _on_PCAttack_pc_attacked(message: String) -> void:
	text = message
