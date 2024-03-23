module MaximumIndependentSet
    using MaximumIndependentSet_jll
    using CxxWrap
    using Graphs
    using PrecompileTools
    
    include("mis.jl")

    @wrapmodule () -> joinpath("", "libmis")

    function __init__()
        @initcxx
    end

    @setup_workload begin
        for seed in 1:2
            @compile_workload begin
                redirect_stdout(devnull) do
                    g = random_regular_graph(20, 5; seed = seed)
                    max_indep_set(g)
                end
            end
        end
    end 
end # module MaximumIndependentSet
