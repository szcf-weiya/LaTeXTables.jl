using Printf

writeline(io, str...) = write(io, str..., "\n")
# suppose each row has the same number of subrows
# TODO: varied subrows and subcolumns
# abstractmatrix allows transposes of matrix
"""
    print2tex()

Print a structural result to a latex table.

# Examples

TODO: It seems that jldoctest does not generate result files `ex1.tex` in Documenter.jl.

```jldoctest
julia> μ = [[1 2 3 4; 5 6 7 8], [4 3 2 1; 8 7 6 5]]
2-element Vector{Matrix{Int64}}:
 [1 2 3 4; 5 6 7 8]
 [4 3 2 1; 8 7 6 5]

julia> σ = [ones(Int, 2, 4), ones(Int,2,4)]
2-element Vector{Matrix{Int64}}:
 [1 1 1 1; 1 1 1 1]
 [1 1 1 1; 1 1 1 1]

julia> print2tex(μ, σ, ["A", "B"], ["a", "b"], ["1","2"], ["x", "y"], file = "ex1.tex")
noc = 0
14

julia> tex2png("ex1.tex")
```
"""
function print2tex(A::AbstractVector{T}, rownames::AbstractVector{String}, colnames::AbstractArray{String};
                    subcolnames = nothing,
                    subrownames = nothing,
                    A2 = nothing, colnames2 = nothing,
                    colnames_of_rownames = ["level0", "level1"], # assume only two levels
                    isbf = nothing,
                    format = "2e", # raw
                    file = "/tmp/tmp.tex") where T <: AbstractMatrix
    nrow = length(rownames)
    if isnothing(subcolnames)
        ncol = length(colnames)
        ncol0 = length(colnames)
        ncol1 = 1
    else
        ncol0 = length(colnames)
        ncol1 = length(subcolnames)
        ncol = Int(ncol0 * ncol1)
    end
    open(file, "w") do io
        write(io, raw"\begin{tabular}{" * repeat('c', ncol + 2) * raw"}", "\n")
        writeline(io, raw"\toprule")
        write(io, raw"\multirow{2}{*}{", colnames_of_rownames[1], "} & ", 
        raw"\multirow{2}{*}{", colnames_of_rownames[2], "}")
        # header
        if isnothing(subcolnames)
            for i = 1:ncol
                write(io, "&", colnames[i])
            end
        else
            # colnames at the first level
            for i = 1:ncol0
                write(io, "&" * raw"\multicolumn{", "$ncol1}{c}{", colnames[i], "}")
            end
            writeline(io, raw"\tabularnewline")
            left = 2 + 1 # now rowlevbel equals to 2
            for i = 1:ncol0
                right = left + ncol1 - 1
                writeline(io, raw"\cmidrule(lr){", "$left-", "$right}")
                left = right + 1
            end
            # colnames at the second level
            write(io, "&") # one more for the two-level rownames
            for i = 1:ncol0
                for j = 1:ncol1
                    write(io, "&", subcolnames[j])
                end
            end
        end
        writeline(io, raw"\tabularnewline")
        writeline(io, raw"\midrule")
        for j = 1:nrow
            writeline(io, raw"\midrule")
            L = size(A[j], 1)
            for l = 1:L
                if l == 1
                    write(io, raw"\multirow{", "$L}{*}{", rownames[j], "}")
                end
                write(io, "&", subrownames[l])
                for i = 1:ncol
                    if length(A[j][l, i]) == 1
                        if !isnothing(isbf) && isbf[j][l, i]
                            write(io, "&", "\\textbf{", (@sprintf "%.2e" A[j][l, i]), "}")
                        else
                            if format == "raw"
                                write(io, "& $(A[j][l, i])")
                            else
                                write(io, "&", @sprintf "%.2e" A[j][l, i])
                            end
                        end
                    elseif length(A[j][l, i]) == 2
                        if !isnothing(isbf) && isbf[j][l, i]
                            write(io, "& (\\textbf{", (@sprintf "%.2e" A[j][l, i][1]), ", ", (@sprintf "%.2e" A[j][l, i][2]), ")}")
                        else
                            write(io, "& (", (@sprintf "%.2e" A[j][l, i][1]), ", ", (@sprintf "%.2e" A[j][l, i][2]), ")")
                        end
                    else
                        @warn "not implemented for tuple with length larger than 3"
                    end
                end
                writeline(io, raw"\tabularnewline")
            end
        end
        writeline(io, raw"\bottomrule")
        writeline(io, raw"\end{tabular}")
    end
