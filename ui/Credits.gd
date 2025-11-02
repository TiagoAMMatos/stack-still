extends Control

const creator_link = "[color=#1EA7E1][url=\"https://github.com/TiagoAMMatos\"]github.com/TiagoAMMatos[/url][/color]"

const licence_text = """
[color=#1EA7E1][url="https://www.kenney.nl/assets/rolling-ball-assets"]"Rolling Ball Assets"[/url][/color] by [color=#1EA7E1][url="https://www.kenney.nl"]Kenney[/url][/color], licenced under [color=#1EA7E1][url="https://creativecommons.org/publicdomain/zero/1.0/"]CC0[/url][/color]
[color=#1EA7E1][url="https://www.kenney.nl/assets/game-icons"]"Game Icons"[/url][/color] by [color=#1EA7E1][url="https://www.kenney.nl"]Kenney[/url][/color], licenced under [color=#1EA7E1][url="https://creativecommons.org/publicdomain/zero/1.0/"]CC0[/url][/color]
[color=#1EA7E1][url="https://www.kenney.nl/assets/ui-pack"]"UI Pack"[/url][/color] by [color=#1EA7E1][url="https://www.kenney.nl"]Kenney[/url][/color], licenced under [color=#1EA7E1][url="https://creativecommons.org/publicdomain/zero/1.0/"]CC0[/url][/color]
[color=#1EA7E1][url="https://opengameart.org/content/4-chiptunes-adventure"]"4 Chiptunes (Adventure)"[/url][/color] by [color=#1EA7E1][url="https://juhanijunkala.com/"]Juhani Junkala[/url][/color], licenced under [color=#1EA7E1][url="https://creativecommons.org/publicdomain/zero/1.0/"]CC0[/url][/color]
[color=#1EA7E1][url="https://opengameart.org/content/ui-sound-effects-button-clicks-user-feedback-notifications"]"UI Sound Effects (Button Clicks, User Feedback, Notifications)"[/url][/color], licenced under [color=#1EA7E1][url="https://creativecommons.org/publicdomain/zero/1.0/"]CC0[/url][/color]
[color=#1EA7E1][url="https://opengameart.org/content/ticking-clock-0"]"Ticking Clock"[/url][/color] by [color=#1EA7E1][url="https://opengameart.org/users/antumdeluge"]Jordan Irwin[/url][/color], licenced under [color=#1EA7E1][url="https://creativecommons.org/publicdomain/zero/1.0/"]CC0[/url][/color]
"""

func _ready():
	# Play background music
	if GameData.music_player.stream != GameData.music[2]:
		GameData.music_player.stream = GameData.music[2]
		GameData.music_player.play()
	
	# Setup text
	var base_text = "[b]Made by:[/b]\n{}\n\n[b]Assets used:[/b]{}\n\n"
	var full_text = base_text.format([creator_link, licence_text], "{}")
	$MarginContainer/VBoxContainer/PanelContainer/RichTextLabel.text = full_text


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://ui/MainMenu.tscn")
		

func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(str(meta))


func _on_ReturnButton_pressed():
	get_tree().change_scene_to_file("res://ui/MainMenu.tscn")
