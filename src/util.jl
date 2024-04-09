function isfeasible(sol::Vector{Int64}, g::SimpleGraph)::Bool
    return !any(has_edge(g, u, v) for u in sol for v in sol if u < v)
end