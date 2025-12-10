module Solver
using Test
using AoC
using AoC.Utils
using DataStructures
using ProgressMeter
using JuMP, HiGHS

function light_func(c::Char)
    c == '#' ? true : false
end

function parse_input(raw_data)
    parsed = []
    for line in lines(raw_data)
        lights = match(r"\[(.*)\]", line).captures[1]
        lights_bool = light_func.(collect(lights))
        buttons = findall(r"\((\d+)(?:,(\d+))*\)", line)
        buttonsnum = Vector[]
        for but in buttons
            butstr = line[but]
            nums = ints(butstr) .+ 1
            push!(buttonsnum, nums)
        end
        joltages_str = match(r"\{(.*)\}", line, last(last(buttons)))
        joltages = ints(joltages_str[1])
        push!(parsed, (lights_bool, buttonsnum, joltages))
    end
    parsed
end
export parse_input

function is_done(final_lights, press_vec, joltage)
    if joltage
        all(final_lights .== press_vec)
    else
        all(final_lights .== isodd.(press_vec))
    end
end

function neighbours(lights, buttons)
    (lights+but for but in buttons)
end

function find_fewest_presses(final_lights, buttons; joltage=false)
    lights = zeros(Int, length(final_lights))
    q = Queue{AbstractVector}()
    start = deepcopy(lights)
    vecbuttons = map(buttons) do but
        vec = zeros(Int, length(final_lights))
        vec[but] .= 1
        vec
    end
    enqueue!(q, start)
    path = Dict{Any, Tuple{Union{AbstractVector, Nothing}, Int}}()
    path[start] = (nothing, 0)
    while !isempty(q)
        #print("\r$(length(q))")
        v = dequeue!(q)
        if is_done(final_lights, v, joltage)
            npress = path[v][2]
            #println("reached final destination $final_lights with $v and $npress presses")
            return path[v][2]
        end
        for new_state in neighbours(v, vecbuttons)
            if joltage
                #@show new_state final_lights (new_state .> final_lights)
                any(new_state .> final_lights) && continue
            end
            if !haskey(path, new_state)
                path[new_state] = (v, path[v][2] + 1)
                enqueue!(q, new_state)
            else
            end
        end
    end
end
export find_fewest_presses


function solve1(parsed)
    sum = 0
    @showprogress "Solve 1" for (lights, buttons, _) in parsed
        sum += find_fewest_presses(lights, buttons)
    end
    sum
end
export solve1

function solve_joltage_jump(buttonmat, joltages)
    model = Model(HiGHS.Optimizer)
    set_silent(model)
    n = size(buttonmat, 2)
    @variable(model, 0 <= x[1:n], Int)
    @constraint(model, buttonmat*x == joltages)
    @objective(model, Min, sum(x[i] for i in 1:n))
    optimize!(model)
    #print(solution_summary(model))
    sum(value(x[i]) for i in 1:n)
end


function solve2(parsed)
    sum = 0
    @showprogress "Solve 2" for (lights, buttons, joltages) in parsed
        # didn't read only joltage :(
        #sum += find_fewest_presses(lights, buttons)
        vecbuttons = map(buttons) do but
            vec = zeros(Int, length(joltages))
            vec[but] .= 1
            vec
        end
        left_mat = [vecbuttons...;;]
        sum += solve_joltage_jump(left_mat, joltages)
        # don't try to bruteforce it via BFS or other search
        # sum += find_fewest_presses(joltages, buttons; joltage=true)
    end
    sum
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
"""
testanswer_1 = 7
testanswer_2 = 33
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
