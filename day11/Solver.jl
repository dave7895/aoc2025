module Solver
using Test
using AoC
using AoC.Utils
using Graphs
using AoC.Utils.Graphs
import AoC.Utils.Graphs: neighbours
using ProgressMeter

function parse_input(raw_data)
    d = Dict(s[1]=>split(s[2]) for s in split.(lines(raw_data), ':', keepempty=false))
    d["out"] = []
    d
end
export parse_input

function neighbours(g, s::AbstractString)
    g[s]
end

function solve1(parsed)
    @show parsed
    haskey(parsed, "you") || return
    paths = possible_paths(parsed, "you", "out")
    @show paths
    length(paths)
end
export solve1

let cache = Dict()
    global function count_paths(g, target, n, seen_dac, seen_fft)
        n == "svr" && empty!(cache)
        thiskey = (n, seen_dac || (n == "dac"), seen_fft || (n == "fft"))
        get!(cache, thiskey) do
            n == target && return (seen_dac && seen_fft)
            sum(count_paths(g, target, next_n, thiskey[2:3]...) for next_n in g[n])
        end
    end
end


function solve2(parsed)
    #=paths = possible_paths(parsed, "svr", "out")
    count(paths) do pth
        "dac" in pth && "fft" in pth
    end=#
    #=str_int_dict = Dict(s=>i for (i, s) in enumerate(union(keys(parsed), values(parsed))))
    g = DiGraph(length(str_int_dict))
    for k in keys(parsed)
        s = str_int_dict[k]
        for dstr in parsed[k]
            d = str_int_dict[dstr]
            add_edge!(g, s, d)
        end
    end
    #return g, str_int_dict
    display(g)
    wcc = weakly_connected_components(g)
    display(g[wcc[argmax(length.(wcc))]])
    @show count(>(1)∘length, weakly_connected_components(g))
    sum = 0
    cutoff = 15
    @showprogress for i1 in ["dac", "fft"], i2 in ["dac", "fft"]
        i1 == i2 && continue
        isempty(a_star(g, str_int_dict[i1], str_int_dict[i2])) && continue
        loc = length(collect(all_simple_paths(g, str_int_dict["svr"], str_int_dict[i1]; cutoff)))
        @show loc
        iszero(loc) && continue
        loc *= length(collect(all_simple_paths(g, str_int_dict[i1], str_int_dict[i2]; cutoff)))
        @show loc
        iszero(loc) && continue
        loc *= length(collect(all_simple_paths(g, str_int_dict[i2], str_int_dict["out"]; cutoff)))
        @show loc
        sum += loc
    end
    sum=#
    count_paths(parsed, "out", "svr", false, false)
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput1 = """
aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out
"""
testinput2 = """
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
"""
testanswer_1 = 5
testanswer_2 = 2
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput2, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
