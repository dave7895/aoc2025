module Solver
using Test
using AoC
using AoC.Utils

function parse_input(raw_data)
    read_as_matrix(raw_data)
end
export parse_input


function solve1(parsed)
    tachyons = Set(findall(==('S'), parsed[1, :]))
    splits = 0
    for row in eachrow(parsed[2:end, :])
        splitters = findall(==('^'), row)
        split_locs = intersect(tachyons, splitters)
        for i in split_locs
            push!(tachyons, i-1)
            push!(tachyons, i+1)
            delete!(tachyons, i)
            splits += 1
        end
    end
    splits
end
export solve1


function solve2(parsed)
    tachyons = Dict(findfirst(==('S'), parsed[1, :])=>1)
    splits = 0
    for row in eachrow(parsed[2:end, :])
        splitters = Set(findall(==('^'), row))
        split_locs = intersect(keys(tachyons), splitters)
        for splitloc in split_locs
            lpath, rpath = splitloc - 1, splitloc + 1
            ntachs = tachyons[splitloc]
            tachyons[lpath] = get(tachyons, lpath, 0) + ntachs
            tachyons[rpath] = get(tachyons, rpath, 0) + ntachs
            #delete!(tachyons, splitloc)
            tachyons[splitloc] = 0
            splits += ntachs
        end
    end
    splits + 1
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
"""
testanswer_1 = 21
testanswer_2 = 40
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
