FILES INCLUDED
--------------

./
- Fig2A.jl: plots 200 orbits of the non-autonomous system, with red orbits ending at the top and blue at the bottom (Fig. 2A)
- Fig2B_simulations.jl: Integration of 10e6 orbits and tipping probability for Fig. 2B
- Fig2B_plot.jl: Plot Fig 2B

./function_params/
- ebmF.jl: autonomous chaotic ebm function where forcing is a constant
- ebmFt.jl: non-autonomous chaotic ebm function where forcing is function of time
- init_params_ebmF.jl: initialisation of parameters when using ebmF
- init_params_ebmFt.jl: initialisation of parameters when using ebmFt
- plotmarginalT.jl: function to project on T


USE
---

- Easiest to use via VS Code with Julia plugin. See 

https://code.visualstudio.com/docs/languages/julia

- If required install packages via the command:

using Pkg
Pkg.add("PackageName")

If the package is only available on github, use

using Pkg
Pkg.add(url="https://github.com/username/repository.git")


