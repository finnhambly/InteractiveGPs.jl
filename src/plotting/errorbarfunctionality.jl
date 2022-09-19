# enabling scatterplot for Points with uncertainty (with measurements)
function MakieCore.convert_arguments(
    P::PointBased, positions::Vector{Point2{Measurement{Float64}}}
)
    return convert_arguments(P, value.(first.(positions)), value.(last.(positions)))
end
function MakieCore.convert_arguments(
    P::PointBased, x::AbstractVector{<:Measurement}, y::AbstractVector{<:Measurement}
)
    return convert_arguments(P, value.(x), value.(y))
end
function MakieCore.convert_arguments(
    P::PointBased, x::AbstractVector{<:Real}, y::AbstractVector{<:Measurement}
)
    return convert_arguments(P, x, value.(y))
end
function MakieCore.convert_arguments(
    P::PointBased, x::AbstractVector{<:Measurement}, y::AbstractVector{<:Real}
)
    return convert_arguments(P, value.(x), y)
end

# errorbars
function MakieCore.convert_arguments(
    P::Type{<:Errorbars}, positions::Vector{Point2{Measurement{Float64}}}
)
    return convert_arguments(
        P,
        value.(first.(positions)),
        value.(last.(positions)),
        uncertainty.(last.(positions)),
    )
end
function MakieCore.convert_arguments(
    P::Type{<:Errorbars},
    x::AbstractVector{<:Measurement},
    y::AbstractVector{<:Measurement},
    e::AbstractVector{<:Measurement},
)
    return convert_arguments(P, value.(x), value.(y), uncertainty.(e))
end
function MakieCore.convert_arguments(
    P::Type{<:Errorbars}, x::AbstractVector{<:Measurement}, y::AbstractVector{<:Real}
)
    return convert_arguments(P, value.(x), y, uncertainty.(x))
end
function MakieCore.convert_arguments(
    P::Type{<:Errorbars}, x::AbstractVector{<:Real}, y::AbstractVector{<:Measurement}
)
    return convert_arguments(P, x, value.(y), uncertainty.(y))
end

# band
function MakieCore.convert_arguments(
    P::Type{<:Band}, x::AbstractVector{<:Measurement}, y::AbstractVector{<:Measurement}
)
    return convert_arguments(
        P, value.(x), value.(y) - uncertainty.(y), value.(y) + uncertainty.(y)
    )
end
function MakieCore.convert_arguments(
    P::Type{<:Band}, x::AbstractVector{<:Real}, y::AbstractVector{<:Measurement}
)
    return convert_arguments(P, x, value.(y) - uncertainty.(y), value.(y) + uncertainty.(y))
end