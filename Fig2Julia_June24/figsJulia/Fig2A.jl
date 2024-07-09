# This script plots 100 orbits of the non-autonomous system, 
# with red orbits ending at the top and blue at the bottom

# Load params
include("./functions_params/init_params_ebmFt.jl")
params=Params()

# Test runs
using DifferentialEquations
#using Plots
using CairoMakie
CairoMakie.activate!(type = "svg")

tspan = (0.,tend)

# Near first temperature equilibrium
y0a = [Teq, 0, 0, 0]
v1 = [1, 1, 1, 1] #scale for each (taken same here)
y01 = (r) -> y0a .+ r .* v1 

include("./functions_params/ebmFt.jl")


f = Figure(resolution=(400,400),fontsize=14)
ax = Axis(f[1,1], limits = (-50, 150, -3, 19), xlabel="t (years)",ylabel="ΔT (K)", aspect=AxisAspect(1))

# Initialize the plot with no legend
#using Plots.PlotMeasures #to be able to use "mm"
#plot(legend=false, tickfont=font(11), linewidth=1, framestyle=:box, xlims=(-50,150), margin=5mm, ylims=(271, 293))

# Multiple runs
nruns = 100
yend = Array{Float64}(undef, nruns)
ebm = (y, p, t) -> ebmFt(y, t, p)

# Set transparency level
alpha_level = 0.3

@time begin
for i in 1:nruns
    ODEprob = ODEProblem(ebm, y01(rand(4)), tspan, params)
    #using RK4 here with dt=.01 because the transfer operator also used that
    sol = solve(ODEprob, Tsit5(), reltol=1e-6, abstol=1e-6)#solve(prob, RK4(), dt=.01)
    yend[i] = sol.u[end][1]

    # Choose color based on final temperature
    col = yend[i] > 280 ? (:red, alpha_level) : (:blue, alpha_level)
    lines!(ax, sol.t .-150, getindex.(sol.u, 1).-274, color=col, linewidth=1)
end
end

# Save the plot
save("Orbits100asymptotic.pdf",f) # don't use svg extension (leads to png due to bug)

