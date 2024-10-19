class_name CardAiming
extends CardState

#If card moves below a certain threshold it will cancel the movement
const MOUSE_Y_SNAPBACK_THRESHOLD := 138

#when we enter the aiming state
func enter() -> void:
	#color and text for debugging purposes
	card_ui.color.color = Color.WEB_PURPLE
	card_ui.state.text = "AIMING"
	#clear any previous targets, empty the targets array
	card_ui.targets.clear()
	var offset := Vector2(card_ui.parent.size.x / 2, -card_ui.size.y / 2)
	offset.x -= card_ui.size.x / 2
	card_ui.animate_to_position(card_ui.parent.global_position + offset, 0.2)
	card_ui.drop_point_detector.monitoring = false
	Events.card_aim_started.emit(card_ui)
	
func exit() -> void:
	Events.card_aim_ended.emit(card_ui)
	
func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var mouse_at_bottom:= card_ui.get_global_mouse_position().y > MOUSE_Y_SNAPBACK_THRESHOLD
	
	#checks if mouse is at bottom or right mouse is pressed which should return to base state
	if (mouse_motion and mouse_at_bottom) or event.is_action_pressed("right_mouse"):
		transition_requested.emit(self, CardState.State.BASE)
	#if we finish the aiming process -> go to release state
	elif event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse"):
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
