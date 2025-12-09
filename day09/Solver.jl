module Solver
using Test
using AoC
using AoC.Utils
using AoC.Utils.Geometry
using ProgressMeter
using LinearAlgebra

function parse_input(raw_data)
    ints.(lines(raw_data))
end
export parse_input


function area(c1, c2)
    diffs = abs.(c1 - c2) .+ 1
    prod(diffs)
end

function area(tup::Tuple)
    area(tup...)
end

function solve1(parsed)
    max_size = 0
    for c1 in parsed
        for c2 in parsed
           # @show (c1, c2)
            siz = area(c1, c2)
            if siz > max_size
                max_size = siz
            end
        end
    end
    max_size
end
export solve1

function mysign(x)
    if iszero(x)
        return 1
    else
        return sign(x)
    end
end

function solve2(parsed)
    pparsed = Point2D.(parsed)
    @show length(pparsed)
    len = length(pparsed)
    start = pparsed[2]
    start_modx = false
    start_mody = false
    for i in 1:len
        j = i == len ? 1 : i + 1
        diff = to_vec(pparsed[j] - pparsed[i])
        p = pparsed[i]
        #println("going from $(pparsed[i]) to $(pparsed[j])")
        #@show diff
        if diff[1] == 0
            #println("only y-difference")
            for k in 1:abs(diff[2])
                p += Point2D(0, sign(diff[2]))
                push!(pparsed, p)
                if !start_mody
                    start += Point2D(0, -sign(diff[2]))
                    start_mody = true
                end
            end
            #display(pparsed)
        elseif diff[2] == 0
            #println("only x difference")
            for k in 1:abs(diff[1])
                p += Point2D(sign(diff[1]), 0)
                push!(pparsed, p)
                if !start_modx
                    start += Point2D(sign(diff[1]), 0)
                    start_modx = true
                end
            end
            #display(pparsed)
        end
    end
    points_as_cart = Set([CartesianIndex(p...) for p in pparsed])
    println("parsed has $(length(parsed)) elems, point set has $(length(points_as_cart))")
    lck = ReentrantLock()
    max_size = 0
    c1c2 = []
    for (i1, c1) in enumerate(parsed), i2 in i1+1:length(parsed)
        push!(c1c2, (c1, parsed[i2]))
    end
    sort!(c1c2, by=area, rev=true)
    size_p1 = solve1(parsed)
    size_p1 = 3000000000
    filter!(x->area(x)<=size_p1, c1c2)
    @showprogress Threads.@threads :greedy for (c1, c2) in c1c2
        (minx, maxx), (miny, maxy) = [extrema([c1[i], c2[i]]) for i in 1:2]
        #@show (minx, maxx) (miny, maxy)
        siz = area(c1, c2)
        #@show siz
        print("\r$siz")
        @lock lck if !(siz > max_size)
            println("$c1 to $c2 is too small")
            continue
        end
        c1cart = CartesianIndex(c1...)
        c2cart = CartesianIndex(c2...)
        checkfunc(pos) = (pos != c1cart) && (pos != c2cart) && (pos in points_as_cart)

        upper_right = false
        lower_left = false
        top_boundary = CartesianIndices((minx:maxx, miny:miny))
        any(checkfunc, top_boundary) && (upper_right = true)
        if !upper_right
            right_boundary = CartesianIndices((maxx:maxx, miny:maxy))
            any(checkfunc, right_boundary) && (upper_right = true)
        end
        if !upper_right
            #println("rejecting because upper right")
            continue
        end
        bottom_boundary = CartesianIndices((minx:maxx, maxy:maxy))
        any(checkfunc, bottom_boundary) && (lower_left = true)
        if !lower_left
            left_boundary = CartesianIndices((minx:minx, miny:maxy))
            any(checkfunc, left_boundary) && (lower_left = true)
            #println("$left_boundary makes lower_left $lower_left")
        end
        if lower_left
            #println("fulfills condition on lower_left with left_boundary and $bottom_boundary")
            else
                continue
            end
        inside = CartesianIndices((minx+1:maxx-1, miny+1:maxy-1))
        iszero(length(inside)) && continue
        diag1 = diag(inside)
        (any(checkfunc, diag1)) && continue
        diag2 = (inside[i, end+1-i] for (i, j) in zip(axes(inside, 1), reverse(axes(inside, 2))))
        any(checkfunc, diag2) && continue
        diag3 = diag(inside, -(-(size(inside)...)))
        (any(checkfunc, diag3)) && continue
        diag4 = (inside[end+1-j, j] for (i, j) in zip(axes(inside, 1), reverse(axes(inside, 2))))
        any(checkfunc, diag2) && continue
        println(size(inside), length(inside))
        hor = inside[:, size(inside,2)÷2+1]
        any(checkfunc, hor) && continue
        vert = inside[size(inside,1)÷2+1, :]
        any(checkfunc, hor) && continue
        @time(any(in(points_as_cart), inside)) && continue
        @lock lck (max_size = max(max_size, siz))
        println("accepted rectangle from $c1 to $c2 with size $siz")
        #return max_size
    end
    max_size
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
"""
testanswer_1 = 50
testanswer_2 = 24
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
