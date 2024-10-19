extends CardState

const DRAG_MINIMUM_THRESHOLD := 0.05

var minimum_drag_time_elapsed := false

func enter() -> void:
	#grabs the first node in ui_layer group and saves it to ui_layer
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	#reparent current ui to ui node
	if ui_layer:
		card_ui.reparent(ui_layer)
	#For debugging purposes
	card_ui.color.color = Color.NAVY_BLUE
	card_ui.state.text = "DRAGGING"
	
	#meant to fix a bug where by clicking a card and dragging to fast would reset the card
	minimum_drag_time_elapsed = false
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func():minimum_drag_time_elapsed = true)

#transitioning to the release state or back to the base state
func on_input(event: InputEvent) -> void:
	var single_targeted := card_ui.card.is_single_targeted()
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	if single_targeted and mouse_motion and card_ui.targets.size() > 0:
		transition_requested.emit(self, CardState.State.AIMING)
		return
	
	#if mouse is moving the card should reposition accordingly
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
	
	#if they wish to cancel the dragging state it should transition back to the base state
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	#else if they confirm should then transition to released state
	elif minimum_drag_time_elapsed and confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
	
