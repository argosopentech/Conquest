extends TextureRect

class_name PlayerActivity

@onready var activity_label = $Label

signal queue_freed

func _ready():
	await get_tree().create_timer(3).timeout
	emit_signal("queue_freed")
	queue_free()

func set_activity(activity):
	var activity_size_before = activity_label.size
	activity_label.text = activity
	var activity_size_difference = activity_label.size - activity_size_before
	size += activity_size_difference
	custom_minimum_size = size

func get_activity():
	return activity_label.text

