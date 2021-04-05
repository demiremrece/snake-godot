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
	add_child(player)
	grid.placeEntityRandom(player)
	
	var food_instance: Node2D = scene_food.instance() as Node2D
	add_child(food_instance)
	grid.placeEntityRandom(food_instance)

func onSnakeMoveTriggered(entity: Node2D, direction: Vector2) -> void:
	grid.moveEntityInDirection(entity, direction)
	

func deleteEntitiesOfGroup(name: String) -> void:
	var entities: Array = get_tree().get_nodes_in_group(name)
	for entity in entities:
		entity.queue_free()


func _on_Grid_game_over():
	deleteEntitiesOfGroup("Player")
	deleteEntitiesOfGroup("Food")
	setupEntities()

