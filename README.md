# MaximumIndependentSet.jl
Algorithms for Maximum Independent Set, including:
1. [Xiao and Nagamochi (2017)](https://doi.org/10.1016/j.ic.2017.06.001)'s branch-and-bound method.
2. [Hespe, Lamm, and Schorr (2021)](https://arxiv.org/abs/2102.01540)'s branch-and-bound method.
3. A simple MIP-based solution.
4. A simple and extremely fast heuristic.

## Minimal example
```julia
using Graphs
using MaximumIndependentSet

seed = 16031954
g = random_regular_graph(100, 5; seed = seed) # Generate a random graph of 100 nodes and degree 5 for each node
status, sol = mis_cut_branching(g) # Solve the MIS using the Cut-Branching method of Hespe et al. (2021). It returns an optimal solution
status, sol = mis_heuristic(g) # Find a feasible solution using a greedy heuristic
status, sol = mis_mip(g) # Solve the MIS using a MIP. It uses GLPK by default, but other solvers can be passed through the keyword argument `optimizer`. A time limit can be passed through the keyword argument `time_limit`
```

## Return values
All three methods return a `Tuple{Int64, Vector{Int64}}`. The first return value (namely `status`) takes the value 0 if the solution found is proven optimal, 1 otherwise. The second return value (namely `sol`) contains the solution found. 

## Note on Xiao and Nagamochi's method
The upstream code of this library is buggy. The current code may return an infeasible solution. It should not be used if an optimality certificate is required. For an exact method, prefer the Cut-Branching method of Hespe et al. (2021) or the MIP-based solver. For an heuristic solution, prefer the simple yet efficient greedy heuristic.