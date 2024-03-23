using MaximumIndependentSet
using Graphs
using Test
using Random

function test_xiao_nagamochi(g::SimpleGraph)
    status, sol = mis_xiao_nagamochi(g)
    return status == 0 && isfeasible(sol, g)
end

function test_heuristic(g::SimpleGraph)
    status, sol = mis_heuristic(g)
    return isfeasible(sol, g)
end

function test_mip(g::SimpleGraph)
    status, sol = mis_mip(g)
    return status == 0 && isfeasible(sol, g)
end

function isfeasible(sol::Vector{Int64}, g::SimpleGraph)
    return all(!has_edge(g, u, v) for u in sol for v in sol if u < v)
end

@testset "XiaoNagamochi" begin
    for seed in 1:3
        rng = MersenneTwister(seed)
        g = random_regular_graph(100, 5; rng = rng)
        @test test_xiao_nagamochi(g)
    end
end

@testset "Heuristic" begin
    for seed in 1:3
        rng = MersenneTwister(seed)
        g = random_regular_graph(100, 5; rng = rng)
        @test test_heuristic(g)
    end
end

@testset "MIP" begin
    for seed in 1:3
        rng = MersenneTwister(seed)
        g = random_regular_graph(100, 5; rng = rng)
        @test test_mip(g)
    end
end

