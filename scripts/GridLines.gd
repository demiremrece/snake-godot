extends Node2D

onready var grid: Grid = get_parent() as Grid

export var line_color: Color
export var line_thickness: int = 1

func _draw():
	for i in range(grid.GRID_SIZE.x):
		var start_point: Vector2 = Vector2(i * grid.cell_size.x, 0)
		var end_point: Vector2 = Vector2(i * grid.cell_size.x, grid.GRID_SIZE.y * grid.cell_size.y)
		draw_line(start_point, end_point, line_color, line_thickness)
		
	for i in range(grid.GRID_SIZE.y):
		var start_point: Vector2 = Vector2(0, i * grid.cell_size.y)
		var end_point: Vector2 = Vector2(grid.GRID_SIZE.x * grid.cell_size.x, i * grid.cell_size.y)
		draw_line(start_point, end_point, line_color, line_thickness)
