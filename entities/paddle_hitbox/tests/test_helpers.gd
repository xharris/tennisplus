extends Node

# Minimal test helper: a Node with an `accept(v)` method that records visitors
var visited: Array

func _init():
    visited = []

func accept(v):
    visited.append(v)
