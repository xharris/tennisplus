extends Resource
class_name Visitor

## call [code]accept[/code] on node if it has the method
static func visit_any(node: Node, visitors: Array[Visitor]):
    if node.has_method("accept"):
        for v in visitors:
            node.accept(v)

func visit():
    pass
