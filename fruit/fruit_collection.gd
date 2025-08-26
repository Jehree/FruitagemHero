extends Resource
class_name FruitCollection

@export var name: String = "Unamed Collection"
@export var selection_weight: float

##If empty, ALL fruit are allowed
@export var fruit_whitelist: Array[FruitStats]:
	get:
		if not fruit_whitelist.is_empty():
			return fruit_whitelist
		
		return AllFruitStatsContainer.stats

@export var fruit_blocklist: Array[FruitStats]

var fruit: Array[FruitStats]:
	get:
		return fruit_whitelist.filter(_is_not_blocked)


func _is_not_blocked(stats: FruitStats) -> bool:
	return not fruit_blocklist.has(stats)


static func get_sum_of_selection_weights(collections: Array[FruitCollection]) -> float:
	var sum: float = 0
	
	for c in collections:
		sum += c.selection_weight
	
	return sum


static func get_random_collection(collections: Array[FruitCollection]) -> FruitCollection:
	var sum_of_weights: float = get_sum_of_selection_weights(collections)
	var rand: float = randf_range(0, sum_of_weights)
	
	var selection_sum: float = 0
	for c in collections:
		selection_sum += c.selection_weight
		
		if selection_sum < rand: continue
		
		return c
	
	printerr("Failed to get random FruitCollection. Are Selection Weights set properly?")
	return null
