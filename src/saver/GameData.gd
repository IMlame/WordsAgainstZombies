class_name GameData
extends Resource


const SAVE_DIR := "user://saves//"

export var version := 1

export var dungeon_info: Resource = DungeonInfo.new()
export var player_info: Resource = PlayerInfo.new()

func write_savegame(save_num: int) -> void:
	ResourceSaver.save(get_save_path(save_num), self)


static func save_exists(save_num: int) -> bool:
	return ResourceLoader.exists(get_save_path(save_num))


static func load_savegame(save_num: int) -> Resource:
	var save_path := get_save_path(save_num)
	return ResourceLoader.load(save_path, "", true)
	
static func get_save_path(save_num: int) -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_DIR + "save_" + str(save_num) + extension
