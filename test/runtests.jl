using MaximumIndependentSet
using Graphs
using Test
using Random

function test_mis(g::SimpleGraph)
    sol = MaximumIndependentSet.max_indep_set(g)
    return true
end

@testset "Random Test" begin
    for seed in 1:10
        rng = MersenneTwister(seed)
        g = random_regular_graph(100, 5; rng = rng)
        @test test_mis(g)
    end
end

