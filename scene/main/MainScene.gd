extends "res://library/RootNodeTemplate.gd"

const INIT_WORLD = "InitWorld"
const PC_MOVE = "PCMove"
const PC_ATTACK = "PCMove/PCAttack"
const SCHEDULE = "Schedule"
const DUNGEON = "DungeonBoard"
const REMOVE = "RemoveObject"
const NPC = "EnemyAI"
const SIDEBAR = "MainGUI/MainHBoxContainer/SidebarVBoxContainer"
const MODELINE = "MainGUI/MainHBoxContainer/Modeline"

const SIGNAL_BIND: Array = [
	[
		"sprite_created", "_on_InitWorld_sprite_created",
		INIT_WORLD,
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
		PC_MOVE, NPC, SIDEBAR
	],
	[
		"turn_ended", "_on_Schedule_turn_ended",
		SCHEDULE,
		MODELINE
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
		"set_health", "_on_InitWorld_set_health",
		INIT_WORLD,
		SIDEBAR
	],
]

const NODE_REF: Array = [
	[
		"_ref_DungeonBoard",
		DUNGEON,
		PC_MOVE, PC_ATTACK, REMOVE, INIT_WORLD,
	],
	[
		"_ref_Schedule",
		SCHEDULE,
		NPC, PC_ATTACK, PC_MOVE
	],
	[
		"_ref_RemoveObject",
		REMOVE,
		PC_ATTACK
	],
]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _ready():
	_set_signal(SIGNAL_BIND)
	_set_node_ref(NODE_REF)

	print(get_node("Schedule").turn_ended.get_connections())
