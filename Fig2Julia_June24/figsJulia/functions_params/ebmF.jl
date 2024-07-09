function ebmF(y, par::Params)

    # scaling for Lorenz
    s = par.secpy / par.tau_NV 

    # Temperature function
    dTdt = (T, alpha, mu) -> par.Q0 * (1 - alpha) - par.eps * par.sigma * T^4 + mu

    # Coupling to the energy balance model + forcing
    mu_NV = par.mu_NV(y[2], par) + par.A0 * log(par.amplification)

    # Whole system: (temperature, Lorenz 1, Lorenz 2, Lorenz 3)
    dydt = [par.secpy / par.C_T * (dTdt(y[1], par.alpha_0(y[1], par), par.mu(par)) + mu_NV);
            s * par.sigma_L * (y[3] - y[2]); 
            s * (y[2] * (par.rho_L - y[4]) - y[3]); 
            s * (y[2] * y[3] - par.beta_L * y[4])]

    return dydt
end
