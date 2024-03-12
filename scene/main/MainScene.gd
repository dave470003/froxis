extends "res://library/RootNodeTemplate.gd"

const INIT_GAME = "InitGame"
const INIT_LEVEL = "InitGame/InitLevel"
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
const TELEPORT_SKILL: = "MainGUI/MainHBoxContainer/SidebarVBoxContainer/Skills/TeleportSkill"
const SHOP = "Shop"

const SIGNAL_BIND: Array = [
	[
		"sprite_created", "_on_InitLevel_sprite_created",
		INIT_LEVEL,
		PC_MOVE, NPC, SCHEDULE, DUNGEON,
	],
	[
		"sprite_removed", "_on_RemoveObject_sprite_removed",
		REMOVE,
		SCHEDULE, DUNGEON, MAIN_SCENE
	],
	[
		"turn_started", "_on_Schedule_turn_started",
		SCHEDULE,
		PC_MOVE, NPC, SIDEBAR, MODELINE
	],
	[
		"turn_ended", "_on_Schedule_turn_ended",
		SCHEDULE,
		CHARGE_SKILL, TRAP_SKILL, INVISIBILITY_SKILL, SHURIKEN_SKILL, TELEPORT_SKILL
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
		MODELINE, PC_MOVE
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
		INIT_GAME, SHOP
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
		"skill_primed", "_on_Teleport_skill_primed",
		TELEPORT_SKILL,
		PC_MOVE
	],
	[
		"skill_unprimed", "_on_Teleport_skill_unprimed",
		TELEPORT_SKILL,
		PC_MOVE
	],
	[
		"visit_shrine", "_on_PCMove_visit_shrine",
		PC_MOVE,
		MAIN_SCENE
	],
	[
		"learn_shuriken", "_on_Shop_learn_shuriken",
		SHOP,
		SIDEBAR
	],
	[
		"learn_teleport", "_on_Shop_learn_teleport",
		SHOP,
		SIDEBAR
	],
	[
		"learn_trap", "_on_Shop_learn_trap",
		SHOP,
		SIDEBAR
	],
	[
		"learn_invisibility", "_on_Shop_learn_invisibility",
		SHOP,
		SIDEBAR
	],
	[
		"reduce_skill_cooldown", "_on_Shop_reduce_skill_cooldown",
		SHOP,
		SIDEBAR
	],
	[
		"increase_health", "_on_Shop_increase_health",
		SHOP,
		SIDEBAR
	],
	[
		"teleport_kill", "_on_PCMove_teleport_kill",
		PC_MOVE,
		TELEPORT_SKILL
	],
	[
		"start_game", "_on_InitGame_start_game",
		INIT_GAME,
		MAIN_SCENE, MODELINE
	],
	[
		"display_message", "_on_PCMove_display_message",
		PC_MOVE,
		MODELINE
	],
	[
		"display_message", "_on_PCAttack_display_message",
		PC_ATTACK,
		MODELINE
	],
	[
		"display_message", "_on_EnemyAI_display_message",
		NPC,
		MODELINE
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
		PC_MOVE, CHARGE_SKILL, TRAP_SKILL, INVISIBILITY_SKILL, SHURIKEN_SKILL, TELEPORT_SKILL
	],
	[
		"_ref_InitLevel",
		INIT_LEVEL,
		PC_MOVE,
	],
	[
		"_ref_Shop",
		SHOP,
		MAIN_SCENE, PC_MOVE, PC_ATTACK, NPC
	],
]

const Shop := preload("res://scene/main/Shop.gd")

@onready var popup := preload("res://scene/gui/Popup.tscn") as PackedScene

var _new_Skills := preload("res://library/Skills.gd").new()
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _game_paused = false
var _ref_Shop: Shop

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
				Callable(self, "restart_game"),
				[]
			]
		]
	)

func restart_game():
	get_node("InitGame").reset_game()
	get_node(CHARGE_SKILL).reset()
	get_node(INVISIBILITY_SKILL).reset()
	get_node(TRAP_SKILL).reset()
	get_node(SHURIKEN_SKILL).reset()
	get_node(TELEPORT_SKILL).reset()
	_ref_Shop.reset()
	_game_paused = false

