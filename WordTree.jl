module WordTree
export Node, haschild, getchild, parsefile

struct Node
    letter::AbstractChar
    children::AbstractDict{Char, Node}
    isword::Bool

    Node() = new('\0', Dict{Char, Node}(), false)
    Node(letter::AbstractChar, isword::Bool=false) = new(letter, Dict{Char, Node}(), isword)
    Node(letter::AbstractChar, children::AbstractDict{Char, Node}, isword::Bool=false) = new(letter, children, isword)
end

haschild(node::Node, letter::AbstractChar)::Bool = haskey(node.children, letter)
getchild(node::Node, letter::AbstractChar)::Node = get(node.children, letter, nothing)
function addchild!(node::Node, child::Node)::Nothing 
    node.children[child.letter] = child
    nothing
end

function addword(root::Node, word::AbstractString)
    current_node::Node = root
    lastchar::AbstractChar = word[lastindex(word)]
    init::AbstractString = first(word, length(word) - 1)
    for letter in init
        if haschild(current_node, letter)
            current_node = getchild(current_node, letter)
        else
            next_node::Node = Node(letter)
            addchild!(current_node, next_node)
            current_node = next_node
        end
    end
    if !haschild(current_node, lastchar)
        addchild!(current_node, Node(lastchar, true))
    end
end

include("WordTreeDictIO.jl")

end