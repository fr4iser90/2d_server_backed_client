# res://src/core/client/scene/menu/launcher/UIManager.gd
extends Control

# General function to enable/disable UI elements inside a container
func set_container_ui_enabled(container, elements: Dictionary, is_enabled: bool):
	# Apply the visual effect of disabling (graying out)
	container.modulate = Color(1, 1, 1, 1) if is_enabled else Color(0.5, 0.5, 0.5, 1)  # Gray out or reset color

	for element_name in elements.keys():
		var element = container.get_node(element_name)
		if element:
			if element is LineEdit:
				element.editable = is_enabled  # Enable/disable text input for LineEdit
				element.mouse_filter = Control.MOUSE_FILTER_PASS if is_enabled else Control.MOUSE_FILTER_IGNORE  # Block mouse clicks
			elif element is Button or element is CheckButton or element is OptionButton:
				element.disabled = not is_enabled  # Enable/disable buttons and checkboxes
				element.mouse_filter = Control.MOUSE_FILTER_PASS if is_enabled else Control.MOUSE_FILTER_IGNORE  # Block mouse clicks
	# Handle DisconnectButton separately, ensuring it stays interactable when others are disabled
	var disconnect_button = container.get_node("DisconnectButton")
	if disconnect_button:
		disconnect_button.disabled = is_enabled  # Disconnect button should only be enabled when the rest is disabled
		disconnect_button.mouse_filter = Control.MOUSE_FILTER_PASS  # Always allow interaction with DisconnectButton

# Specific container handlers for better readability
func set_login_container_ui_enabled(container, is_enabled: bool):
	var elements = {
		"UsernameInput": LineEdit,
		"PasswordInput": LineEdit,
		"LoginButton": Button,
		"CancelButton": Button
	}
	set_container_ui_enabled(container, elements, is_enabled)

func set_character_container_ui_enabled(container, is_enabled: bool):
	var elements = {
		"MageButton": Button,
		"ArcherButton": Button,
		"KnightButton": Button,
		"LogoutButton": Button
	}
	set_container_ui_enabled(container, elements, is_enabled)

func set_connection_container_ui_enabled(container, is_enabled: bool):
	var elements = {
		"IpPortInput": LineEdit,
		"ConnectButton": Button,
		"AutoConnectCheckBox": CheckButton  # Assuming auto connect is a checkbox
	}
	set_container_ui_enabled(container, elements, is_enabled)