func _on_PCMove_visit_shrine():
	if !_ref_Shop._is_open:
		return
	_game_paused = true
	var popup_node = popup.instantiate()
	var gui_node = get_node("MainGUI")
	var available_boons = _ref_Shop._available_skills.slice(0, 3)
	gui_node.add_child(popup_node)
	var initial_text = "You come across a mysterious shrine.
		It grants you one of the following boons:
		1: {0}
		2: {1}"
	var format_array = [available_boons[0].description, available_boons[1].description]
	var options = [
			[
				KEY_1,
				"1: Option 1",
				Callable(self, "purchase_skill"),
				[available_boons[0].key]
			],
			[
				KEY_2,
				"2: Option 2",
				Callable(self, "purchase_skill"),
				[available_boons[1].key]
			]
		]
	if _ref_Shop.has_skill(_new_Skills.SKILL_GET_AMULET):
		initial_text = initial_text + "
		3: {2}"
		format_array.append(available_boons[2].description)
		options.append([
			KEY_3,
			"3: Option 3",
			Callable(self, "purchase_skill"),
			[available_boons[2].key]
		])
	popup_node.setup(initial_text.format(format_array), options)

func purchase_skill(skill_name: String):
	_ref_Shop.purchase_skill(skill_name)
	_game_paused = false

func _on_RemoveObject_sprite_removed(sprite, group_name, x, y):
	if sprite.is_in_group(_new_GroupName.DEMON):
		_game_paused = true
		var popup_node = popup.instantiate()
		var gui_node = get_node("MainGUI")
		gui_node.add_child(popup_node)
		popup_node.setup(
			"You slayed the vicious Demon!
			You win!",
			[
				[
					32,
					"Space: Restart Game",
					Callable(self, "restart_game"),
					[]
				]
			]
		)

func _on_InitGame_start_game():
	get_node("MainGUI/SplashScreen").visible = false
	get_node(CHARGE_SKILL).reset()
	get_node(INVISIBILITY_SKILL).reset()
	get_node(TRAP_SKILL).reset()
	get_node(SHURIKEN_SKILL).reset()
	get_node(TELEPORT_SKILL).reset()
	_ref_Shop.reset()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_R and event.is_pressed() and !event.is_echo():
		_show_credits()
	elif event is InputEventKey and event.keycode == KEY_U and event.is_pressed() and !event.is_echo():
		_show_tutorial()

func _show_credits():
	_game_paused = true
	var popup_node = popup.instantiate()
	var gui_node = get_node("MainGUI")
	gui_node.add_child(popup_node)
	popup_node.setup(
		"Froxis - A game by Foxtale Creative
		Made for the 7DRL 2024 Challenge
		Inspired by Bozar and Hoplite",
		[
			[
				KEY_ESCAPE,
				"ESC: Close Credits",
				Callable(self, "resume"),
				[]
			]
		]
	)

func _show_tutorial():
	_game_paused = true
	var popup_node = popup.instantiate()
	var gui_node = get_node("MainGUI")
	gui_node.add_child(popup_node)
	popup_node.setup_pages([
		"You, the player, are represented by @. You are tasked with slaying a demon who resides on the 10th floor of the dungeon.",
		"The ladder to the next floor is marked by ⌠. There is also a shrine on each level marked by ⌂. Visiting it will grant you special powers to help you on your journey.",
		"Various creatures will try to stop you:
		d - a slow, fragile dwarf.
		T - a troll with three hitpoints.
		h - a quick, flying harpy with two hitpoints.
		e - a fragile elf who will try to shoot you from up to four spaces away.
		D - the demon you are to slay, a fearsome creature",
		"Luckily you have some skills you can master:
		Charge: pressing c will make the next attack a charge attack. Initially this is just a little extra movement, but you can upgrade it to perform a powerful stomp attack after your charge.",
		"Invisibility: You will turn invisible for 3 turns, or until you attack someone. Enemies will not come after you.
		Lay Trap: Lay down a trap which will injure ground-walking enemies who come across it.",
		"Shuriken: After movement, hurl a shuriken at the nearest enemy in range of 3 spaces.
		Teleport: Teleport to a random square in the arena. Upgrading it will allow it to deal damage.",
		"How combat works:
		If you were to move (or charge) into an enemy, stop in front of them and deal them damage instead. Then, after your move (or your attack), you will swing your sword around you, hitting anyone adjacent to you and dealing them damage. The range of this sweep can be upgraded in-game.
		Enemies will then take turns moving towards you, and dealing you damage.",
		"You'll figure out the rest yourself.
		Best of luck!"
	], Callable(self, "resume"),)

func resume():
	_game_paused = false
