function mis_xiao_nagamochi(g::SimpleGraph)::Tuple{Int64, Vector{Int64}}
    sol = Int64[]
    CC = connected_components(g)
    for c in CC
        gc, vmap = induced_subgraph(g, c)
        if ne(gc) == 0 union!(sol, c)
        else
            _src = [Int32(src(e)) for e in edges(gc)]
            _dst = [Int32(dst(e)) for e in edges(gc)]
            _sol = zeros(Int32, nv(gc))
            MaximumIndependentSet.max_indep_set(_src, _dst, _sol)
            sol_c = [v for v in 1:nv(gc) if _sol[v] == 1]
            union!(sol, vmap[sol_c])
        end
    end
    return 0, sol
end