# PARAMETER INITIALISATION
using Parameters # to permit keyword arguments in params struct

# Initialise parameters
# required parameters/functions before initialisation
Teq=274
alpha_0 = (T, p) -> p.alpha_1 + (p.alpha_2 - p.alpha_1) * (1 + tanh(p.K_alpha * (T - p.T_alpha))) / 2
mu0 = (Teq, p) -> p.eps * p.sigma * Teq^4 - p.Q0 * (1 - alpha_0(Teq, p))

# Define structure with default parameters
@with_kw struct Params
    alpha_0::Function = alpha_0
    Q0::Float64 = 341.3 # Incoming solar radiation
    alpha_1::Float64 = 0.6
    alpha_2::Float64 = 0.52
    T_alpha::Float64 = 280
    K_alpha::Float64 = 1.0
    sigma::Float64 = 5.67e-8 # Stefan-Boltzmann constant
    eps::Float64 = 0.43 # Emissivity
    C_T::Float64 = 5e8 # Heat capacity
    secpy::Int = 31556926 # Seconds per year
# Set background CO2 forcing such that Teq is an equilibrium:
    mu0::Function = mu0
# LORENZ-63 COMPONENT:
    sigma_L::Float64 = 10
    rho_L::Float64 = 28
    beta_L::Float64 = 8. / 3
# Coupling function, strength and timescale for the Lorenz system:
    nu_NV::Float64 = 5
    tau_NV::Float64 = 6e7 # 3e8 is a timescale of 10 years
    mu_NV::Function = (x, p) -> p.nu_NV * sin(pi * x / 20)
#FORCING:
    A0::Float64 = 5.35
    mu::Function = (p) -> mu0(Teq,p) # background CO2 forcing
    amplification::Float64 = 1.
end
