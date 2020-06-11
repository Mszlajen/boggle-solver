import Base: convert

function Main.convert(::Type{Main.WordTree.Node}, jsonobj::Dict{String, Any})
    WordTree.Node(isnothing(jsonobj["letter"]) ? nothing : jsonobj["letter"][1], 
                convert(AbstractDict{Char, WordTree.Node}, jsonobj["children"]), 
                jsonobj["isword"])
end

function Main.convert(::Type{AbstractDict{Char, Main.WordTree.Node}}, jsonobj::Dict{String, Any})
    ret::AbstractDict{Char, WordTree.Node} = Dict{Char, WordTree.Node}()
    for (k, v) in jsonobj
        ret[k[1]] = v
    end
    ret
end