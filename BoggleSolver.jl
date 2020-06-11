include("WordTree.jl")
include("Converters.jl")
include("Table.jl")
using DelimitedFiles: readdlm, writedlm
using JSON

function writeresolved(words::AbstractArray{String}, resolvedPath::AbstractString)
    writedlm(resolvedPath, words)
end

function resolveJSON(tablePath::AbstractString, dictionaryPath::AbstractString, resolvedPath::AbstractString, minLegth::Int=5)::Nothing
    table::Array{Char} = readdlm(tablePath, Char)
    root::WordTree.Node = JSON.parsefile(dictionaryPath) 
    words::Array{String} = Table.searchTable(table, root, minLegth)
    writeresolved(words, resolvedPath)
    nothing
end

function resolveTXT(tablePath::AbstractString, dictionaryPath::AbstractString, resolvedPath::AbstractString, minLegth::Int=5)::Nothing
    table::Array{Char} = readdlm(tablePath, Char) 
    root::WordTree.Node = WordTree.parsefile(dictionaryPath)
    words::Array{String} = Table.searchTable(table, root, minLegth)
    writeresolved(words, resolvedPath)
    nothing
end

function makedictionary(wordsfile::AbstractString, dictfile::AbstractString)::Nothing
    WordTree.savetofile(WordTree.parsefile(wordsfile), dictfile)
    nothing
end