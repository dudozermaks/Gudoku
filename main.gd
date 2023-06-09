extends Control

var time : float
var timer_stop : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	%Field.new_field_loaded.connect(_reset_everything)


func generate_new_field():
	%Field.generate_new_field()



func _reset_everything():
	time = 0
	timer_stop = false

	%CheckLabel.visible = false
	%DifficultyLabel.text = "Difficulty: "
	# export only initial cells
	print(%Field.field_to_string(true))
	%DifficultyLabel.text += str(Globals.sudoku_generator.get_difficulty(%Field.field_to_string(true)))


func _process(delta):
	_update_time(delta)


func _update_time(delta : float):
	if !timer_stop:
		time += delta
	var minutes := time / 60
	var seconds := fmod(time, 60)
	# var milliseconds := time * 100
	%TimerLabel.text = "%02d:%02d" % [minutes, seconds]


func _on_check_button_up():
	var is_solved = %Field.validate()

	if is_solved == Globals.VALIDATE.UNSOLVED:
		%CheckLabel.text = "Unsolved"
		%CheckLabel.add_theme_color_override("font_color", Color.GRAY)

	elif is_solved == Globals.VALIDATE.WRONG_SOLVED:
		%CheckLabel.text = "Solved wrong"
		%CheckLabel.add_theme_color_override("font_color", Color.RED)

	elif is_solved == Globals.VALIDATE.RIGHT_SOLVED:
		%CheckLabel.text = "Solved right"
		%CheckLabel.add_theme_color_override("font_color", Color.GREEN)
		timer_stop = true
		%GenerateNewButton.grab_focus()

	%CheckLabel.visible = true

	if is_solved != Globals.VALIDATE.RIGHT_SOLVED:
		var hide_label_timer = get_tree().create_timer(10)
		hide_label_timer.timeout.connect(
			func ():
				%CheckLabel.visible = false
		)


func _on_generate_new_button_up():
	generate_new_field()


func _on_field_all_cells_completed():
	%CheckButton.emit_signal("button_up")


func _on_pencil_button_toggled(button_pressed):
	Globals.is_pencil_active = button_pressed


func _on_clear_button_up():
	get_tree().call_group("cells", "clear_if_not_disabled")


func _on_export_button_up():
	DisplayServer.clipboard_set(%Field.field_to_string())


func _on_save_button_up():
	%Field.save_to_file()