end

function print2tex(A::AbstractMatrix, rownames::AbstractVector{String}, colnames::AbstractArray{String};
                    subcolnames = nothing,
                    isbf = nothing,
                    colname_of_row = "row",
                    A2 = nothing, colnames2 = nothing,
                    file = "/tmp/tmp.tex")
    nrow = length(rownames)
    if isnothing(subcolnames)
        ncol = length(colnames)
        ncol0 = length(colnames)
        ncol1 = 1
    else
        ncol0 = length(colnames)
        ncol1 = length(subcolnames)
        ncol = Int(ncol0 * ncol1)
    end
    @assert size(A) == (nrow, ncol)
    open(file, "w") do io
        write(io, raw"\begin{tabular}{" * repeat('c', ncol + 1) * raw"}", "\n")
        writeline(io, raw"\toprule")
        # header
        if isnothing(subcolnames)
            write(io, colname_of_row)
            for i = 1:ncol
                write(io, "&", colnames[i])
            end
        else
            write(io, raw"\multirow{2}{*}{", colname_of_row, "}")
            # colnames at the first level
            for i = 1:ncol0
                write(io, "&" * raw"\multicolumn{", "$ncol1}{c}{", colnames[i], "}")
            end
            writeline(io, raw"\tabularnewline")
            left = 2
            for i = 1:ncol0
                right = left + ncol1 - 1
                writeline(io, raw"\cmidrule(lr){", "$left-", "$right}")
                left = right + 1
            end
            # colnames at the second level
            for i = 1:ncol0
                for j = 1:ncol1
                    write(io, "&", subcolnames[j])
                end
            end
        end
        writeline(io, raw"\tabularnewline")
        writeline(io, raw"\midrule")
        for j = 1:nrow
            write(io, rownames[j])
            for i = 1:ncol
                if length(A[j, i]) == 1
                    if !isnothing(isbf) && isbf[j, i]
                        write(io, "& \\textbf{", (@sprintf "%.2e" A[j, i]), "}")
                    else
                        write(io, "&", @sprintf "%.2e" A[j, i])
                    end
                elseif length(A[j, i]) == 2
                    if !isnothing(isbf) && isbf[j, i]
                        write(io, "& \\textbf{(", (@sprintf "%.2e" A[j, i][1]), ", ", (@sprintf "%.2e" A[j, i][2]), ")}")
                    else
                        write(io, "& (", (@sprintf "%.2e" A[j, i][1]), ", ", (@sprintf "%.2e" A[j, i][2]), ")")
                    end
                else
                    @warn "not implemented for tuple with length larger than 3"
                end
            end
            writeline(io, raw"\tabularnewline")
        end
        if !isnothing(A2)
            writeline(io, raw"\midrule")
            if !isnothing(colnames2)
                for i = 1:ncol
                    write(io, "&", colnames2[i])
                end
                writeline(io, raw"\tabularnewline")
                writeline(io, raw"\midrule")
            end
            for j = 1:nrow
                write(io, rownames[j])
                for i = 1:ncol
                    if length(A2[j, i]) == 1
                        write(io, "&", @sprintf "%.2e" A2[j, i])
                    elseif length(A2[j, i]) == 2
                        write(io, "& (", (@sprintf "%.2e" A2[j, i][1]), ", ", (@sprintf "%.2e" A2[j, i][2]), ")")
                    else
                        @warn "not implemented for tuple with length larger than 3"
                    end
                end
                writeline(io, raw"\tabularnewline")
            end    
        end
        writeline(io, raw"\bottomrule")
        writeline(io, raw"\end{tabular}")
    end
end

function print2tex(μ::AbstractVector{T}, σ::AbstractVector{T}; 
                        rownames::AbstractVector{Any}, colnames::AbstractVector{Any}) where T <: AbstractFloat
    if all(isa.(rownames, String)) # Vector{String}
        if all(isa.(colnames, String)) # Vector{String}
            @warn "not implemented yet"
        end
    else
        @warn "not implemented yet"
    end
end

