function mis_heuristic(g::SimpleGraph)::Tuple{Int64, Vector{Int64}}
    weights = ones(Int64, nv(g))
    sol = maximum_weighted_clique_heuristic(complement(g), weights)
    return 1, sol
end