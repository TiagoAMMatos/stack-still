extends Node

var music_player
var sfx_player

var master_volume = 1.0
var music_volume = 1.0
var sound_effects_volume = 1.0


const music = [
	preload("res://assets/music/Juhani Junkala [Chiptune Adventures] 1. Stage 1.ogg"),
	preload("res://assets/music/Juhani Junkala [Chiptune Adventures] 2. Stage 2.ogg"),
	preload("res://assets/music/Juhani Junkala [Chiptune Adventures] 4. Stage Select.ogg"),
]

const sound_effects = [
	preload("res://assets/sound_effects/click_4.ogg"),
	preload("res://assets/sound_effects/click_2.ogg"),
	preload("res://assets/sound_effects/ding_deep.ogg"),
	preload("res://assets/sound_effects/negative_sound_volumefixed.ogg"),
	preload("res://assets/sound_effects/clock-1_volumefixed.ogg"),
]

var level_paths = [
	"res://levels/level_01.tscn", 
	"res://levels/level_02.tscn", 
	"res://levels/level_03.tscn", 
	"res://levels/level_04.tscn",
	
	"res://levels/level_05.tscn",
	"res://levels/level_06.tscn", 
	"res://levels/level_07.tscn", 
	"res://levels/level_08.tscn",
	
	"res://levels/level_09.tscn", 
	"res://levels/level_10.tscn",
	"res://levels/level_11.tscn", 
	"res://levels/level_12.tscn", 
]

var completed_levels = 0
var current_level_idx = 0

func _ready():
	# Setup music player
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = music[0]
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.play()
	
	# Setup sound effect player
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	sfx_player.process_mode = PROCESS_MODE_ALWAYS
	
	# Load data
	load_from_disk()
	load_config()
	
	# Setup volume
	set_master_volume()
	set_music_volume()
	set_sound_effects_volume()
	

func save_to_disk():
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_64(completed_levels)
	file.close()

func save_config():
	var file = FileAccess.open("user://config.dat", FileAccess.WRITE)
	
	file.store_8(((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)))
	file.store_64(master_volume)
	file.store_64(music_volume)
	file.store_64(sound_effects_volume)
	
	file.close()


func save_temp_screenshot():
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("screenshots"):
		dir.make_dir("screenshots")
	var image = get_viewport().get_texture().get_image()
	image.save_png("user://temp.png")
	

func save_screenshot():
	var dir = DirAccess.open("user://")
	var date := Time.get_datetime_dict_from_system()
	var date_string = "{year}-{month}-{day}_{hour}-{minute}-{second}".format(date)
	var file_path = "user://screenshots/level{level}_{date}.png".format({"level":GameData.current_level_idx+1, "date":date_string})
	dir.copy("user://temp.png", file_path)
	var global_path = ProjectSettings.globalize_path("user://screenshots/")
	OS.shell_open(global_path)
	

func load_from_disk():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	if file == null:
		return
	
	completed_levels = file.get_64()
	file.close()

func load_config():
	var file = FileAccess.open("user://config.dat", FileAccess.READ)
	
	if file == null:
		return
	
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (file.get_8()) else Window.MODE_WINDOWED
	master_volume = file.get_64()
	music_volume = file.get_64()
	sound_effects_volume = file.get_64()
	
	file.close()
	

func reset_progress():
	completed_levels = 0
	current_level_idx = 0
	save_to_disk()
	
	
func set_master_volume():
	var _bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(_bus, linear_to_db(master_volume))


func set_music_volume():
	var player:AudioStreamPlayer = GameData.music_player
	player.volume_db = linear_to_db(music_volume)
	
	
func set_sound_effects_volume():
	var player:AudioStreamPlayer = GameData.sfx_player
	player.volume_db = linear_to_db(sound_effects_volume)


func get_current_level():
	return level_paths[current_level_idx]
