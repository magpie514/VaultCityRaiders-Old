extends Control

const WEAPONCLASS_CANNON = 0
const AMMOCLASS_ENERGY = 0

var testwp = {
	tag = "DEBCAN",
	def = null,
	customName = "",
	durability = 9500,
	capacity = 32,
}

func init(WP):
	if WP == null: WP = testwp
	if WP.def == null: WP.def = main.weaponDef[WP.tag]
	get_node("WeaponName").set_text(WP.def.name)
	if WP.durability <= 0: get_node("WeaponName").add_color_override("font_color", Color(0.8, 0.5, 0.0))
	else: get_node("WeaponName").add_color_override("font_color", Color(1.0, 1.0, 1.0))
	get_node("Durability/Label").set_text(str(WP.durability, "/", WP.def.durability))
	get_node("Durability/Bar").value = float(WP.durability) / float(WP.def.durability)

	#TODO: Change ammo bar label and color based on requisites (ammo/user EP/weapon EP/user VP)
	get_node("Ammo/Label").set_text(str(WP.capacity, "/", WP.def.ammoCapacity))
	get_node("Ammo/Bar").value = float(WP.capacity) / float(WP.def.ammoCapacity)

	if WP.def.attack1 != null:
		get_node("WeaponButton0").show()
		get_node("WeaponButton0").init(WP.def.attack1, null)

	else: get_node("WeaponButton0").hide()
	if WP.def.attack2 != null:
		get_node("WeaponButton1").show()
		get_node("WeaponButton1").init(WP.def.attack2, null)
	else: get_node("WeaponButton1").hide()

func _ready():
	#init(testwp)
	pass

func _on_attackChoice( slot, level ):
	pass # replace with function body
