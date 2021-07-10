extends Control


func _ready():
	$Overlay/JoinCodeMenu.hide()


func _on_Cancel_pressed():
	get_tree().change_scene("res://Source/Main/Main.tscn")


func _on_JoinCode_pressed():
	$Overlay/JoinCodeMenu.show()


func _on_Refresh_pressed():
	pass # Replace with function body.
