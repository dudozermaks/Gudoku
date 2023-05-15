extends VBoxContainer 

enum VALIDATE{
	WRONG_SOLVED,
	RIGHT_SOLVED,
	UNSOLVED
}

const board_size = 9
const square_size = 3

func _ready():
	get_node("Line0/Cell0").grab_focus()

func _is_unsolved() -> bool:
	for i in range(0, board_size):
		var line := get_node("Line" + str(i))
		for j in range(0, board_size):
			if line.get_node("Cell" + str(j)).numbers.size() != 1:
				return true
	return false

# line_number [0, 8]
func _validate_line(line_number : int) -> VALIDATE:
		var numbers : Array[int] = []

		var line := get_node("Line" + str(line_number))
		for i in range(0, board_size):
			var cell : Cell = line.get_node("Cell" + str(i))

			if cell.numbers.size() != 1: continue
			if cell.numbers[0] in numbers:
				return VALIDATE.WRONG_SOLVED

			numbers.push_back(cell.numbers[0])

		return VALIDATE.RIGHT_SOLVED

# row_number [0, 8]
func _validate_row(row_number : int) -> VALIDATE:
		var numbers : Array[int] = []

		for i in range(0, board_size):
			var line := get_node("Line" + str(i))
			var cell : Cell = line.get_node("Cell" + str(row_number))
			
			if cell.numbers.size() != 1: continue
			if cell.numbers[0] in numbers:
				return VALIDATE.WRONG_SOLVED

			numbers.push_back(cell.numbers[0])

		return VALIDATE.RIGHT_SOLVED

# square_number [0, 8]
func _validate_square(square_number : int) -> VALIDATE:
		var numbers : Array[int] = [] 

		@warning_ignore("integer_division")
		var first_line_number = (square_number / square_size) * square_size
		var first_cell_number = (square_number % square_size) * square_size

		for line_number in range(first_line_number, first_line_number + square_size):
			var line = get_node("Line" + str(line_number))
			for cell_number in range(first_cell_number, first_cell_number + square_size):
				var cell = line.get_node("Cell" + str(cell_number))

				if cell.numbers.size() != 1: continue
				if cell.numbers[0] in numbers:
					return VALIDATE.WRONG_SOLVED

				numbers.push_back(cell.numbers[0])

		return VALIDATE.RIGHT_SOLVED

func _validate() -> VALIDATE:
	for i in range(0, board_size):
		if  _validate_line(i) == VALIDATE.WRONG_SOLVED or\
				_validate_row(i) == VALIDATE.WRONG_SOLVED or\
				_validate_square(i) == VALIDATE.WRONG_SOLVED:
					return VALIDATE.WRONG_SOLVED

	if _is_unsolved():
		return VALIDATE.UNSOLVED
	return VALIDATE.RIGHT_SOLVED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
