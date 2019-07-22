module Fashionista

export makeover

using Cassette

abstract type AbstractStyle end

struct DefaultStyle <: AbstractStyle end

struct UnknownStyle <: AbstractStyle end
struct ConflictStyle <: AbstractStyle end

@inline call(::DefaultStyle, f, args...; kwargs...) = f(args...; kwargs...)
@inline call(::UnknownStyle, f, args...; kwargs...) = error("This call has no style, this call has no class")
@inline call(::ConflictStyle, f, args...; kwargs...) = error("Don't wear plaid with stripes")

@inline dressup(::F, ::Arg) where {F, Arg} = DefaultStyle()

@inline fashionshow(s1, s2) = s1 === s2 ? s1 : UnknownStyle()

@inline resultstyle(s1, s2) = s1 === s2 ? s1 : error("Don't wear plaid with stripes.")
@inline resultstyle(s1, ::UnknownStyle) = s1
@inline resultstyle(::UnknownStyle, s2) = s2
@inline resultstyle(::UnknownStyle, ::UnknownStyle) = error("Style is too avant-garde.")

function dressup(f, head, tail, args...)
    s1 = dressup(f, arg)
    s2 = callstyle(f, tail, args...)
    resultstyle(fashionshow(s1, s2), fashionshow(s2, s1))
end
dressup(f) = DefaultStyle()

Cassette.@context FashionistaContext;

Cassette.overdub(::FashionistaContext, f, args...) = call(dressup(f, args...), f, args...)

makeover(f, args...) = Cassette.overdub(FashionistaContext(), f, args...)

end # module
