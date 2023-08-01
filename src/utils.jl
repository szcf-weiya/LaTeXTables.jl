"""
    star_pval(x)
    
Annotate significance with symbols. Refer to `?symnum` in R.

# Examples

```jldoctest
julia> star_pval([0.0001, 0.1])
2-element Vector{String}:
 "1.00e-04 (***)"
 "1.00e-01"
```
"""
function star_pval(x::AbstractVector)
    n = length(x)
    res = Array{String, 1}(undef, n)
    for i = 1:n
        if x[i] < 1e-3
            s = "***"
        elseif x[i] < 1e-2
            s = "**"
        elseif x[i] < 5e-2
            s = "*"
        elseif x[i] < 1e-1
            s = "."
        else
            s = ""
        end
        num = @sprintf "%.2e" x[i]
        if s != ""
            res[i] = "$num ($s)"
        else
            res[i] = "$num"
        end
    end
    return res
end