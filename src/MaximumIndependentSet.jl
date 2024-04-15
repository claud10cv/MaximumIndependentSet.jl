module MaximumIndependentSet
    using Graphs
    using PrecompileTools
    using JuMP
    using MathOptInterface
    using GLPK

    const MOI = MathOptInterface
    
    module XiaoNagamochi
        using CxxWrap
        using MaximumIndependentSet_jll
        @wrapmodule MaximumIndependentSet_jll.get_mis_path
        function __init__()
            @initcxx
        end
    end

    module CutBranching
        using CxxWrap
        using CutBranching_jll
        @wrapmodule CutBranching_jll.get_miscb_path
        function __init__()
            @initcxx
        end
    end

    include("util.jl")
    include("xiaonagamochi.jl")
    include("cutbranching.jl")
    include("mip.jl")
    include("heuristic.jl")

    @setup_workload begin
        for seed in 1:2
            g = random_regular_graph(20, 5; seed = seed)
                @compile_workload begin
                redirect_stdout(devnull) do
                    mis_heuristic(g)
                    mis_mip(g; time_limit = 5)
                    mis_xiao_nagamochi(g)
                    mis_cut_branching(g)
                end
            end
        end
    end 

    export mis_heuristic, mis_mip, mis_cut_branching, mis_xiao_nagamochi
end # module MaximumIndependentSet
