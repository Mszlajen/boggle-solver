
module Table

const range = UnitRange{Int8}(-1, 1)

function searchTable(table::Array{Char, 2},
                    root::Main.WordTree.Node,
                    minLength::Int=5)

    sizeofx = UnitRange{Int8}(1, lastindex(table, 1))
    sizeofy = UnitRange{Int8}(1, lastindex(table, 2))
    passed = Bool[false for x=sizeofx, y=sizeofy]
    word = Char[]
    words = String[]
    for x in sizeofx, y in sizeofy
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
    
    sizeofx = UnitRange{Int8}(1, lastindex(table, 1))
    sizeofy = UnitRange{Int8}(1, lastindex(table, 2))
    words::Array{String} = []
    for x in range, y in range
        xi, yi = index[1] + x, index[2] + y
        if !(xi in sizeofx && yi in sizeofy) || passed[xi, yi]
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