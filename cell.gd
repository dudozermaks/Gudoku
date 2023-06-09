extends Button
class_name Cell

var numbers : Array[int] = []
var is_small : bool = false

signal text_updated

func _input(_event):
	if !has_focus() or disabled:
		return;
	for i in range(1, 10):
		if Input.is_action_just_released(str(i)):
			if Globals.is_pencil_active:
				is_small = true
				if i in numbers:
					numbers.erase(i)
				else:
					numbers.push_back(i)
			else:
				is_small = false
				numbers.clear()
				numbers.push_back(i)
	if (Input.is_action_pressed("erase")):
		numbers.pop_back()

	update_text()

func update_text():
	numbers.sort()
	text = ""

	for i in range(0, numbers.size()):
		text += "%d," % numbers[i]
		if !(i+1) % 3:
			text += "\n"
		else:
			text += " "

	if text.length() >= 2:
		text = text.left(-2)

	if !is_small:
		var big_font_size := theme.get_font_size("big_font_size", "Button")
		add_theme_font_size_override("font_size", big_font_size)
	else:
		remove_theme_font_size_override("font_size")
	
	emit_signal("text_updated")

func disable_if_not_empty():
	if numbers.size() != 0:
		disabled = true
		focus_mode = Control.FOCUS_NONE
	else:
		disabled = false
		focus_mode = Control.FOCUS_ALL

func clear_if_not_disabled():
	if !disabled:
		numbers.clear()
		update_text()

func get_as_short_string() -> String:
	if numbers.size() != 1:
		return "."
	return str(numbers[0])

func get_as_long_string() -> String:
	var res = ""
	for i in range(1, 10):
		if i in numbers:
			res += str(i)
		else:
			res += "."
	return res

func reset():
	numbers.clear()
	disabled = false
	is_small = false
