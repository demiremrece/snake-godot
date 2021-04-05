extends TileMap

class_name Grid

signal game_over
signal food_eaten(food_entity, entity)

onready var GRID_SIZE = Vector2(32,24)
onready var HALF_CELL_SIZE = get_cell_size() / 2

var grid: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	setupGrid()

func setupGrid() -> void:
	grid = [];
	for x in range(GRID_SIZE.x):
		grid.append([])
		for y in range(GRID_SIZE.y):
			grid[x].append(null)
			
func getEntityOfCell(grid_pos: Vector2) -> Node2D:
	return grid[grid_pos.x][grid_pos.y] as Node2D	

func setEntityInCell(entity: Node2D, grid_pos: Vector2) -> void:
	grid[grid_pos.x][grid_pos.y] = entity	

func placeEntity(entity: Node2D, grid_pos: Vector2) -> void:
	setEntityInCell(entity, grid_pos)
	entity.set_position(map_to_world(grid_pos) + HALF_CELL_SIZE )
	
func placeEntityRandom(entity: Node2D) -> void:
	var has_random_pos: bool = false
	var random_grid_pos: Vector2
	
	while(!has_random_pos):
		var temp_pos = Vector2(randi() % int(GRID_SIZE.x), randi() % int(GRID_SIZE.y))
		if getEntityOfCell(temp_pos) == null:
			random_grid_pos = temp_pos
			has_random_pos = true
	placeEntity(entity, random_grid_pos)
	

func moveEntityInDirection(entity: Node2D, direction: Vector2):
	var old_grid_pos: Vector2 = world_to_map(entity.position)
	var new_grid_pos: Vector2 = old_grid_pos + direction
	
	if !isCellInsideBounds(new_grid_pos):
		gameOver()
		return
	
	setEntityInCell(null, old_grid_pos)
	
	var entity_of_new_cell: Node2D = getEntityOfCell(new_grid_pos)
	if entity_of_new_cell != null:
		if entity_of_new_cell.is_in_group("Player"):
			gameOver()
		elif entity_of_new_cell.is_in_group("Food"):
			emit_signal("food_eaten", entity_of_new_cell, entity) 
			
	
	placeEntity(entity, new_grid_pos)
	
func moveEntityToPosition(entity: Node2D, new_pos: Vector2) ->void:
	var old_grid_pos: Vector2 = world_to_map(entity.position)
	var new_grid_pos: Vector2 = world_to_map(new_pos) 
	
	setEntityInCell(null, old_grid_pos)
	placeEntity(entity, new_grid_pos)
	entity.set_position(new_pos)

	
func isCellInsideBounds(cell_pos: Vector2) -> bool:
	return cell_pos.x < GRID_SIZE.x and cell_pos.y < GRID_SIZE.y and cell_pos.y >= 0 and cell_pos.x >= 0

func gameOver() -> void:
	setupGrid()
	emit_signal("game_over")
