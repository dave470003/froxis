# Skills.gd

const SKILL_UPGRADE_HEALTH = "skill_upgrade_health"
const SKILL_GET_TELEPORT = "skill_get_teleport"
const SKILL_GET_AMULET = "skill_get_amulet"
const SKILL_INVISIBILITY_1 = "skill_invisibility_1"
const SKILL_INVISIBILITY_2 = "skill_invisibility_2"
const SKILL_INVISIBILITY_3 = "skill_invisibility_3"
const SKILL_INVISIBILITY_4 = "skill_invisibility_4"
const SKILL_INVISIBILITY_5 = "skill_invisibility_5"
const SKILL_SHURIKEN_1 = "skill_shuriken_1"
const SKILL_SHURIKEN_2 = "skill_shuriken_2"
const SKILL_SHURIKEN_3 = "skill_shuriken_3"
const SKILL_SHURIKEN_4 = "skill_shuriken_4"
const SKILL_SHURIKEN_5 = "skill_shuriken_5"
const SKILL_TRAP_1 = "skill_trap_1"
const SKILL_TRAP_2 = "skill_trap_2"
const SKILL_TRAP_3 = "skill_trap_3"
const SKILL_TRAP_4 = "skill_trap_4"
const SKILL_TRAP_5 = "skill_trap_5"
const SKILL_ATTACK_1 = "skill_attack_1"
const SKILL_ATTACK_2 = "skill_attack_2"
const SKILL_ATTACK_3 = "skill_attack_3"
const SKILL_CHARGE_1 = "skill_charge_1"
const SKILL_CHARGE_2 = "skill_charge_2"
const SKILL_CHARGE_3 = "skill_charge_3"
const SKILL_CHARGE_4 = "skill_charge_4"
const SKILL_TELEPORT_1 = "skill_teleport_1"
const SKILL_TELEPORT_2 = "skill_teleport_2"
const SKILL_TELEPORT_3 = "skill_teleport_3"
const SKILL_TELEPORT_4 = "skill_teleport_4"

const SKILL_DICT = {
	SKILL_UPGRADE_HEALTH: {
		"id": 1,
		"key": SKILL_UPGRADE_HEALTH,
		"description": "Add one health.",
		"dependency": null
	},
	SKILL_GET_TELEPORT: {
		"id": 2,
		"key": SKILL_GET_TELEPORT,
		"description": "Obtain a scroll of teleportation",
		"dependency": null
	},
	SKILL_GET_AMULET: {
		"id": 3,
		"key": SKILL_GET_AMULET,
		"description": "Obtain an amulet of charisma",
		"dependency": null
	},
	SKILL_INVISIBILITY_1: {
		"id": 4,
		"key": SKILL_INVISIBILITY_1,
		"description": "Learn the Invisibility skill",
		"dependency": null
	},
	SKILL_INVISIBILITY_2: {
		"id": 5,
		"key": SKILL_INVISIBILITY_2,
		"description": "Invisibility lasts for an extra turn",
		"dependency": 4
	},
	SKILL_INVISIBILITY_3: {
		"id": 6,
		"key": SKILL_INVISIBILITY_3,
		"description": "Invisibility has a reduced cooldown",
		"dependency": 5
	},
	SKILL_INVISIBILITY_4: {
		"id": 7,
		"key": SKILL_INVISIBILITY_4,
		"description": "Invisibility is not removed when attacking",
		"dependency": 6
	},
	SKILL_INVISIBILITY_5: {
		"id": 8,
		"key": SKILL_INVISIBILITY_5,
		"description": "Invisibility adds invulnerability",
		"dependency": 7
	},
	SKILL_CHARGE_1: {
		"id": 9,
		"key": SKILL_CHARGE_1,
		"description": "After charging, stomp to damage enemies in an area",
		"dependency": null
	},
	SKILL_CHARGE_2: {
		"id": 10,
		"key": SKILL_CHARGE_2,
		"description": "Charge cooldown is reduced",
		"dependency": 9
	},
	SKILL_CHARGE_3: {
		"id": 11,
		"key": SKILL_CHARGE_3,
		"description": "Charge has added range",
		"dependency": 10
	},
	SKILL_CHARGE_4: {
		"id": 12,
		"key": SKILL_CHARGE_4,
		"description": "Charge's stomp has added range",
		"dependency": 11
	},
	SKILL_TRAP_1: {
		"id": 13,
		"key": SKILL_TRAP_1,
		"description": "Learn the Trap skill",
		"dependency": null
	},
	SKILL_TRAP_2: {
		"id": 14,
		"key": SKILL_TRAP_2,
		"description": "Trap has a reduced cooldown",
		"dependency": 13
	},
	SKILL_TRAP_3: {
		"id": 15,
		"key": SKILL_TRAP_3,
		"description": "Trap now detonates in an area",
		"dependency": 14
	},
	SKILL_TRAP_4: {
		"id": 16,
		"key": SKILL_TRAP_4,
		"description": "Trap now affects flying enemies",
		"dependency": 15
	},
	SKILL_TRAP_5: {
		"id": 17,
		"key": SKILL_TRAP_5,
		"description": "Trap now stuns all enemies upon entering or detonating",
		"dependency": 16
	},
	SKILL_SHURIKEN_1: {
		"id": 18,
		"key": SKILL_SHURIKEN_1,
		"description": "Learn the Shuriken skill",
		"dependency": null
	},
	SKILL_SHURIKEN_2: {
		"id": 19,
		"key": SKILL_SHURIKEN_2,
		"description": "Increase the range of Shuriken",
		"dependency": 18
	},
	SKILL_SHURIKEN_3: {
		"id": 20,
		"key": SKILL_SHURIKEN_3,
		"description": "Reduce the cooldown of Shuriken",
		"dependency": 19
	},
	SKILL_SHURIKEN_4: {
		"id": 21,
		"key": SKILL_SHURIKEN_4,
		"description": "Player now throws two shurikens",
		"dependency": 20
	},
	SKILL_SHURIKEN_5: {
		"id": 22,
		"key": SKILL_SHURIKEN_5,
		"description": "Each thrown shuriken now bounces to another enemy",
		"dependency": 21
	},
	SKILL_ATTACK_1: {
		"id": 23,
		"key": SKILL_ATTACK_1,
		"description": "After moving, the player swings their sword around them.",
		"dependency": null
	},
	SKILL_ATTACK_2: {
		"id": 24,
		"key": SKILL_ATTACK_2,
		"description": "The player deals two damage on attacking.",
		"dependency": 23
	},
	SKILL_ATTACK_3: {
		"id": 25,
		"key": SKILL_ATTACK_3,
		"description": "The player's spin attack after moving does extra damage",
		"dependency": 24
	},
	SKILL_TELEPORT_1: {
		"id": 26,
		"key": SKILL_TELEPORT_1,
		"description": "Teleporting now deals damage to all enemies within two spaces of arrival",
		"dependency": null
	},
	SKILL_TELEPORT_2: {
		"id": 27,
		"key": SKILL_TELEPORT_2,
		"description": "Small chance to find teleport scrolls after killing enemies",
		"dependency": 26
	},
	SKILL_TELEPORT_3: {
		"id": 28,
		"key": SKILL_TELEPORT_3,
		"description": "Teleport deals damage to enemies upon departure",
		"dependency": 27
	},
	SKILL_TELEPORT_4: {
		"id": 29,
		"key": SKILL_TELEPORT_4,
		"description": "Teleport now instantly kills nearby non-boss enemies on arrival",
		"dependency": 28
	},
}
