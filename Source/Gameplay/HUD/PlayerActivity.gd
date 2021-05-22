extends TextureRect

class_name PlayerActivity

onready var activity_label = $Label

signal queue_freed

func _ready():
	yield(get_tree().create_timer(3), "timeout")
	emit_signal("queue_freed")
	queue_free()

func set_activity(activity):
	var activity_size_before = activity_label.rect_size
	activity_label.text = activity
	var activity_size_difference = activity_label.rect_size - activity_size_before
	rect_size += activity_size_difference
	rect_min_size = rect_size

func get_activity():
	return activity_label.text

