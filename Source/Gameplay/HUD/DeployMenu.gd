extends TextureRect

class_name DeployMenu

onready var troops_range = $Info/TroopsRange
onready var country_label = $Info/Country

var country: Country = null

signal deployed

func _ready():
	add_troops(7)

func add_troops(troops: int, c: Country = null):
	troops_range.max_value = troops
	troops_range.value = troops
	country = c
	if troops == 1:
		troops_range.suffix = "troop"
	else:
		troops_range.suffix = "troops"
	if country:
		country_label.text = "To " + country.get_name()

func cancel():
	GamePlay.game.active_player.overlay.hide()
	hide()

func deploy():
	emit_signal("deployed", troops_range.value, country)
	country = null
	hide()

func value_changed(value):
	if value == 1:
		troops_range.suffix = "troop"
	else:
		troops_range.suffix = "troops"

