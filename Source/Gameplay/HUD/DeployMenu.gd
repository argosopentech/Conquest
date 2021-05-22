extends TextureRect

class_name DeployMenu

onready var troops_range = $Info/TroopsRange

func _ready():
	add_troops(7)

func add_troops(troops):
	troops_range.max_value = troops
	troops_range.value = troops
