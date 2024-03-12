extends Label

var _new_GroupName := preload("res://library/GroupName.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Press Space to start game."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Schedule_turn_started(current_sprite: Sprite2D) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		text = ""

func _on_EnemyAI_enemy_warned(message: String) -> void:
	text = message

func _on_PCMove_pc_moved(message: String) -> void:
	text = message

func _on_PCAttack_pc_attacked(message: String) -> void:
	text = message

func _on_InitGame_start_game() -> void:
	text =  "Game started"

func _on_PCMove_display_message(message: String) -> void:
	text = message

func _on_PCAttack_display_message(message: String) -> void:
	text = message

func _on_EnemyAI_display_message(message: String) -> void:
	text = message
