
module Table

const size = UnitRange{Int8}(1, 5)
const range = UnitRange{Int8}(-1, 1)
function searchTable(table::Array{Char, 2},
                    root::Main.WordTree.Node,
                    minLength::Int=5)

    passed = Bool[false for x=1:5, y=1:5]
    word::Array{Char} = []
    words::Array{String} = []
    for x in size, y in size
        words = union(words, searchChildren(table, (x,y), root, passed, word, minLength))
    end
    words
end

function searchWords(table::Array{Char}, 
                    index::Tuple{Int8, Int8}, 
                    node::Main.WordTree.Node,
                    passed::Array{Bool, 2}, 
                    word::Array{Char},
                    minLength::Int)
    passed[index[1], index[2]] = true
    push!(word, table[index[1], index[2]])
    words::Array{String} = []
    node.isword && minLength <= length(word) && push!(words, join(word))
    words = union(words, searchChildren(table, index, node, passed, word, minLength))
    passed[index[1], index[2]] = false
    pop!(word)
    words    
end

function searchChildren(table::Array{Char}, 
                        index::Tuple{Int8, Int8}, 
                        node::Main.WordTree.Node,
                        passed::Array{Bool}, 
                        word::Array{Char},
                        minLength::Int)
    
    words::Array{String} = []
    for x in range, y in range
        xi, yi = index[1] + x, index[2] + y
        if !(xi in size && yi in size) || passed[xi, yi]
            continue
        end

        char = table[xi, yi]    
        if Main.WordTree.haschild(node, char)
            nextnode = Main.WordTree.getchild(node, char)
            words = union(words, searchWords(table, (xi, yi), nextnode, passed, word, minLength))
        end
    end
    words
end

end