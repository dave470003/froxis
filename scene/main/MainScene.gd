extends "res://library/RootNodeTemplate.gd"

const INIT_GAME = "InitGame"
const INIT_LEVEL = "InitGame/InitLevel"
const PC = "InitGame/InitLevel/PC"
const PC_MOVE = "PCMove"
const PC_ATTACK = "PCMove/PCAttack"
const SCHEDULE = "Schedule"
const DUNGEON = "DungeonBoard"
const REMOVE = "RemoveObject"
const NPC = "EnemyAI"
const SIDEBAR = "MainGUI/MainHBoxContainer/SidebarVBoxContainer"
const MODELINE = "MainGUI/MainHBoxContainer/Modeline"
const MAIN_SCENE = "."
const CHARGE_SKILL: = "MainGUI/MainHBoxContainer/SidebarVBoxContainer/Skills/ChargeSkill"
const TRAP_SKILL: = "MainGUI/MainHBoxContainer/SidebarVBoxContainer/Skills/TrapSkill"
const INVISIBILITY_SKILL: = "MainGUI/MainHBoxContainer/SidebarVBoxContainer/Skills/InvisibilitySkill"
const SHURIKEN_SKILL: = "MainGUI/MainHBoxContainer/SidebarVBoxContainer/Skills/ShurikenSkill"

const SIGNAL_BIND: Array = [
	[
		"sprite_created", "_on_InitLevel_sprite_created",
		INIT_LEVEL,
		PC_MOVE, NPC, SCHEDULE, DUNGEON,
	],
	[
		"sprite_removed", "_on_RemoveObject_sprite_removed",
		REMOVE,
		SCHEDULE, DUNGEON,
	],
	[
		"turn_started", "_on_Schedule_turn_started",
		SCHEDULE,
		PC_MOVE, NPC, SIDEBAR, PC
	],
	[
		"turn_ended", "_on_Schedule_turn_ended",
		SCHEDULE,
		MODELINE, CHARGE_SKILL, TRAP_SKILL, INVISIBILITY_SKILL, SHURIKEN_SKILL
	],
	[
		"enemy_warned", "_on_EnemyAI_enemy_warned",
		NPC,
		MODELINE
	],
	[
		"enemy_attack", "_on_EnemyAI_enemy_attack",
		NPC,
		MODELINE, SIDEBAR
	],
	[
		"pc_moved", "_on_PCMove_pc_moved",
		PC_MOVE,
		MODELINE
	],
	[
		"pc_attacked", "_on_PCAttack_pc_attacked",
		PC_ATTACK,
		MODELINE
	],
	[
		"set_health", "_on_InitGame_set_health",
		INIT_GAME,
		SIDEBAR
	],
	[
		"level_started", "_on_InitLevel_level_started",
		INIT_LEVEL,
		SIDEBAR
	],
	[
		"next_level", "_on_PCMove_next_level",
		PC_MOVE,
		INIT_GAME
	],
	[
		"game_over", "_on_SidebarVBoxContainer_game_over",
		SIDEBAR,
		MAIN_SCENE
	],
	[
		"skill_primed", "_on_Charge_skill_primed",
		CHARGE_SKILL,
		PC_MOVE
	],
	[
		"skill_unprimed", "_on_Charge_skill_unprimed",
		CHARGE_SKILL,
		PC_MOVE
	],
	[
		"skill_primed", "_on_Trap_skill_primed",
		TRAP_SKILL,
		PC_MOVE
	],
	[
		"skill_unprimed", "_on_Trap_skill_unprimed",
		TRAP_SKILL,
		PC_MOVE
	],
	[
		"skill_primed", "_on_Invisibility_skill_primed",
		INVISIBILITY_SKILL,
		PC_MOVE
	],
	[
		"skill_unprimed", "_on_Invisibility_skill_unprimed",
		INVISIBILITY_SKILL,
		PC_MOVE
	],
	[
		"skill_primed", "_on_Shuriken_skill_primed",
		SHURIKEN_SKILL,
		PC_MOVE
	],
	[
		"skill_unprimed", "_on_Shuriken_skill_unprimed",
		SHURIKEN_SKILL,
		PC_MOVE
	],
	[
		"turn_invisible", "_on_PCMove_turn_invisible",
		PC_MOVE,
		PC
	],
]

const NODE_REF: Array = [
	[
		"_ref_DungeonBoard",
		DUNGEON,
		PC_MOVE, PC_ATTACK, REMOVE, INIT_LEVEL, NPC
	],
	[
		"_ref_Schedule",
		SCHEDULE,
		NPC, PC_ATTACK, PC_MOVE, INIT_LEVEL
	],
	[
		"_ref_RemoveObject",
		REMOVE,
		PC_ATTACK, NPC
	],
	[
		"_ref_MainScene",
		MAIN_SCENE,
		PC_MOVE, CHARGE_SKILL, TRAP_SKILL, INVISIBILITY_SKILL, SHURIKEN_SKILL
	],
	[
		"_ref_InitLevel",
		INIT_LEVEL,
		PC_MOVE,
	],
]

@onready var popup := preload("res://scene/gui/Popup.tscn") as PackedScene
var _game_paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _ready():
	_set_signal(SIGNAL_BIND)
	_set_node_ref(NODE_REF)

func _on_SidebarVBoxContainer_game_over(message: String):
	_game_paused = true
	var popup_node = popup.instantiate()
	var gui_node = get_node("MainGUI")
	gui_node.add_child(popup_node)
	popup_node.setup(
		"Game Over! " + message,
		[
			[
				32,
				"Space: Restart Game",
				Callable(self, "restart_game")
			]
		]
	)

func restart_game():
	get_node("InitGame").reset_game()
	_game_paused = false
