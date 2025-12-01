extends Node2D

var start: Node2D
var end: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var nodes = get_children()
	nodes.sort_custom(order)
	for i in range(nodes.size()):
		var node = nodes[i]
		if i == 0: #First node
			start = node
			node.next.append(nodes[i + 1])
			if nodes[i + 1].branch == "Straight":
				nodes[i + 1].prev.append(node)
		elif i >= nodes.size() - 1: #Last node
			end = nodes[i]
			node.prev.append(nodes[i - 1])
		elif node.branch == "Straight": #It is normal
			var j = i + 1
			while j < nodes.size() && nodes[j].global_position.y != node.global_position.y:
				j += 1
			if j >= nodes.size():
				j = i + 1
				while j < nodes.size() && nodes[j].global_position.x == node.global_position.x:
					j += 1
				node.next.append(nodes[j])
			else:
				node.next.append(nodes[j])
				nodes[j].prev.append(node)
		elif node.branch == "Split": #It is a split
			var j = i + 1
			while nodes[j].global_position.x == node.global_position.x:
				j += 1
			var searching = true
			# Finds the node at the next x value that is greater y, and appends it minus one and it to prev
			while searching:
				if node.global_position.y < nodes[j].global_position.y:
					node.next.append(nodes[j - 1])
					nodes[j - 1].prev.append(node)
					node.next.append(nodes[j])
					nodes[j].prev.append(node)
					searching = false
				j += 1
			node.prev.append(nodes[i - 1])
		elif node.branch == "Merge": #It is a merge
			nodes[i].next.append(nodes[i + 1])
			var j = i - 1
			while nodes[j].global_position.x == node.global_position.x:
				j -= 1
			var searching = true
			# Finds the node at the prev x value that is lesser y, and appends it and it plus one to prev
			while searching:
				if node.global_position.y > nodes[j].global_position.y:
					node.prev.append(nodes[j])
					node.prev.append(nodes[j + 1])
					searching = false
				j -= 1
		else: #Invalid, it should not be any other value
			print("Invalid")


# Compares the x and y values of node a and b
# If a.x is less than b.x return true
# If a.x = b.x repeats the check with a.y and b.y instead
func order(a: Node2D, b: Node2D) -> bool:
	if a.global_position.x < b.global_position.x:
		return true
	elif a.global_position.x > b.global_position.x:
		return false
	else:
		if a.global_position.y <= b.global_position.y:
			return true
		else:
			return false
