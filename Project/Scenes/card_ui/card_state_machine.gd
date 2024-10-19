class_name CardStateMachine
extends Node

#export variable for starting/base state
@export var initial_state: CardState

#storing current state we are in
var current_state: CardState
#for storing all available states in state machine
var states := {}

#init function to call from card UI
func init(card: CardUI) -> void:
	#iterate through all children of state machine check if the current child is a card state or not
	for child in get_children():
		if child is CardState: 
			#if it is add to dictionary of all states we have
			states[child.state] = child
			#and connect the transition requested signal to our own function to handle transition
			child.transition_requested.connect(_on_transition_requested)
			#pass card ui reference to the state itself
			child.card_ui = card
	
	#if we do have an initial state
	if initial_state:
		#we enter that state
		initial_state.enter() 
		#then set current state to that initial state
		current_state = initial_state

#two callback functions for input and gui input
func on_input(event: InputEvent) -> void:
	#if we have an active current state
	if current_state:
		#we call that states corresponding callback function
		current_state.on_input(event)

func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)

#same as above but with on_mouse_entered and exited functions
func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()

func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()

#function to transition from one state to another
func _on_transition_requested(from: CardState, to: CardState.State) -> void:
	#two states should match, if not something wrong happened
	if from != current_state:
		return
		
	#store reference to new state to reference of states
	var new_state: CardState = states[to]
	#if for some reason state does not exit then return from function
	if not new_state:
		return
	#otherwise exit current state
	if current_state:
		current_state._exit()
	
	#enter new state and make current state equal to the new state
	new_state.enter()
	current_state = new_state
