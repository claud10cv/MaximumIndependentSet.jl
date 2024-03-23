module MaximumIndependentSet
    using MaximumIndependentSet_jll
    using CxxWrap
    using Graphs
    using PrecompileTools
    using JuMP
    using MathOptInterface
    using GLPK

    const MOI = MathOptInterface
    
    include("xiaonagamochi.jl")
    include("mip.jl")
    include("heuristic.jl")

    @wrapmodule () -> joinpath("", "libmis")

    function __init__()
        @initcxx
    end

    @setup_workload begin
        for seed in 1:2
            @compile_workload begin
                redirect_stdout(devnull) do
                    g = random_regular_graph(20, 5; seed = seed)
                    mis_heuristic(g)
                    mis_mip(g; time_limit = 10)
                    mis_xiao_nagamochi(g)
                end
            end
        end
    end 

    export mis_heuristic, mis_mip, mis_xiao_nagamochi
end # module MaximumIndependentSet
