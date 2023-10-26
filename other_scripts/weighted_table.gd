class_name  WeightedTable

var items: Array[Dictionary] = [];
var weight_sum = 0

func add_item(name: String, item, weight: int):
	items.append({"name": name, "item": item, "weight": weight})
	weight_sum += weight


func choose_item():
	var random_weight = randi_range(1, weight_sum)
	var iteration_sum = 0
	
	for item in items:
		iteration_sum += item.weight
		if(random_weight <= iteration_sum):
			return item.item


func change_item_weight(name: String, new_weight: int):
	for item in items:
		if(item.name == name):
			item.weight = new_weight
	
	_update_weight_sum()


func get_item_weight(name: String):
	var chosen_weight = 1
	
	for item in items:
		print(item.name, "||", name)
		if(item.name == name):
			chosen_weight = item.weight
	
	return chosen_weight


func get_specific_item(name: String):
	var chosen_item = "If you're reading this, the get item function didnt get your item, dont know why."
	
	for item in items:
		if(item.name == name):
			chosen_item = item
	
	return chosen_item


func _update_weight_sum():
	weight_sum = 0
	for item in items:
		weight_sum += item.weight
