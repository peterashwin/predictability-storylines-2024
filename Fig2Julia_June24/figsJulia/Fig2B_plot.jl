using JLD2
@load "DATA_TippingProbability_asymptotic.jld2"

#using RadeonProRender #TO CHECK LATER (PLOTTING STILL EXPERIMENTAL)
#RadeonProRender.Context()

using GLMakie

# be careful here! Make sure this is correct
ts = convert(Vector{Float64},LinRange(100,300,201)).-150.
Ts = convert(Vector{Float64},LinRange(271,293,221)).-274.
ps = prob[100:300, 11:231]
pts = ptip[100:300,11:231]

# colour scale
bluetored = cgrad([:blue, :red])

# light position DOESN'T SEEM TO WORK and LSCene is buggy
fig = Figure(resolution = (3000, 3000),fontsize=30) 
ax = Axis3(fig[1:3, 1],aspect=(1,1,.175),xlabel="t (years)",ylabel="ΔT (K)",zlabel="")
pl=surface!(ts, Ts, ps,color=pts,colormap=bluetored, diffuse=Vec3f(.5, .5, .5), specular=Vec3f(.8, .8, .8), ssao=true)
xlims!(ax, -50, 150)  
ylims!(ax, -3, 19)  

Colorbar(fig[2, 2], pl, label = L"P(\Delta T_\infty>5)")

# Adding contours
#contour3d!(ts, Ts, ps, levels = 12, linewidth = .75, color = :black)

display(fig)

save("orbitsMonteCarlo.png",fig)
