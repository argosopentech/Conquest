extends Node

class_name StateMachine

var player_states = {
	"placement": load("res://Source/Gameplay/StateMachine/PlayerStates/PlacementState.gd"),
	"attack": load("res://Source/Gameplay/StateMachine/PlayerStates/AttackState.gd"),
	"draft": load("res://Source/Gameplay/StateMachine/PlayerStates/DraftState.gd"),
	"fortify": load("res://Source/Gameplay/StateMachine/PlayerStates/FortifyState.gd"),
}

var game = null

func _ready():
	setup_game()

func setup_game():
	game = get_tree().get_nodes_in_group("game")
	if game.size() > 0:
		game = game[0]
	else:
		game = null

func enter(player):
	pass

func handle_input(player, input: InputEvent):
	return null

func update(player):
	pass

func exit(player):
	pass
