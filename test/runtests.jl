using MaximumIndependentSet
using Graphs
using Test
using Random

function test_mis(g::SimpleGraph)
    sol = MaximumIndependentSet.max_indep_set(g)
    return isfeasible(sol, g)
end

function isfeasible(sol::Vector{Int64}, g::SimpleGraph)
    return all(!has_edge(g, u, v) for u in sol for v in sol if u < v)
end

@testset "Random Test" begin
    for seed in 1:5
        rng = MersenneTwister(seed)
        g = random_regular_graph(100, 5; rng = rng)
        @test test_mis(g)
    end
end

