import AbstractGPs: _map_meanfunction, MeanFunction, GP, Kernel

struct MeanExpression{Tf} <: MeanFunction
    expr::Tf
end

GP(mean::Expr, kernel::Kernel) = GP(MeanExpression(mean), kernel)

function _map_meanfunction(m::MeanExpression, x::AbstractVector) 
    f = @eval (x) -> $(m.expr)
    map(x -> Base.invokelatest(f, x), x)
end