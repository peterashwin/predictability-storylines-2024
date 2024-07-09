# Load params
# RUN IN SHELL BEFORE: export JULIA_NUM_THREADS=8

include("./functions_params/init_params_ebmFt.jl")
params=Params()

# Test runs
using DifferentialEquations
using Plots

tspan = (0.,tend)

# Near first temperature equilibrium
y0a = [Teq, 0, 0, 0]
v1 = [1, 1, 1, 1]
y01 = (r) -> y0a .+ r .* v1

include("./functions_params/ebmFt.jl")

# Multiple runs
nruns = 1000000
ebm = (y, p, t) -> ebmFt(y, t, p)

# Determine the number of time steps based on your desired step size
dt = .1
nsteps = ceil(Int, (tend - tspan[1]) / dt)+1

# Preallocate array to store the results
orbits = Array{Float64}(undef, nsteps, nruns)

# takes 30h??
@time Threads.@threads for i in 1:nruns
    prob = ODEProblem(ebm, y01(rand(4)), tspan, params)
    sol = solve(prob, Tsit5(), reltol=1e-6, abstol=1e-6, saveat=dt)
    # Extract the first component of the solution at each time point
    for j in 1:nsteps
        orbits[j, i] = sol.u[j][1]
    end
end

using JLD2
@save "DATA_simulations_Orbitsdt01n10e6_asymptotic.jld2" orbits

bint=0:1:300#not used
binT=270:.1:300 

nt=length(bint)
nT=length(binT)

prob=zeros(nt,nT)
ptip=zeros(nt,nT)

@time Threads.@threads for i=1:nt-1 #~6.5h with Threads
    ixt=10*(i-1)+1:10*i
    for j=1:nT-1
        inbin=(orbits[ixt,:].>binT[j]).&(orbits[ixt,:].<binT[j+1])
        totinbin=sum(inbin)
        if totinbin!=0
            prob[i,j]=sum(inbin)/(10*nruns)

            orbvec=any(inbin,dims=1)[1,:]
            ptip[i,j]=sum(orbits[nsteps,orbvec].>280)/sum(orbvec)
        else
            ptip[i,j]=NaN
        end
    end
end

@save "DATA_TippingProbability_asymptotic.jld2" prob ptip bint binT dt nsteps nruns
