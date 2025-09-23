extends Node

func is_valid_node(node) -> bool:
    return is_instance_valid(node) and node is Node and node.is_inside_tree()
