module Solver
using Test
using AoC
using AoC.Utils
using LinearAlgebra

function parse_input(raw_data)
    coords = [CartesianIndex(ints(line)...) for line in lines(raw_data)]
end
export parse_input

function get_sizes(circuit_dict)
    vs = collect(values(circuit_dict))
    vcounts = zeros(Int, length(vs))
    for v in vs
        vcounts[v] += 1
    end
    vcounts
end

function solve1(parsed)
    distmat = triu([norm(Tuple(r1 - r2)) for r1 in parsed, r2 in parsed])
    matidcs = CartesianIndices(distmat)
    circuits = Dict(idx=>idx for (idx, pos) in enumerate(parsed))
    n_connect = 0
    to_connect = length(parsed) == 20 ? 10 : 1000
    linear_dist = vec(distmat)
    dist_sort = sortperm(linear_dist)
    dist_sort = dist_sort[linear_dist[dist_sort] .> 0]
    counter = 1
    connections = Set()
    for counter in eachindex(dist_sort)
        closest_pair = matidcs[dist_sort[counter]]
        x, y = Tuple(closest_pair)
        x, y = sort([x, y], by=v->count(==(circuits[v]), values(circuits)))
        if (x, y) in connections
            continue
        end
        indices_to_replace = [k for (k, v) in circuits if v == circuits[x]]
        for k in indices_to_replace
            circuits[k] = circuits[y]
        end
        n_connect += 1
        n_connect == to_connect && break
        push!(connections, (x, y))
    end
    vcounts = get_sizes(circuits)
    *(sort(vcounts, rev=true)[begin:3]...)
end
export solve1


function solve2(parsed)
    distmat = triu([norm(Tuple(r1 - r2)) for r1 in parsed, r2 in parsed])
    matidcs = CartesianIndices(distmat)
    circuits = Dict(idx=>idx for (idx, pos) in enumerate(parsed))
    n_connect = 0
    linear_dist = vec(distmat)
    dist_sort = sortperm(linear_dist)
    dist_sort = dist_sort[linear_dist[dist_sort] .> 0]
    counter = 1
    connections = Set()
    for counter in eachindex(dist_sort)
        closest_pair = matidcs[dist_sort[counter]]
        x, y = Tuple(closest_pair)
        x, y = sort([x, y], by=v->count(==(circuits[v]), values(circuits)))
        if (x, y) in connections
            continue
        end
        indices_to_replace = [k for (k, v) in circuits if v == circuits[x]]
        for k in indices_to_replace
            circuits[k] = circuits[y]
        end
        n_connect += 1
        if count((!)∘iszero, get_sizes(circuits)) == 1
            @debug("need $n_connect connections to connect all")
            return (Tuple(parsed[x])[1] * Tuple(parsed[y])[1])
        end
        push!(connections, (x, y))
    end
    error("could not join all together")
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
"""
testanswer_1 = 40
testanswer_2 = 25272
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
