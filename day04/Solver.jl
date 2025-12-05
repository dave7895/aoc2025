module Solver
using Test
using AoC
using AoC.Utils

parse_char(c::Char) = c == '@' ? 1 : 0

function parse_input(raw_data)
    mat = read_as_matrix(raw_data)
    parse_char.(mat)
end
export parse_input

function removable(mat)
    num_neighs = zeros(Int8, size(mat))
    dom = CartesianIndices(mat)
    I_f, I_l = first(dom), last(dom)
    Δ = CartesianIndex(1, 1)
    for I in dom
        patch = max(I_f, I-Δ):min(I_l, I+Δ)
        num_neighs[I] = sum(mat[patch]) - mat[I]
    end
    (num_neighs .< 4) .& Bool.(mat)
end

function solve1(parsed)
    rolls = deepcopy(parsed)
    removables = removable(rolls)
    count(removables)
end
export solve1


function solve2(parsed)
    rolls = deepcopy(parsed)
    sum_rem = 0
    last_removed = 1
    while last_removed != 0
        removables = removable(rolls)
        last_removed = count(removables)
        println(last_removed)
        sum_rem += last_removed
        rolls[removables] .= 0
    end
    sum_rem
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
"""
testanswer_1 = 13
testanswer_2 = 43
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
