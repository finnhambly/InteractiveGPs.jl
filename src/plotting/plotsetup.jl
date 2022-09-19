using GLMakie.Makie.ColorSchemes: Set1_4

function create_figure()
    # create a custom type that gives the variables and title
    set_theme!(
        palette=(color=Set1_4,),
        patchcolor=(Set1_4[2], 0.2),
        Axis=(limits=((0, 1), nothing),),
    )
    fig = Figure()
    ax = Axis(fig[1, 1]; xlabel="x", ylabel="y", title="posterior (default parameters)")
    return fig, ax
end

struct GPObservables
    positions
    ℓ::Observable{Float64}
    σ::Observable{Float64}
    k::Observable
    mean::Observable{Union{Expr,Nothing}}
    gp::Observable{GP}
    gpx::Observable{AbstractGPs.FiniteGP}
    posterior_gp::Observable{AbstractGPs.PosteriorGP}
end

function create_observables(points=[Point2(0.0, measurement(1.0, 0.5))])
    ℓ = Observable(1.0)
    σ = Observable(1.0)
    # make the kernel choice an observable
    k = @lift($σ * (SqExponentialKernel() ∘ ScaleTransform(1 / $ℓ)))
    mean = Observable(:(0*x)) # set mean prior 
    # gp = @lift(GP($mean, $k)) # this works, but the corresponding interactive element is slow
    gp = @lift(GP($k)) 
    positions = Observable(points)
    gpx = @lift($gp(value.(first.($positions)), uncertainty.(last.($positions))))
    posterior_gp = @lift(posterior($gpx, value.(last.($positions))))
    observables = GPObservables(positions, ℓ, σ, k, mean, gp, gpx, posterior_gp)
    return observables
end

function plot_observables!(positions, gp)
    gpplot = plot!(0:0.01:1, gp; label=false, bandscale=1)
    errorbarplot = errorbars!(positions)
    scatterplot = scatter!(positions; label="Train data", markersize=15)
    return scatterplot, errorbarplot, gpplot
end