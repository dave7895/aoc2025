module Solver
using Test
using AoC
using AoC.Utils
using ProgressMeter

function convert_char(c::Char)
    c == '#'
end

function parse_input(raw_data)
    shapes = []
    trees = []
    line_accum = ""
    idx = 0
    at_trees = false
    for line in lines(raw_data)
        if contains(line, 'x')
            at_trees = true
            idx = 1
        end
        if at_trees
            line_ints = ints(line)
            push!(trees, ((line_ints[1:2]...,), line_ints[3:end]))
        else
            if contains(line, ':')
                idx = parse(Int, line[begin:end-1])
                continue
            elseif isempty(line)
                shp = read_as_matrix(line_accum)
                bool_shp = convert_char.(shp)
                push!(shapes, bool_shp) 
                line_accum = ""
            else
                line_accum = line_accum * line * "\n"
            end
        end
    end
    shapes, trees
end
export parse_input

function fits(area, package, position)
    checkbounds(Bool, area, position + CartesianIndex(lastindex(package, 1), lastindex(package, 2))) || return false
    subarea = area[CartesianIndices(package) .+ position]
    #@show area subarea package position
    all(subarea[package] .!= package[package])
end

function fit_packages(area, packages)
    first_p = first(packages)
    p_versions = [first_p, permutedims(first_p), reverse(first_p), permutedims(reverse(first_p))]
    for i in 1:4
        p_version = p_versions[i]
        push!(p_versions, p_version[reverse(begin:end), :])
        push!(p_versions, p_version[:, reverse(begin:end)])
        length(p_versions) > 20 && break
    end
    unique!(p_versions)
    positions = findall(!, area) .- CartesianIndex(1, 1)
    for p in p_versions
        for pos in positions
            if fits(area, p, pos)
                #@warn "$p at $pos fits $area"
                isone(length(packages)) && return true
                #@show area
                thisarea = deepcopy(area)
                subar = @view thisarea[CartesianIndices(p) .+ pos]
                subar[p] .= true
                #@show area
                all_fit = fit_packages(thisarea, packages[2:end])
                if all_fit
                    return true
                end
            end
        end
    end
    return false
end

function solve1(parsed)
    shapes, trees = parsed
    ct = 0
    @showprogress for tree in trees
        #=if iszero(ct)
            ct += 1
            continue
        end=#
        pack_count = tree[2]
        tree_area = falses(tree[1])
        packs = []
        for pack in findall(!iszero, pack_count)
            for _ in range(1, pack_count[pack])
                push!(packs, shapes[pack])
            end
        end
        if sum(count, packs) > length(tree_area)
            continue
        else
            ct += 1
            continue
        end
        if @time fit_packages(tree_area, packs)
            ct += 1
            @info "fits"
        else
            @info "no_fit"
        end
    end
    ct
end
export solve1


function solve2(parsed)
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

4x4: 0 0 0 0 2 0
12x5: 1 0 1 0 2 2
12x5: 1 0 1 0 3 2
"""
testanswer_1 = 2
testanswer_2 = nothing
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
