extends Node2D


# Declare member variables here. Examples:
const scene_food = preload("res://scenes/Food.tscn")
const scene_snake = preload("res://scenes/Snake.tscn")

onready var grid: Grid = get_node("Grid") as Grid

var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
#	randomize()
	setupEntities()

func setupEntities() -> void:
	player = scene_snake.instance() as Node2D
	player.connect("move_triggered", self, "onSnakeMoveTriggered")
	player.connect("new_tail_segment", self, "onSnakeNewTailSegment")
	player.connect("body_segment_move", self, "onSnakeBodySegmentMove")
	add_child(player)
	grid.placeEntityRandom(player)
	
	setupFoodEntity()
	
func setupFoodEntity() -> void:
	var food_instance: Node2D = scene_food.instance() as Node2D
	add_child(food_instance)
	grid.placeEntityRandom(food_instance)

func onSnakeMoveTriggered(entity: Node2D, direction: Vector2) -> void:
	grid.moveEntityInDirection(entity, direction)
	
func onSnakeNewTailSegment(segment: Node2D, segment_pos: Vector2) -> void:
	add_child(segment)
	grid.placeEntity(segment, grid.world_to_map(segment_pos))

func onSnakeBodySegmentMove(segment: Node2D, segment_pos: Vector2) -> void:
	grid.moveEntityToPosition(segment, segment_pos)

func deleteEntitiesOfGroup(name: String) -> void:
	var entities: Array = get_tree().get_nodes_in_group(name)
	for entity in entities:
		entity.queue_free()


func _on_Grid_game_over():
	deleteEntitiesOfGroup("Player")
	deleteEntitiesOfGroup("Food")
	setupEntities()


func _on_Grid_food_eaten(food_entity: Node2D, entity: Node2D):
	if entity.has_method("eatFood"):
		entity.eatFood()
		food_entity.queue_free()
		setupFoodEntity()

