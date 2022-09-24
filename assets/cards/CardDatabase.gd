# Letter/Name : [Damage, Word, Draw, Effect, Keyword]
const DATA = {
	"A" : 
		[1, 0, 2, "", []],
	"B" :
		[1, 0, 1, "Burn", ["Burn"]],
	"C" : 
		[0, 0, 3, "", []],
	"D" :
		[1, 0, 2, "+1 Word if not used in the first slot", []],
	"E" : 
		[1, 1, 1, "", []],
	"F" : 
		[1, 0 ,1, "Freeze", ["Freeze"]],
	"G" : 
		[1, 0, 4, "Gold", []],
	"H" :
		[2, 0, 2, "Heal", []],
	"I" : 
		[2, 0, 0, "", []],
	"J" :
		[4, 0, 3, "+200% Damage, -50% Damage to self", []],
	"K" : 
		[10, 0, 0, "End Turn", []],
	"L" : 
		[4, 0, 0, "+2 Damage if next to another L", []],
	"M" : 
		[1, 1, 1, "", []],
	"N" :
		[0, 0, 0, "+50% Damage", []],
	"O" : 
		[1, 0, 0, "+2 Damage if O is the only vowel", []],
	"P" :
		[1, 0, 1, "Paralyze", ["Paralyze"]],
	"Q" : 
		[3, 0, 0, "Draw this Q and another card next turn", []],
	"R" : 
		[1, 0 ,1, "+1 Damage per R", []],
	"S" : 
		[1, 1, 2, "-50% Damage if at the end of the word", []],
	"T" :
		[3, 0, 0, "", []],
	"U" : 
		[3, 0, 0, "End Turn, +100% Damage", []],
	"V" :
		[3, 2, 3, "", []],
	"W" : 
		[1, 0, 1, "Weaken", ["Weaken"]],
	"X" : 
		[6, 0, 0, "", []],
	"Y" : 
		[2, 1, 2, "+100% Damage if not at the end of the word", []],
	"Z" : 
		[3, 1, 4, "", []],
	"Wild" :
		[0, 0, 0, "Any letter", []],
	"Health" :
		[0, 0, 0, "+Health", ["Health"]],
	"Word" :
		[0, 0, 0, "+Word Length", ["Word"]],
	"Hand" :
		[0, 0, 0, "+Hand Size", ["Hand"]],
}
