# MaximumIndependentSet.jl
Algorithms for Maximum Independent Set, including:
1. [Xiao and Nagamochi (2017)](https://doi.org/10.1016/j.ic.2017.06.001)'s branch-and-bound method.
2. A simple MIP-based solution.
3. A simple and extremely fast heuristic.

## Minimal example
```julia
using Graphs
using MaximumIndependentSet
using Random

seed = 16031954
rng = MersenneTwister(seed) # Initialize a random number generator with the given seed
g = random_regular_graph(100, 5; rng = rng) # Generate a random graph of 100 nodes and degree 5 for each node
status, sol = mis_xiao_nagamochi(g) # Solve the MIS and return an optimal solution
status, sol = mis_heuristic(g) # Find a feasible solution using a greedy heuristic
status, sol = mis_mip(g) # Solve the MIS using a MIP. It uses GLPK by default, but other solvers can be passed through the keyword argument `optimizer`. A time limit can be passed through the keyword argument `time_limit`
```

## Return values
ALl three methods return a `Tuple{Int64, Vector{Int64}}`. The first return value (namely `status`) takes the value 0 if the solution found is proven optimal, 1 otherwise. The second return value (namely `sol`) contains the solution found. 