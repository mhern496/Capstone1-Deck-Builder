extends Node
class_name CardState

#enum defines a set of named constants
#different states that the card can be in
enum State {BASE, CLICKED, DRAGGING, AIMING, RELEASED}

#define a signal to transition from cardstate to state
signal transition_requested(from: CardState, to: State)

#@export puts this variable to the editor for easier modifying
@export var state: State

#reference to cardui node for doing stuff like moving, changing color, etc.
var card_ui:CardUI

#functions called when either entering a new state or exiting one
func enter() -> void:
	pass
func _exit() -> void:
	pass

#other callback functions for State to use
func on_input(_event: InputEvent) -> void:
	pass

func on_gui_input(_event: InputEvent) -> void:
	pass

func on_mouse_entered() -> void:
	pass

func on_mouse_exited() -> void:
	pass
