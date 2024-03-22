module MaximumIndependentSet
    using MaximumIndependentSet_jll
    using CxxWrap
    using Graphs
    
    include("mis.jl")

    @wrapmodule () -> joinpath("", "libmis")

    function __init__()
        @initcxx
    end
end # module MaximumIndependentSet
