extends Resource
class_name Visitor

## Call [code]accept[/code] on node if it has the method.
## If [code]element[/code] is null, [code]visit()[/code] is called instead.
static func visit_any(element: Node, visitors: Array[Visitor]):
    if not element or element.has_method("accept"):
        for v in visitors:
            v.visit()
            if element:
                element.accept(v)

static func emit_accepted(sig: Signal, visitors: Array[Visitor]):
    for v in visitors:
        sig.emit(v)

func visit():
    pass
