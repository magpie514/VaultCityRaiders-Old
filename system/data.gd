extends Node
#Various data validation funcs.

func validateWeaponAtkDef(A):
	A.levels = int(A.levels)
	A.powerSource = int(A.powerSource)
	A.overCost = int(A.overCost)
	var LD = null
	for i in range(0, 9):
		LD = A.levelData[i]
		if LD != null:
			LD.contact = bool(LD.contact)
			LD.durability = int(LD.durability); LD.ammo = int(LD.ammo)
			LD.AD = int(LD.AD); LD.absoluteAD = bool(LD.absoluteAD)
			for j in range(0, 4):
				LD.damage[j] = int(LD.damage[j])
			for j in range(0, 3):
				LD.target[j] = int(LD.target[j])
			LD.ACC = int(LD.ACC); LD.AGI = int(LD.AGI)

func validateWeaponDef(L):
	var K = null
	for key in L:
		K = L[key]
		K.wClass = int(K.wClass); K.creator = int(K.creator)
		K.STRreq = int(K.STRreq); K.WISreq = int(K.WISreq);
		K.durability = int(K.durability); K.ammoCapacity = int(K.ammoCapacity); K.ammoClass = int(K.ammoClass)
		K.effectColor = Color(K.effectColor[0], K.effectColor[1], K.effectColor[2])
		K.dualWield = bool(K.dualWield); K.survival = bool(K.survival)
		K.value = int(K.value)
		validateWeaponAtkDef(K.attack1)
		validateWeaponAtkDef(K.attack2)
		#print(K)



func validateSkillLevelDef(A):
	var LD = null
	for i in range(0, 9):
		LD = A[i]
		if LD != null:
			LD.contact = bool(LD.contact)
			LD.AD = int(LD.AD); LD.absoluteAD = bool(LD.absoluteAD)
			for j in range(0, 4):
				LD.damage[j] = int(LD.damage[j])
			for j in range(0, 3):
				LD.target[j] = int(LD.target[j])
			LD.ACC = int(LD.ACC); LD.AGI = int(LD.AGI)
			LD.effect = str(LD.effect)

func validateSkillDef(S):
	var K = null
	for key in S:
		K = S[key]
		K.levels = int(K.levels); K.overCost = int(K.overCost); K.powerSource = int(K.powerSource)
		validateSkillLevelDef(K.levelData)
		#print(K)
