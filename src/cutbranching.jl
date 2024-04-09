function mis_cut_branching(g::SimpleGraph)::Tuple{Int64, Vector{Int64}}
    if is_connected(g)
        status, sol = mis_cut_branching_connected(g)
        return status, sol
    else
        sol = Int64[]
        CC = connected_components(g)
        for c in CC
            gc, vmap = induced_subgraph(g, c)
            if ne(gc) == 0 union!(sol, c)
            else
                status, sol_c = mis_cut_branching_connected(gc)
                union!(sol, vmap[sol_c])
            end
        end
        return 0, sol
    end
end

function mis_cut_branching_connected(g::SimpleGraph)::Tuple{Int64, Vector{Int64}}
    if ne(g) > 0
        _src = [Int32(src(e)) for e in edges(g)]
        _dst = [Int32(dst(e)) for e in edges(g)]
        _sol = zeros(Int32, nv(g))
        MaximumIndependentSet.CutBranching.max_indep_set(_src, _dst, _sol)
        sol = [v for v in 1:nv(g) if _sol[v] == 1]
        return 0, sol
    else
        sol = collect(1:nv(g))
        return 0, sol
    end
end