function print2tex(μ::AbstractVector{T}, σ::AbstractVector{T}, 
                    rownames::AbstractVector{String}, colnames::AbstractVector{String},
                    subrownames::AbstractVector{String}, subcolnames::AbstractVector{String}; 
                    colnames_of_rownames = ["level0", "level1"], file = "/tmp/tmp.tex",
                    other_cols = nothing, other_col_names = nothing,
                    other_cols_σ = nothing,
                    right_cols = nothing, right_col_names = nothing,
                    isbf = nothing,
                    right_align = 'l', # a better way?
                    sigdigits = 4) where T <: AbstractMatrix
    @assert length(rownames) == length(μ) == length(σ)
    nrow = length(μ)
    rowlevel = 2
    ncol0 = length(colnames)
    ncol1 = length(subcolnames)
    ncol = ncol0 * ncol1 # plus levels of rownames
    if isnothing(other_cols)
        noc = 0
    else
        noc = size(other_cols[1], 2)
    end
    println("noc = $noc")
    if isnothing(right_cols)
        nor = 0
    else
        nor = length(right_cols) # use list
    end
    open(file, "w") do io
        write(io, raw"\begin{tabular}{" * repeat('c', ncol + 2 + noc) * repeat(right_align, nor) * raw"}", "\n")
        writeline(io, raw"\toprule")
        # colnames at the first level
        # write(io, "&")
        write(io, raw"\multirow{2}{*}{", colnames_of_rownames[1], "} & ", 
                  raw"\multirow{2}{*}{", colnames_of_rownames[2], "}")
        if !isnothing(other_cols)
            for i = 1:noc
                write(io, raw"& \multirow{2}{*}{", other_col_names[i], "}")
            end
        end
        for i = 1:ncol0
            write(io, "&" * raw"\multicolumn{", "$ncol1}{c}{", colnames[i], "}")
        end
        if !isnothing(right_cols)
            for i = 1:nor
                write(io, raw"& \multirow{2}{*}{", right_col_names[i], "}")
            end
        end
        writeline(io, raw"\tabularnewline")
        # writeline(io, raw"\cmidrule{3-", "$(ncol+2)}")
        left = 3 + noc
        for i = 1:ncol0
            right = left + ncol1 - 1
            writeline(io, raw"\cmidrule(lr){", "$left-", "$right}")
            left = right + 1
        end
        # colnames at the second level
        write(io, "&")
        for i = 1:noc
            write(io, "&")
        end
        for i = 1:ncol0
            for j = 1:ncol1
                write(io, "&", subcolnames[j])
            end
        end
        writeline(io, raw"\tabularnewline")
        for i = 1:nrow
            writeline(io, raw"\midrule")
            # μi = round.(μ[i], sigdigits = sigdigits)
            # σi = round.(σ[i], sigdigits = sigdigits)
            m = size(μ[i], 1)
            for j = 1:m
                if j == 1
                    write(io, raw"\multirow{", "$m}{*}{", rownames[i], "}")
                end
                write(io, "&", subrownames[j])
                for ii in 1:noc
                    if isnothing(other_cols_σ)
                        write(io, "& $(@sprintf "%.2e" other_cols[i][j, ii])")
                    else
                        write(io, "& $(@sprintf "%.2e" other_cols[i][j, ii]) ($(@sprintf "%.1e" other_cols_σ[i][j, ii]))")
                    end
                end
                # write rownames
                for k = 1:ncol
                    if isnothing(isbf)
                        write(io, "& $(@sprintf "%.2e" μ[i][j, k]) ($(@sprintf "%.1e" σ[i][j, k]))")
                    else                        
                        if isbf[i][j, k]
                            write(io, "& \\textbf{$(@sprintf "%.2e" μ[i][j, k])} ($(@sprintf "%.1e" σ[i][j, k]))")
                        else
                            write(io, "& $(@sprintf "%.2e" μ[i][j, k]) ($(@sprintf "%.1e" σ[i][j, k]))")
                        end
                    end
                end
                if !isnothing(right_cols)
                    for ii = 1:nor
                        write(io, "& $(right_cols[ii][i][j])")
                    end
                end
                writeline(io, raw"\tabularnewline")
            end
        end
        writeline(io, raw"\bottomrule")
        writeline(io, raw"\end{tabular}")
    end
end
