function mis_mip(g::SimpleGraph; optimizer = GLPK.Optimizer, time_limit = typemax(Float64))::Tuple{Int64, Vector{Int64}}
    m = Model(optimizer)
    @variable(m, x[1:nv(g)], Bin)
    @constraint(m, packing[e in edges(g)], x[src(e)] + x[dst(e)] <= 1)
    @objective(m, Max, sum(x))

    if time_limit < typemax(Float64)
        set_time_limit_sec(m, time_limit)
    end
    
    function cutcb(cb)
        xvals = callback_value.(cb, x)
        let
            sol = maximum_weighted_clique_heuristic(g, xvals) 
            viol = sum(xvals[i] for i in sol) - 1
            if viol > 1e-1
                con = @build_constraint(sum(x[u] for u in sol) <= 1)
                MOI.submit(m, MOI.UserCut(cb), con)
                return
            end
        end
    end

    MOI.set(m, MOI.UserCutCallback(), cutcb)
    
    optimize!(m)
    jump_status = termination_status(m)
    sol = Int64[]
    status = 1
    if has_values(m)
        xval = round.(Int64, value.(x))
        sol = [n for n in 1:nv(g) if xval[n] > 0]
    end
    if jump_status == MOI.OPTIMAL
        status = 0
    end
    return status, sol
end

function maximum_weighted_clique_heuristic(g::SimpleGraph{Int64}, weights)
    nnodes = nv(g)
    cands = filter(t -> weights[t] > 1e-7, collect(vertices(g)))
    zcands = setdiff(collect(1: nnodes), cands)
    sol = Int64[]
    while length(cands) > 1
        deg = zeros(Int64, nnodes)
        for u in cands
            deg[u] = sum(has_edge(g, u, v) for v in cands)
        end
        sort!(lt = (u, v) -> deg[u] * weights[u] > deg[v] * weights[v], cands)
        u = popfirst!(cands)
        push!(sol, u)
        torem = [u]
        for v in cands
            if v != u && !has_edge(g, u, v)
                push!(torem, v)
            end
        end
        setdiff!(cands, torem)
    end
    if !isempty(cands) push!(sol, cands[1])
    end
    sort!(sol)
    fill_clique!(sol, g, zcands)
    return sol
end

function fill_clique!(sol, g::SimpleGraph{Int64}, zcands)::Vector{Int64}
    sort!(zcands; lt = (u, v) -> degree(g, u) > degree(g, v))
    while !isempty(zcands)
        u = popfirst!(zcands)
        if degree(g, u) < length(sol) continue end
        nope = false
        for v in sol
            if !has_edge(g, u, v)
                nope = true
                break
            end
        end
        if !nope
            push!(sol, u)
        end
    end
    return sol
end

