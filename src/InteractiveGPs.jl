module InteractiveGPs

using GLMakie
using GLMakie: GLFW
using AbstractGPs
using StatsFuns
using Measurements
import Measurements: value, uncertainty
using AbstractGPsMakie
using MakieCore

export launch

include("meanexpression.jl")
include("plotting/errorbarfunctionality.jl")
include("plotting/interactivity.jl")
include("plotting/plotsetup.jl")

function launch()
    # TODO enable launch of specific variables
    # and load the points+uncertainties, GP, etc.
    fig, ax = create_figure()
    observables = create_observables()
    scatterplot, _, _ = plot_observables!(observables.positions, observables.posterior_gp)
    enable_interactivity!(fig, ax, scatterplot, observables)
    return observables
end


end # module
