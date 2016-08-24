extends Control

const WEAPONCLASS_CANNON = 0
const AMMOCLASS_ENERGY = 0

var testwpdef = {
	name = "Debug Cannon",
	wClass = WEAPONCLASS_CANNON,
	description = "A test weapon",
	effectColor = Color(0.7, 0.75, 1.0),
	creator = 0,
	dualWield = true,
	durability = 9999,
	ammoClass = AMMOCLASS_ENERGY,
	ammoCapacity = 32,
	value = 99999,
	survival = false,

	attack1 = {
		name = "Linear buster",
		effect = "res://battle/effect/debug02.tscn",
		levels = 0,
		powerSource = main.SKILL_SOURCE_EP,
		overCost = 25,
		levelData = [
			{
				contact = false,
				durability = 10,
				ammo = 1,
				AD = -1,
				absoluteAD = false,
				damage = [main.ELEMENT_LIGHT, 2500, main.ELEMENT_ELEC, 1000],
				target = [0, 3, 2],
				ACC = 100,
				AGI = 0,
				effect = null
			},
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			{
				contact = false,
				durability = 100,
				ammo = 5,
				AD = -10,
				absoluteAD = false,
				damage = [main.ELEMENT_LIGHT, 45000, main.ELEMENT_ELEC, 30000],
				target = [0, 3, 2],
				ACC = 100,
				AGI = -10,
				effect = null
			},
		]
	},
	attack2 = null,
}

var testwp = {
	def = testwpdef,
	customName = "",
	durability = 9500,
	capacity = 32,
}

func init(WP):
	get_node("WeaponName").set_text(WP.def.name)
	get_node("Durability/Label").set_text(str(WP.durability, "/", WP.def.durability))
	get_node("Durability/Bar").value = float(WP.durability) / float(WP.def.durability)
	get_node("Ammo/Label").set_text(str(WP.capacity, "/", WP.def.ammoCapacity))
	get_node("Ammo/Bar").value = float(WP.capacity) / float(WP.def.ammoCapacity)
	if WP.def.attack1 != null:
		get_node("WeaponButton0").show()
		get_node("WeaponButton0").init(WP.def.attack1, null)

	else: get_node("WeaponButton0").hide()
	if WP.def.attack2 != null: get_node("WeaponButton1").show()
	else: get_node("WeaponButton1").hide()



func _ready():
	init(testwp)


