using DataStructures: Stack

const ui8zero = UInt8(0)
const ui8one = UInt8(1)
const wordchar = '.'
const levelchar = '-'

function parsefile!(root::Node, filename::AbstractString)::Nothing
    for word in eachline(filename)
        length(word) > 1 || continue
        addword(root, word) 
    end
    nothing
end

function parsefile(filename::AbstractString)::Node
    root = Node()
    parsefile!(root, filename)
    root
end

function parsefile!(root::Node, filenames::AbstractArray{S} where S <: AbstractString)::Nothing
   for filename in filenames
        parsefile!(root, filename)
   end
   nothing
end

function parsefile(filenames::AbstractArray{S} where S <: AbstractString)
    root = Node()
    parsefile!(root, filenames)
    root
end

function iteratechildren(file::IO, node::Node, level::UInt8)::Nothing
    for (key, node) in node.children
        save(file, node, level + ui8one)
    end   
    nothing
end

function save(filename::AbstractString, root::Node)::Nothing
    open("$filename.dicc", "w") do file
        iteratechildren(file, root, ui8zero)
    end
    nothing
end

function save(file::IO, node::Node, level::UInt8)::Nothing
    print(file, levelchar ^ level, node.letter, node.isword ? ".\n" : "\n")
    iteratechildren(file, node, level)
    nothing
end

function load(filepath::AbstractString, maxlength::Int=25)::Node
    root::Node = Node()
    stack::Array = Array{Node, 1}(undef, maxlength + 1)
    fathernode::Node = root
    level::Integer = 0
    stack[1] = root
    for line in eachline(filepath)
        level = findlast(levelchar, line)
        chars = line[level+1:lastindex(line)]
        fathernode = stack[level]
        newnode = Node(chars[1], length(chars) == 2)
        addchild!(fathernode, newnode)
        stack[level + 1] = newnode
    end
    root
end